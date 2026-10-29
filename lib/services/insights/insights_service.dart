import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';

/// One plain-language insight. [key] is a translation key and [params] fill
/// its @placeholders (numbers as plain digits, `category` as a category key,
/// `day` as a weekday key).
class Insight {
  final String key;
  final Map<String, String> params;
  final InsightTone tone;

  const Insight(this.key, this.params, this.tone);
}

enum InsightTone { good, warning, neutral }

/// Builds the monthly insights shown on the Insights screen. Everything is
/// computed offline from the user's own transactions.
class InsightsService {
  /// [thisMonth] and [lastMonth] are the transactions of the current and the
  /// previous calendar month; [now] is a day inside the current month.
  static List<Insight> compute({
    required List<TransactionModel> thisMonth,
    required List<TransactionModel> lastMonth,
    required DateTime now,
  }) {
    final insights = <Insight>[];
    final day = now.day;
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    final expenses = thisMonth
        .where((t) => t.type == TransactionType.expense)
        .toList();
    // Compare against the same days of last month, so the 10th isn't
    // measured against a full month.
    final lastExpenses = lastMonth
        .where((t) => t.type == TransactionType.expense && t.date.day <= day)
        .toList();

    final spent = _sum(expenses);
    final lastSpent = _sum(lastExpenses);
    final income = _sum(
      thisMonth.where(
        (t) => t.type == TransactionType.income && t.includeInTotal,
      ),
    );

    if (spent == 0) {
      return const [Insight('insight_no_data', {}, InsightTone.neutral)];
    }

    // 1. Spending vs last month
    if (lastSpent > 0) {
      final change = ((spent - lastSpent) / lastSpent * 100).round();
      if (change >= 5) {
        insights.add(
          Insight('insight_spent_more', {
            'percent': '$change',
            'amount': '${spent - lastSpent}',
          }, InsightTone.warning),
        );
      } else if (change <= -5) {
        insights.add(
          Insight('insight_spent_less', {
            'percent': '${-change}',
            'amount': '${lastSpent - spent}',
          }, InsightTone.good),
        );
      }
    }

    // 2. Top category
    final byCategory = _byCategory(expenses);
    final top = byCategory.entries.reduce((a, b) => a.value >= b.value ? a : b);
    insights.add(
      Insight('insight_top_category', {
        'category': top.key,
        'amount': '${top.value}',
        'percent': '${(top.value / spent * 100).round()}',
      }, InsightTone.neutral),
    );

    // 3. Category that grew the most vs last month
    final lastByCategory = _byCategory(lastExpenses);
    MapEntry<String, int>? biggestRise;
    var biggestRisePercent = 0;
    for (final entry in byCategory.entries) {
      final before = lastByCategory[entry.key] ?? 0;
      if (before <= 0 || entry.value - before < 300) continue;
      final percent = ((entry.value - before) / before * 100).round();
      if (percent >= 20 && percent > biggestRisePercent) {
        biggestRise = entry;
        biggestRisePercent = percent;
      }
    }
    if (biggestRise != null) {
      insights.add(
        Insight('insight_category_up', {
          'category': biggestRise.key,
          'percent': '$biggestRisePercent',
        }, InsightTone.warning),
      );
    }

    // 4. Most expensive weekday (needs at least two weeks of data)
    if (day >= 14) {
      final byWeekday = <int, int>{};
      for (final t in expenses) {
        byWeekday[t.date.weekday] = (byWeekday[t.date.weekday] ?? 0) + t.amount;
      }
      final topDay = byWeekday.entries.reduce(
        (a, b) => a.value >= b.value ? a : b,
      );
      insights.add(
        Insight('insight_busiest_day', {
          'day': 'weekday_${topDay.key}',
        }, InsightTone.neutral),
      );
    }

    // 5. Month-end projection
    if (day < daysInMonth) {
      final projected = (spent / day * daysInMonth).round();
      if (income > 0 && projected > income) {
        insights.add(
          Insight('insight_projection_over', {
            'amount': '$projected',
            'over': '${projected - income}',
          }, InsightTone.warning),
        );
      } else {
        insights.add(
          Insight('insight_projection', {
            'amount': '$projected',
          }, InsightTone.neutral),
        );
      }
    }

    // 6. Savings this month
    if (income > 0) {
      final saved = income - spent;
      if (saved > 0) {
        insights.add(
          Insight('insight_saved', {
            'amount': '$saved',
            'percent': '${(saved / income * 100).round()}',
          }, InsightTone.good),
        );
      } else if (saved < 0) {
        insights.add(
          Insight('insight_overspent', {
            'amount': '${-saved}',
          }, InsightTone.warning),
        );
      }
    }

    return insights;
  }

  static int _sum(Iterable<TransactionModel> txs) =>
      txs.fold(0, (sum, t) => sum + t.amount);

  static Map<String, int> _byCategory(List<TransactionModel> txs) {
    final map = <String, int>{};
    for (final t in txs) {
      map[t.categoryKey] = (map[t.categoryKey] ?? 0) + t.amount;
    }
    return map;
  }
}
