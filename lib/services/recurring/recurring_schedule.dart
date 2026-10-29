enum RecurringFrequency { monthly, weekly }

/// Date arithmetic for recurring bills. [day] is the day of the month
/// (1–31; short months use their last day) or, for weekly, the weekday
/// (1 = Monday … 7 = Sunday).
class RecurringSchedule {
  /// How many missed occurrences are added at once after a long break.
  static const maxCatchUp = 12;

  static DateTime firstDate(
    RecurringFrequency frequency,
    int day,
    DateTime today,
  ) {
    final t = DateTime(today.year, today.month, today.day);
    if (frequency == RecurringFrequency.weekly) {
      final diff = (day - t.weekday + 7) % 7;
      return DateTime(t.year, t.month, t.day + diff);
    }
    final thisMonth = _monthDay(t.year, t.month, day);
    return thisMonth.isBefore(t) ? _monthDay(t.year, t.month + 1, day) : thisMonth;
  }

  static DateTime next(DateTime from, RecurringFrequency frequency, int day) {
    if (frequency == RecurringFrequency.weekly) {
      return DateTime(from.year, from.month, from.day + 7);
    }
    return _monthDay(from.year, from.month + 1, day);
  }

  /// Occurrences from [nextDate] up to and including [today].
  static List<DateTime> dueDates({
    required DateTime nextDate,
    required RecurringFrequency frequency,
    required int day,
    required DateTime today,
  }) {
    final end = DateTime(today.year, today.month, today.day);
    final dates = <DateTime>[];
    var d = nextDate;
    while (!d.isAfter(end) && dates.length < maxCatchUp) {
      dates.add(d);
      d = next(d, frequency, day);
    }
    return dates;
  }

  static DateTime _monthDay(int year, int month, int day) {
    final lastDay = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, day > lastDay ? lastDay : day);
  }
}
