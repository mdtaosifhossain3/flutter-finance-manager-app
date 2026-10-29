import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/services/insights/insights_service.dart';
import 'package:finance_manager_app/services/insights/streak_service.dart';
import 'package:finance_manager_app/services/zakat/zakat_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

TransactionModel tx(
  DateTime date,
  int amount, {
  String category = 'food_dining',
  bool income = false,
}) => TransactionModel(
  type: income ? TransactionType.income : TransactionType.expense,
  date: date,
  title: category,
  amount: amount,
  paymentMethod: 'cash',
  icon: 'food',
  iconBgColor: 0,
  categoryKey: category,
);

void main() {
  group('StreakService', () {
    final now = DateTime(2026, 10, 20, 15);

    test('counts the streak up to today', () {
      final all = [
        tx(DateTime(2026, 10, 18, 9), 50),
        tx(DateTime(2026, 10, 19, 9), 50),
        tx(DateTime(2026, 10, 20, 9), 50),
      ];
      final s = StreakService.compute(all, now);
      expect(s.currentStreak, 3);
      expect(s.loggedToday, isTrue);
      expect(s.bestStreak, 3);
    });

    test('keeps the streak alive until today is over', () {
      final all = [
        tx(DateTime(2026, 10, 18), 50),
        tx(DateTime(2026, 10, 19), 50),
      ];
      final s = StreakService.compute(all, now);
      expect(s.currentStreak, 2);
      expect(s.loggedToday, isFalse);
    });

    test('a gap breaks the streak but best is remembered', () {
      final all = [
        for (var d = 1; d <= 5; d++) tx(DateTime(2026, 10, d), 10),
        tx(DateTime(2026, 10, 20), 10),
      ];
      final s = StreakService.compute(all, now);
      expect(s.currentStreak, 1);
      expect(s.bestStreak, 5);
    });

    test('no-spend days start from the first logged day', () {
      final all = [
        tx(DateTime(2026, 10, 15), 100),
        tx(DateTime(2026, 10, 17), 500, category: 'salary', income: true),
      ];
      // 15th spent; 16, 17, 18, 19 have no expense; today not counted.
      expect(StreakService.compute(all, now).noSpendDays, 4);
    });
  });

  group('InsightsService', () {
    final now = DateTime(2026, 10, 15);

    test('no expenses gives the empty insight', () {
      final r = InsightsService.compute(
        thisMonth: [],
        lastMonth: [],
        now: now,
      );
      expect(r.single.key, 'insight_no_data');
    });

    test('compares with the same days of last month', () {
      final r = InsightsService.compute(
        thisMonth: [tx(DateTime(2026, 10, 5), 1500)],
        lastMonth: [
          tx(DateTime(2026, 9, 5), 1000),
          tx(DateTime(2026, 9, 25), 9000), // after the 15th: ignored
        ],
        now: now,
      );
      final more = r.firstWhere((i) => i.key == 'insight_spent_more');
      expect(more.params['percent'], '50');
      expect(more.params['amount'], '500');
    });

    test('flags a category that grew and the projection over income', () {
      final r = InsightsService.compute(
        thisMonth: [
          tx(DateTime(2026, 10, 3), 2000, category: 'transportation'),
          tx(DateTime(2026, 10, 4), 3000, category: 'salary', income: true),
        ],
        lastMonth: [
          tx(DateTime(2026, 9, 3), 1000, category: 'transportation'),
        ],
        now: now,
      );
      final keys = r.map((i) => i.key).toList();
      expect(keys, contains('insight_category_up'));
      expect(keys, contains('insight_top_category'));
      // 2000 in 15 days -> 4133 projected, more than 3000 income
      final over = r.firstWhere((i) => i.key == 'insight_projection_over');
      expect(over.params['amount'], '4133');
      expect(keys, contains('insight_saved'));
    });
  });

  group('ZakatCalculator', () {
    test('not due below the silver nisab', () {
      final r = ZakatCalculator.calculate(
        const ZakatInput(cash: 50000, silverPricePerBhori: 2000),
      );
      expect(r.nisab, 105000);
      expect(r.isDue, isFalse);
      expect(r.zakat, 0);
    });

    test('2.5% of net wealth after debts', () {
      final r = ZakatCalculator.calculate(
        const ZakatInput(
          cash: 100000,
          bank: 100000,
          goldBhori: 2,
          goldPricePerBhori: 150000,
          silverPricePerBhori: 2000,
          debts: 100000,
        ),
      );
      expect(r.totalAssets, 500000);
      expect(r.netWealth, 400000);
      expect(r.isDue, isTrue);
      expect(r.zakat, 10000);
    });

    test('falls back to the gold nisab without a silver price', () {
      final r = ZakatCalculator.calculate(
        const ZakatInput(cash: 500000, goldPricePerBhori: 100000),
      );
      expect(r.nisab, 750000);
      expect(r.isDue, isFalse);
    });
  });
}
