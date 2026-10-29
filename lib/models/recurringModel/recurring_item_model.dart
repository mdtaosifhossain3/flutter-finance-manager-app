import 'package:finance_manager_app/services/recurring/recurring_schedule.dart';

/// A bill or income that repeats: rent, electricity, salary, DPS…
class RecurringItem {
  final int? id;
  final String title;
  final int amount;
  final bool isIncome;
  final String categoryKey;
  final String paymentMethod;
  final RecurringFrequency frequency;

  /// Day of month (1–31) or weekday (1 = Monday … 7 = Sunday).
  final int day;
  final DateTime nextDate;

  /// Add the transaction by itself on the due day, or ask first.
  final bool autoAdd;

  const RecurringItem({
    this.id,
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.categoryKey,
    required this.paymentMethod,
    required this.frequency,
    required this.day,
    required this.nextDate,
    this.autoAdd = false,
  });

  RecurringItem copyWith({int? id, DateTime? nextDate}) => RecurringItem(
    id: id ?? this.id,
    title: title,
    amount: amount,
    isIncome: isIncome,
    categoryKey: categoryKey,
    paymentMethod: paymentMethod,
    frequency: frequency,
    day: day,
    nextDate: nextDate ?? this.nextDate,
    autoAdd: autoAdd,
  );

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'title': title,
    'amount': amount,
    'is_income': isIncome ? 1 : 0,
    'category_key': categoryKey,
    'payment_method': paymentMethod,
    'frequency': frequency.name,
    'day': day,
    'next_date': nextDate.toIso8601String(),
    'auto_add': autoAdd ? 1 : 0,
  };

  factory RecurringItem.fromMap(Map<String, dynamic> m) => RecurringItem(
    id: m['id'] as int?,
    title: m['title'] as String,
    amount: m['amount'] as int,
    isIncome: m['is_income'] == 1,
    categoryKey: m['category_key'] as String,
    paymentMethod: m['payment_method'] as String,
    frequency: RecurringFrequency.values.byName(m['frequency'] as String),
    day: m['day'] as int,
    nextDate: DateTime.parse(m['next_date'] as String),
    autoAdd: m['auto_add'] == 1,
  );
}
