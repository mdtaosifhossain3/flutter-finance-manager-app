import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';

class StreakStats {
  /// Consecutive days with at least one entry, ending today (or yesterday,
  /// so the streak isn't shown as broken before the user logs today).
  final int currentStreak;
  final int bestStreak;
  final bool loggedToday;

  /// Finished days this month (since the user started logging) with no
  /// expense.
  final int noSpendDays;
  final int totalEntries;

  const StreakStats({
    required this.currentStreak,
    required this.bestStreak,
    required this.loggedToday,
    required this.noSpendDays,
    required this.totalEntries,
  });
}

class AchievementBadge {
  final String key;
  final String emoji;
  final bool unlocked;

  const AchievementBadge(this.key, this.emoji, this.unlocked);
}

class StreakService {
  static StreakStats compute(List<TransactionModel> all, DateTime now) {
    final today = _day(now);
    final loggedDays = {for (final t in all) _day(t.date)};

    final loggedToday = loggedDays.contains(today);
    var cursor = loggedToday ? today : today.subtract(const Duration(days: 1));
    var current = 0;
    while (loggedDays.contains(cursor)) {
      current++;
      cursor = _previousDay(cursor);
    }

    final sorted = loggedDays.toList()..sort();
    var best = 0;
    var run = 0;
    DateTime? previous;
    for (final d in sorted) {
      run = (previous != null && _previousDay(d) == previous) ? run + 1 : 1;
      if (run > best) best = run;
      previous = d;
    }

    var noSpend = 0;
    if (sorted.isNotEmpty) {
      final monthStart = DateTime(now.year, now.month, 1);
      final from = sorted.first.isAfter(monthStart) ? sorted.first : monthStart;
      final spendDays = {
        for (final t in all)
          if (t.type == TransactionType.expense) _day(t.date),
      };
      for (var d = from; d.isBefore(today); d = _nextDay(d)) {
        if (!spendDays.contains(d)) noSpend++;
      }
    }

    return StreakStats(
      currentStreak: current,
      bestStreak: best,
      loggedToday: loggedToday,
      noSpendDays: noSpend,
      totalEntries: all.length,
    );
  }

  /// [spentLessThanLastMonth] is decided by the caller from the insights data.
  static List<AchievementBadge> badges(
    StreakStats stats, {
    required bool spentLessThanLastMonth,
  }) {
    return [
      AchievementBadge('badge_streak_3', '🔥', stats.bestStreak >= 3),
      AchievementBadge('badge_streak_7', '⭐', stats.bestStreak >= 7),
      AchievementBadge('badge_streak_30', '🏆', stats.bestStreak >= 30),
      AchievementBadge('badge_no_spend_5', '🧘', stats.noSpendDays >= 5),
      AchievementBadge('badge_saver', '💰', spentLessThanLastMonth),
      AchievementBadge('badge_entries_100', '📒', stats.totalEntries >= 100),
    ];
  }

  // Calendar arithmetic via DateTime(y, m, d ± 1) so DST never shifts days.
  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);
  static DateTime _previousDay(DateTime d) =>
      DateTime(d.year, d.month, d.day - 1);
  static DateTime _nextDay(DateTime d) => DateTime(d.year, d.month, d.day + 1);
}
