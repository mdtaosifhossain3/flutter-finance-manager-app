import 'package:finance_manager_app/services/autoSync/auto_sync_service.dart';
import 'package:finance_manager_app/services/parser/sms_parser.dart';
import 'package:flutter_test/flutter_test.dart';

/// Messages the Android detector accepts (see AutoSyncDetectorTest.kt) with
/// the kind and amount it reports. The app must parse each one the same way,
/// or the pop-up would promise something the review screen can't show.
const samples = <String, (String, int)>{
  'Send Money Tk 500.00 to 01712345678 successful. Ref grocery. Fee Tk 0.00. '
          'Balance Tk 2,345.50. TrxID BJT8K2M1QX at 29/10/2026 10:15':
      ('sent', 500),
  'You have received Tk 1,500.00 from 01812345678. Ref family. Fee Tk 0.00. '
          'Balance Tk 3,210.50. TrxID BJT8K2M1QY at 28/10/2026 19:42':
      ('received', 1500),
  'Payment Tk 850.00 to Shwapno successful. Fee Tk 0.00. Balance Tk 1,500.00. '
          'TrxID BJT8K2M1QZ at 29/10/2026 12:00':
      ('payment', 850),
  'Cash Out Tk 2,000.00 to 01912345678 successful. Fee Tk 37.00. '
          'Balance Tk 500.00. TrxID BJT8K2M1RA at 29/10/2026 13:00':
      ('cash_out', 2000),
  'Recharge Tk 50.00 to 01712345678 successful. Fee Tk 0.00. '
          'Balance Tk 950.00. TrxID BJT8K2M1RB at 29/10/2026 15:00':
      ('recharge', 50),
  'Money Sent. Amount: Tk 300.00 Receiver: 01612345678 Ref: N/A '
          'TxnID: 73ABCDEF Balance: Tk 1,200.00 29/10/2026 14:22':
      ('sent', 300),
  'Your A/C XXXX1234 has been debited by BDT 5,000.00 on 29-10-2026 for POS '
          'purchase at AGORA. Avl Bal BDT 20,000.00':
      ('payment', 5000),
};

const _kindOfTitleKey = {
  'sms_cash_out': 'cash_out',
  'sms_cash_in': 'cash_in',
  'sms_atm': 'atm',
  'sms_add_money': 'add_money',
  'sms_recharge': 'recharge',
  'sms_bill': 'bill',
  'sms_received_from': 'received',
  'sms_sent_to': 'sent',
  'sms_payment_to': 'payment',
  'sms_debit': 'debit',
};

AutoSyncItem item(String text, String kind, int amount, {String? party}) =>
    AutoSyncItem.fromMap({
      'id': 1730190000000,
      'text': text,
      'source': 'com.google.android.apps.messaging',
      'sender': 'bKash',
      'amount': '$amount',
      'kind': kind,
      'party': party,
      'trxId': null,
      'postedAt': DateTime(2026, 10, 29, 10).millisecondsSinceEpoch,
    });

void main() {
  group('Android detector and SmsParser agree', () {
    samples.forEach((text, expected) {
      test(expected.$1, () {
        final p = SmsParser.parse(text, now: DateTime(2026, 10, 29))!;
        expect(_kindOfTitleKey[p.titleKey], expected.$1);
        expect(p.amount, expected.$2);
      });
    });
  });

  group('AutoSyncItem', () {
    test('reads the map from Android', () {
      final i = item(samples.keys.first, 'sent', 500, party: '01712345678');
      expect(i.id, 1730190000000);
      expect(i.amount, 500);
      expect(i.party, '01712345678');
      expect(i.trxId, isNull);
      expect(i.postedAt, DateTime(2026, 10, 29, 10));
      expect(i.parsed?.wallet, 'bkash');
    });

    test('kinds map to the SMS import texts', () {
      expect(item('', 'sent', 1).titleKey, 'sms_sent_to');
      expect(item('', 'received', 1).titleKey, 'sms_received_from');
      expect(item('', 'cash_out', 1).titleKey, 'sms_cash_out');
      expect(item('', 'unknown', 1).titleKey, 'sms_debit');
    });

    test('income and transfer flags pick the right question', () {
      expect(item('', 'received', 1).isIncome, isTrue);
      expect(item('', 'cash_out', 1).isTransfer, isTrue);
      expect(item('', 'atm', 1).isTransfer, isTrue);
      expect(item('', 'sent', 1).isIncome, isFalse);
      expect(item('', 'sent', 1).isTransfer, isFalse);
    });

    test('tolerates missing fields', () {
      final i = AutoSyncItem.fromMap({'id': 5});
      expect(i.amount, 0);
      expect(i.text, '');
      expect(i.parsed, isNull);
    });
  });

  test('joined review text splits back into the same messages', () {
    final joined = samples.keys.join('\n\n');
    expect(SmsParser.parseAll(joined).length, samples.length);
  });

  test('service is a no-op off Android', () async {
    // Tests run on the host, not Android: nothing should throw.
    expect(await AutoSyncService.pending(), isEmpty);
    expect((await AutoSyncService.status()).working, isFalse);
    expect(await AutoSyncService.takeOpenRequest(), isNull);
  });
}
