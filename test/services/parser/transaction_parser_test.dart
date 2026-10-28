import 'package:finance_manager_app/data/category/category_item_data.dart';
import 'package:finance_manager_app/data/category/income_item_data.dart';
import 'package:finance_manager_app/services/parser/parser_dictionary.dart';
import 'package:finance_manager_app/services/parser/transaction_parser.dart';
import 'package:flutter_test/flutter_test.dart';

final today = DateTime(2026, 10, 28);
final yesterday = DateTime(2026, 10, 27);

/// Expected transaction: title, income?, amount, category, date, payment.
typedef Tx = (String, bool, int, String, DateTime, String);

const exp = false;
const inc = true;

void expectParse(
  String input,
  List<Tx> expected, {
  Map<String, String> learned = const {},
}) {
  final result = TransactionParser(learned: learned).parse(input, today: today);
  final actual = [
    for (final t in result)
      (t.title, t.isIncome, t.amount, t.categoryKey, t.date, t.paymentMethod),
  ];
  expect(actual, expected, reason: input);
}

void main() {
  group('English', () {
    test('single expense', () {
      expectParse('I give wifi bill 500tk', [
        ('Internet Bill', exp, 500, 'bills_utilities', today, 'cash'),
      ]);
    });
    test('relative date and payment', () {
      expectParse('spent 250 on uber yesterday', [
        ('Ride Share', exp, 250, 'transportation', yesterday, 'cash'),
      ]);
      expectParse('3 days ago got 2k freelance from fiverr via nagad', [
        (
          'Freelance',
          inc,
          2000,
          'freelance_contracts',
          DateTime(2026, 10, 25),
          'nagad',
        ),
      ]);
    });
    test('income by category', () {
      expectParse('salary 35000', [
        ('Salary', inc, 35000, 'salary', today, 'cash'),
      ]);
    });
    test('plus never means income', () {
      expectParse('lunch 200+150', [
        ('Lunch', exp, 200, 'food_dining', today, 'cash'),
        ('Lunch', exp, 150, 'food_dining', today, 'cash'),
      ]);
    });
  });

  group('Bangla', () {
    test('two items, shared date, own payment', () {
      expectParse('গতকাল বিকাশে ১২০০ টাকা বাজার করলাম আর রিকশা ভাড়া ৫০', [
        ('Groceries', exp, 1200, 'groceries', yesterday, 'bkash'),
        ('Rickshaw Fare', exp, 50, 'transportation', yesterday, 'cash'),
      ]);
    });
    test('number words', () {
      expectParse('দুই হাজার পাঁচশো টাকা বাসা ভাড়া দিলাম', [
        ('House Rent', exp, 2500, 'housing', today, 'cash'),
      ]);
    });
    test('comma thousands', () {
      expectParse('বাড়ি ভাড়া ১২,০০০ টাকা', [
        ('House Rent', exp, 12000, 'housing', today, 'cash'),
      ]);
    });
    test('specific date', () {
      expectParse('১৫ই অক্টোবর ডাক্তার ৮০০', [
        ('Doctor', exp, 800, 'health_fitness', DateTime(2026, 10, 15), 'cash'),
      ]);
    });
    test('quantity is not an amount', () {
      expectParse('২টা বার্গার ৩৫০', [
        ('Fast Food', exp, 350, 'food_dining', today, 'cash'),
      ]);
    });
    test('space separated items', () {
      expectParse('চা ২০ সিঙ্গারা ৩০', [
        ('Tea & Coffee', exp, 20, 'food_dining', today, 'cash'),
        ('Snacks', exp, 30, 'food_dining', today, 'cash'),
      ]);
    });
    test('income verb', () {
      expectParse('বেতন পেলাম ৩০০০০ টাকা', [
        ('Salary', inc, 30000, 'salary', today, 'cash'),
      ]);
    });
    test('days ago', () {
      expectParse('৩ দিন আগে ওষুধ ৪৫০', [
        (
          'Medicine',
          exp,
          450,
          'health_fitness',
          DateTime(2026, 10, 25),
          'cash',
        ),
      ]);
    });
  });

  group('Banglish', () {
    test('breakfast today', () {
      expectParse('aj nasta 60 tk', [
        ('Breakfast', exp, 60, 'food_dining', today, 'cash'),
      ]);
    });
    test('kal means yesterday, typo tolerated, 1.5k', () {
      expectParse('kal resturant e 1.5k khoroch', [
        ('Food', exp, 1500, 'food_dining', yesterday, 'cash'),
      ]);
    });
    test('words before or after each amount', () {
      final both = [
        ('Rickshaw Fare', exp, 50, 'transportation', today, 'cash'),
        ('Bus Fare', exp, 30, 'transportation', today, 'cash'),
      ];
      expectParse('rickshaw 50 bus 30', both);
      expectParse('50 rickshaw 30 bus', both);
    });
    test('header clause applies to the list', () {
      expectParse('bazar: alu 50, piyaj 80, dim 120', [
        ('Vegetables', exp, 50, 'groceries', today, 'cash'),
        ('Vegetables', exp, 80, 'groceries', today, 'cash'),
        ('Eggs', exp, 120, 'groceries', today, 'cash'),
      ]);
      expectParse('bkash e pathalam: ammu 500, abbu 300', [
        ('Ammu', exp, 500, 'miscellaneous_expense', today, 'bkash'),
        ('Abbu', exp, 300, 'miscellaneous_expense', today, 'bkash'),
      ]);
    });
    test('date applies from where it is written', () {
      expectParse('ammu ke 500 dilam, 15 oct e netflix 300', [
        ('Ammu', exp, 500, 'miscellaneous_expense', today, 'cash'),
        (
          'Subscription',
          exp,
          300,
          'subscription_services',
          DateTime(2026, 10, 15),
          'cash',
        ),
      ]);
    });
    test('income verb turns expense category into income', () {
      expectParse('tuition theke 3000 pelam', [
        ('Tuition Fee', inc, 3000, 'side_income', today, 'cash'),
      ]);
      expectParse('abbu 1000 dilo', [
        ('Abbu', inc, 1000, 'miscellaneous_income', today, 'cash'),
      ]);
    });
    test('income verb favours income category', () {
      expectParse('office theke bonus 5000 aslo', [
        ('Salary', inc, 5000, 'salary', today, 'cash'),
      ]);
    });
    test('refund', () {
      expectParse('refund pelam 300 daraz theke', [
        ('Refund', inc, 300, 'refunds_reimbursements', today, 'cash'),
      ]);
    });
    test('kg is a quantity', () {
      expectParse('chal 5 kg 400', [
        ('Rice', exp, 400, 'groceries', today, 'cash'),
      ]);
    });
    test('payment with suffix', () {
      expectParse('bkash e 500 recharge korlam', [
        ('Mobile Recharge', exp, 500, 'bills_utilities', today, 'bkash'),
      ]);
    });
    test('sare tin hajar', () {
      expectParse('sare tin hajar diye juta kinlam', [
        ('Shoes', exp, 3500, 'shopping', today, 'cash'),
      ]);
    });
    test('specific phrase beats generic word', () {
      expectParse('bari vara 8000', [
        ('House Rent', exp, 8000, 'housing', today, 'cash'),
      ]);
      expectParse('bus vara 40', [
        ('Bus Fare', exp, 40, 'transportation', today, 'cash'),
      ]);
    });
    test('sentence dot separates', () {
      expectParse('cha 20. bus 40', [
        ('Tea & Coffee', exp, 20, 'food_dining', today, 'cash'),
        ('Bus Fare', exp, 40, 'transportation', today, 'cash'),
      ]);
    });
    test('unknown words become the title', () {
      expectParse('ammu ke 500', [
        ('Ammu', exp, 500, 'miscellaneous_expense', today, 'cash'),
      ]);
    });
    test('porshu and card', () {
      expectParse('porshu card e 2000 shopping', [
        ('Shopping', exp, 2000, 'shopping', DateTime(2026, 10, 26), 'debit'),
      ]);
    });
  });

  group('no amount', () {
    test('returns nothing', () {
      expect(TransactionParser().parse('hello', today: today), isEmpty);
      expect(TransactionParser().parse('aj bazar', today: today), isEmpty);
    });
    test('phone numbers are ignored', () {
      expect(
        TransactionParser().parse('01712345678 e pathalam', today: today),
        isEmpty,
      );
    });
  });

  group('learning', () {
    test('learned word beats the dictionary', () {
      expectParse(
        'ammu ke 500',
        [('Ammu', exp, 500, 'kids', today, 'cash')],
        learned: {'ammu': 'kids'},
      );
    });
    test('learned word matches with suffix', () {
      expectParse(
        'gymer fee 1500',
        [('Gymer Fee', exp, 1500, 'sports', today, 'cash')],
        learned: {'gym': 'sports'},
      );
    });
    test('returns words to learn from', () {
      final t = TransactionParser().parse('ammu ke 500 dilam', today: today);
      expect(t.single.words, ['ammu']);
    });
  });

  test('every dictionary category exists in the app', () {
    final appKeys = {
      ...categoryItems.map((c) => c.key),
      ...incomeCategoryItems.map((c) => c.key),
    };
    final used = {
      ...categoryKeywords.map((g) => g.category),
      ...incomeEquivalent.values,
      ...expenseEquivalent.values,
      'miscellaneous_income',
      'miscellaneous_expense',
    };
    expect(used.difference(appKeys), isEmpty);
    expect(incomeCategories, incomeCategoryItems.map((c) => c.key).toSet());
  });
}
