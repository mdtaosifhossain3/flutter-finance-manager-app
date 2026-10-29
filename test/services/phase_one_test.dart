import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/models/walletModel/wallet_models.dart';
import 'package:finance_manager_app/services/parser/sms_parser.dart';
import 'package:finance_manager_app/services/recurring/recurring_schedule.dart';
import 'package:finance_manager_app/services/wallet/wallet_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

TransactionModel tx(String method, int amount, {bool income = false}) =>
    TransactionModel(
      type: income ? TransactionType.income : TransactionType.expense,
      date: DateTime(2026, 10, 1),
      title: 't',
      amount: amount,
      paymentMethod: method,
      icon: 'food',
      iconBgColor: 0,
      categoryKey: 'food_dining',
    );

void main() {
  final now = DateTime(2026, 10, 29, 9);

  group('SmsParser', () {
    test('bKash money received', () {
      final p = SmsParser.parse(
        'You have received Tk 1,500.00 from 01712345678. Ref family. '
        'Fee Tk 0.00. Balance Tk 3,210.50. TrxID BJT8K2M1QX at 28/10/2026 19:42',
        now: now,
      )!;
      expect(p.kind, SmsKind.income);
      expect(p.amount, 1500);
      expect(p.fee, 0);
      expect(p.wallet, 'bkash');
      expect(p.trxId, 'BJT8K2M1QX');
      expect(p.title, 'Received from 01712345678');
      expect(p.date, DateTime(2026, 10, 28, 19, 42));
    });

    test('bKash cash out is a transfer to cash with the fee', () {
      final p = SmsParser.parse(
        'Cash Out Tk 2,000.00 to 01812345678 successful. Fee Tk 37.00. '
        'Balance Tk 1,173.50. TrxID BJT9A1B2C3 at 29/10/2026 10:05',
        now: now,
      )!;
      expect(p.kind, SmsKind.transfer);
      expect(p.amount, 2000);
      expect(p.fee, 37);
      expect(p.wallet, 'bkash');
      expect(p.otherWallet, 'cash');
      expect(p.transferIntoWallet, isFalse);
    });

    test('bKash send money and payment', () {
      final send = SmsParser.parse(
        'Send Money Tk 500.00 to 01912345678 successful. Ref rent. '
        'Fee Tk 5.00. Balance Tk 668.50. TrxID BJT0000001 at 29/10/2026 11:00',
      )!;
      expect(send.kind, SmsKind.expense);
      expect(send.amount, 500);
      expect(send.fee, 5);

      final pay = SmsParser.parse(
        'Payment Tk 250.00 to Shwapno successful. Balance Tk 418.50. '
        'TrxID BJT0000002 at 29/10/2026 12:00',
      )!;
      expect(pay.kind, SmsKind.expense);
      expect(pay.categoryKey, 'shopping');
      expect(pay.title, 'Payment to Shwapno');
    });

    test('Nagad money received', () {
      final p = SmsParser.parse(
        'Money Received.\nAmount: Tk 800.00\nSender: 01612345678\n'
        'Ref: N/A\nTxnID: 73KD9XQ2\nBalance: Tk 1,050.00\n27/10/2026 08:15',
      )!;
      expect(p.kind, SmsKind.income);
      expect(p.amount, 800);
      expect(p.wallet, 'nagad');
      expect(p.trxId, '73KD9XQ2');
    });

    test('mobile recharge', () {
      final p = SmsParser.parse(
        'Mobile Recharge Tk 100.00 to 01712345678 successful. '
        'Balance Tk 950.00. TrxID BJT0000003 at 29/10/2026 13:00',
      )!;
      expect(p.categoryKey, 'bills_utilities');
      expect(p.title, 'Mobile recharge 01712345678');
      expect(p.kind, SmsKind.expense);
    });

    test('bank debit, credit and ATM', () {
      final debit = SmsParser.parse(
        'Your A/C XXXX1234 has been debited by BDT 5,000.00 on 25-10-2026. '
        'Available Bal BDT 20,000.00',
      )!;
      expect(debit.kind, SmsKind.expense);
      expect(debit.amount, 5000);
      expect(debit.wallet, 'bankTransfer');

      final salary = SmsParser.parse(
        'Your A/C XXXX1234 is credited with BDT 45,000.00 on 01-10-2026. Salary.',
      )!;
      expect(salary.kind, SmsKind.income);
      expect(salary.amount, 45000);

      final atm = SmsParser.parse(
        'BDT 3,000.00 withdrawn from A/C XXXX1234 at ATM DHANMONDI on 20-10-2026.',
      )!;
      expect(atm.kind, SmsKind.transfer);
      expect(atm.otherWallet, 'cash');
    });

    test('skips OTP and offers', () {
      expect(SmsParser.parse('Your bKash verification code is 123456'), isNull);
      expect(SmsParser.parse('Get 50% cashback this Eid!'), isNull);
    });

    test('splits several pasted messages', () {
      const text =
          'You have received Tk 100.00 from 01712345678. TrxID AAA111BBB at 28/10/2026 10:00\n'
          'Payment Tk 50.00 to Agora successful. TrxID CCC222DDD at 28/10/2026 11:00';
      final all = SmsParser.parseAll(text, now: now);
      expect(all.length, 2);
      expect(all[0].kind, SmsKind.income);
      expect(all[1].kind, SmsKind.expense);
    });
  });

  group('WalletCalculator', () {
    test('balances add opening, income, expense and transfers', () {
      final w = WalletCalculator.balances(
        openings: {'cash': 1000, 'bkash': 0},
        transactions: [
          tx('bkash', 5000, income: true),
          tx('cash', 200),
          tx('bkash', 37), // cash-out fee
        ],
        transfers: [
          WalletTransfer(
            fromMethod: 'bkash',
            toMethod: 'cash',
            amount: 2000,
            fee: 37,
            date: DateTime(2026, 10, 2),
          ),
        ],
      );
      final cash = w.firstWhere((b) => b.info.method == 'cash');
      final bkash = w.firstWhere((b) => b.info.method == 'bkash');
      expect(cash.balance, 1000 - 200 + 2000);
      expect(bkash.balance, 5000 - 37 - 2000);
      // Transfers move money but don't change the total.
      expect(w.fold(0, (s, b) => s + b.balance), 1000 + 5000 - 200 - 37);
    });

    test('shows the default wallets when nothing is set up', () {
      final w = WalletCalculator.balances(
        openings: {},
        transactions: [],
        transfers: [],
      );
      expect(w.map((b) => b.info.method), defaultWalletMethods);
    });

    test('opening is solved from the real balance', () {
      final w = WalletCalculator.balances(
        openings: {},
        transactions: [tx('cash', 300), tx('cash', 1000, income: true)],
        transfers: [],
      ).firstWhere((b) => b.info.method == 'cash');
      expect(WalletCalculator.openingFor(w, 5000), 4300);
      expect(WalletCalculator.cashOutFee(2000, 1.85), 37);
    });
  });

  group('RecurringSchedule', () {
    test('monthly on the 31st falls back to the last day', () {
      expect(
        RecurringSchedule.next(
          DateTime(2027, 1, 31),
          RecurringFrequency.monthly,
          31,
        ),
        DateTime(2027, 2, 28),
      );
      expect(
        RecurringSchedule.next(
          DateTime(2027, 2, 28),
          RecurringFrequency.monthly,
          31,
        ),
        DateTime(2027, 3, 31),
      );
    });

    test('weekly adds seven days', () {
      expect(
        RecurringSchedule.next(
          DateTime(2026, 10, 30),
          RecurringFrequency.weekly,
          5,
        ),
        DateTime(2026, 11, 6),
      );
    });

    test('lists due dates up to today, capped', () {
      final due = RecurringSchedule.dueDates(
        nextDate: DateTime(2026, 8, 5),
        frequency: RecurringFrequency.monthly,
        day: 5,
        today: DateTime(2026, 10, 29),
      );
      expect(due, [
        DateTime(2026, 8, 5),
        DateTime(2026, 9, 5),
        DateTime(2026, 10, 5),
      ]);
    });

    test('first date is this month or next', () {
      expect(
        RecurringSchedule.firstDate(
          RecurringFrequency.monthly,
          5,
          DateTime(2026, 10, 29),
        ),
        DateTime(2026, 11, 5),
      );
      expect(
        RecurringSchedule.firstDate(
          RecurringFrequency.monthly,
          29,
          DateTime(2026, 10, 29),
        ),
        DateTime(2026, 10, 29),
      );
    });
  });
}
