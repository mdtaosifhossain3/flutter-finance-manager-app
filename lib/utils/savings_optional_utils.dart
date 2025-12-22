import 'package:finance_manager_app/models/savings_goal_model.dart';
import 'package:finance_manager_app/models/savings_transaction_model.dart';

/// Utility class for optional Savings feature enhancements
class SavingsOptionalUtils {
  /// Calculate daily saving needed based on days remaining
  /// Returns null if goal is already completed or date is invalid
  static double? calculateDailySavingNeeded(SavingsGoal goal) {
    if (goal.isCompleted) return null;

    try {
      final startDate = DateTime.parse(goal.startDate);
      final today = DateTime.now();

      // If start date is in future, return null
      if (startDate.isAfter(today)) return null;

      // Calculate days elapsed since start
      final daysElapsed = today.difference(startDate).inDays + 1;
      if (daysElapsed <= 0) return null;

      // Calculate remaining amount
      final remaining = goal.remainingAmount;
      if (remaining <= 0) return null;

      // Daily saving needed = remaining / days elapsed (to maintain pace)
      return remaining / daysElapsed;
    } catch (e) {
      return null;
    }
  }

  /// Get milestone percentage (25, 50, 75, 100)
  static int? getMilestonePercentage(double progress) {
    final percentage = progress.toInt();

    if (percentage >= 100) return 100;
    if (percentage >= 75) return 75;
    if (percentage >= 50) return 50;
    if (percentage >= 25) return 25;

    return null;
  }

  /// Check if milestone was just reached
  static bool isMilestoneReached(double oldProgress, double newProgress) {
    final oldMilestone = getMilestonePercentage(oldProgress);
    final newMilestone = getMilestonePercentage(newProgress);

    return oldMilestone != newMilestone && newMilestone != null;
  }

  /// Get most common notes from transactions
  static Map<String, int> getNotesAnalytics(
    List<SavingsTransaction> transactions,
  ) {
    final notesMap = <String, int>{};

    for (final txn in transactions) {
      if (txn.note != null && txn.note!.isNotEmpty) {
        final note = txn.note!.toLowerCase().trim();
        notesMap[note] = (notesMap[note] ?? 0) + 1;
      }
    }

    // Sort by frequency (descending)
    final sortedNotes = notesMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sortedNotes.take(5)); // Top 5 notes
  }

  /// Get milestone message
  static String getMilestoneMessage(int percentage) {
    switch (percentage) {
      case 25:
        return '🎉 You\'ve reached 25%! Keep going!';
      case 50:
        return '🔥 Halfway there! You\'re doing great!';
      case 75:
        return '💪 75% complete! Almost at the finish line!';
      case 100:
        return '🏆 Goal completed! Congratulations! 🎊';
      default:
        return '';
    }
  }

  /// Get milestone message with translation keys
  static String getMilestoneMessageKey(int percentage) {
    switch (percentage) {
      case 25:
        return 'milestone25';
      case 50:
        return 'milestone50';
      case 75:
        return 'milestone75';
      case 100:
        return 'milestoneComplete';
      default:
        return '';
    }
  }

  /// Calculate goal completion date based on daily rate
  static DateTime? calculateCompletionDate(SavingsGoal goal) {
    if (goal.isCompleted) return DateTime.now();

    final dailySaving = calculateDailySavingNeeded(goal);
    if (dailySaving == null || dailySaving <= 0) return null;

    try {
      final remaining = goal.remainingAmount;
      final daysNeeded = (remaining / dailySaving).ceil();
      return DateTime.now().add(Duration(days: daysNeeded));
    } catch (e) {
      return null;
    }
  }

  /// Check if transaction would trigger milestone
  static bool wouldTriggerMilestone(
    SavingsGoal goal,
    double transactionAmount,
    bool isAdd,
  ) {
    final newAmount = isAdd
        ? goal.currentAmount + transactionAmount
        : goal.currentAmount - transactionAmount;

    final oldProgress = goal.progressPercentage;
    final newProgress = (newAmount / goal.targetAmount) * 100;

    return isMilestoneReached(oldProgress, newProgress);
  }
}
