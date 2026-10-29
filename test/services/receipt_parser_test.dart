import 'package:finance_manager_app/services/receipt/receipt_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 10, 29, 20);

  group('ReceiptParser — printed English receipts', () {
    test('super shop POS slip', () {
      final r = ReceiptParser.parse('''
SHWAPNO
ACI Logistics Ltd.
House 12, Road 5, Dhanmondi
VAT Reg: 000123456-0101
Invoice No: 10293
Date: 28/10/2026 07:45 PM
Miniket Rice 5 kg 420.00
Soybean Oil 1 ltr 185.00
Egg 12 pcs 150.00
Sub Total 755.00
VAT 0.00
Discount 15.00
Total (Incl. VAT) 740.00
Cash 1000.00
Change 260.00
Thank you for shopping
''', now: now);
      expect(r.merchant, 'Shwapno');
      expect(r.date, DateTime(2026, 10, 28, 19, 45));
      expect(r.total, 740);
      expect(r.categoryKey, 'groceries');
      expect(r.weak, isFalse);
    });

    test('restaurant bill with grand total and two-column layout', () {
      final r = ReceiptParser.parse('''
Welcome to Dhaba Express Restaurant
Gulshan 2, Dhaka
Table No: 7   Waiter: Rafiq
29-Oct-2026 13:10
Chicken Biryani 2 x 280 560
Borhani 2 x 60 120
Total 680
Service Charge 34
Grand Total
Tk 714.00
''', now: now);
      expect(r.merchant, 'Dhaba Express Restaurant');
      expect(r.date, DateTime(2026, 10, 29, 13, 10));
      expect(r.total, 714);
      expect(r.categoryKey, 'food_dining');
    });

    test('pharmacy with lakh-style commas and Tk. prefix', () {
      final r = ReceiptParser.parse('''
Lazz Pharma
Kalabagan, Dhaka
Mobile: 01712-345678
2026-10-20
Napa Extra Tab 20 pcs Tk.50
Insulin Pen Tk.1,250
Net Payable Tk.1,300.00
''', now: now);
      expect(r.merchant, 'Lazz Pharma');
      expect(r.date, DateTime(2026, 10, 20, 12));
      expect(r.total, 1300);
      expect(r.categoryKey, 'health_fitness');
    });

    test('ignores phone numbers and totals of quantity', () {
      final r = ReceiptParser.parse('''
Coffee House
Hotline 09612345678
Date 15/10/2026
Latte 250
Total Qty: 3
Total: 750
''', now: now);
      expect(r.merchant, 'Coffee House');
      expect(r.total, 750);
    });
  });

  group('ReceiptParser — Bangla and hand-written', () {
    test('Bangla cash memo with Bangla digits', () {
      final r = ReceiptParser.parse('''
মায়ের দোয়া স্টোর
ক্যাশ মেমো
তারিখ: ২৭/১০/২০২৬
চাল ৫ কেজি ৩৫০
ডাল ২ কেজি ২৮০
তেল ১ লিটার ১৯০
সর্বমোট ৮২০ টাকা
''', now: now);
      expect(r.merchant, 'মায়ের দোয়া স্টোর');
      expect(r.date, DateTime(2026, 10, 27, 12));
      expect(r.total, 820);
      expect(r.categoryKey, 'groceries');
      // Bangla text: ask the user to check carefully.
      expect(r.weak, isTrue);
    });

    test('hand-written hisab without a total label guesses and flags it', () {
      final r = ReceiptParser.parse('''
বাজার
আলু ৬০
পেঁয়াজ ৮০
মাছ ৪৫০
''', now: now);
      expect(r.total, 450);
      expect(r.weak, isTrue);
    });

    test('মোট label on its own line', () {
      final r = ReceiptParser.parse('ঔষধ\nনাপা ৩০\nমোট\n৳ ১২০', now: now);
      expect(r.total, 120);
      expect(r.categoryKey, 'health_fitness');
    });
  });

  group('ReceiptParser — blurry / noisy OCR', () {
    test('garbage text is weak with no total', () {
      final r = ReceiptParser.parse('~~ ;; ,,\nI| l1 ..', now: now);
      expect(r.total, isNull);
      expect(r.weak, isTrue);
      expect(r.categoryKey, 'miscellaneous_expense');
    });

    test('empty text', () {
      final r = ReceiptParser.parse('', now: now);
      expect(r.merchant, isNull);
      expect(r.date, isNull);
      expect(r.total, isNull);
      expect(r.weak, isTrue);
    });

    test('future and impossible dates are ignored', () {
      expect(
        ReceiptParser.findDate('31/02/2026 then 15/12/2027', now: now),
        isNull,
      );
      expect(
        ReceiptParser.findDate('Bill 10/25/2026', now: now),
        DateTime(2026, 10, 25, 12),
      );
      expect(
        ReceiptParser.findDate('Oct 5, 2026', now: now),
        DateTime(2026, 10, 5, 12),
      );
    });
  });

  group('ReceiptDuplicateChecker', () {
    final existing = [
      DuplicateCandidate(
        transactionId: 1,
        imageHash: 'abc',
        title: 'Shwapno',
        amount: 740,
        date: DateTime(2026, 10, 28, 19, 45),
      ),
      DuplicateCandidate(
        transactionId: 2,
        title: 'Lunch',
        amount: 300,
        date: DateTime(2026, 10, 27),
      ),
    ];

    test('same photo', () {
      final m = ReceiptDuplicateChecker.find(
        imageHash: 'abc',
        amount: null,
        date: null,
        merchant: null,
        existing: existing,
      )!;
      expect(m.samePhoto, isTrue);
      expect(m.transactionId, 1);
    });

    test('same amount and day', () {
      final m = ReceiptDuplicateChecker.find(
        imageHash: 'other',
        amount: 740,
        date: DateTime(2026, 10, 28, 9),
        merchant: 'SHWAPNO Dhanmondi',
        existing: existing,
      )!;
      expect(m.samePhoto, isFalse);
      expect(m.transactionId, 1);
    });

    test('no match on another day', () {
      expect(
        ReceiptDuplicateChecker.find(
          imageHash: 'other',
          amount: 740,
          date: DateTime(2026, 10, 29),
          merchant: 'Shwapno',
          existing: existing,
        ),
        isNull,
      );
    });
  });
}
