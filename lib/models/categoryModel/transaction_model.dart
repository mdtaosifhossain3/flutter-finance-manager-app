import '../../../config/enums/enums.dart';

class TransactionModel {
  final int? id;
  final TransactionType type;
  final DateTime date;
  final String title;
  final int amount;
  final String? notes;
  final String paymentMethod;
  final String icon;
  final int iconBgColor;
  final String categoryKey;
  final bool
  includeInTotal; // Whether to include this income in total calculations

  TransactionModel({
    this.id,
    required this.type,
    required this.date,
    required this.title,
    required this.amount,
    this.notes,
    required this.paymentMethod,
    required this.icon,
    required this.iconBgColor,
    required this.categoryKey,
    this.includeInTotal = true, // Default to true (include in total)
  });

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'type': type == TransactionType.expense ? 1 : 0,
      'date': date.toIso8601String(),
      'title': title,
      'amount': amount,
      'notes': notes,
      'paymentMethod': paymentMethod,
      'icon': icon,
      'iconBgColor': iconBgColor,
      'categoryKey': categoryKey,
      'includeInTotal': includeInTotal ? 1 : 0,
    };
    return map;
  }

  Map<String, dynamic> toMapForUpdate() => {
    'type': type == TransactionType.expense ? 1 : 0,
    'date': date.toIso8601String(),
    'title': title,
    'amount': amount,
    'notes': notes,
    'paymentMethod': paymentMethod,
    'icon': icon,
    'iconBgColor': iconBgColor,
    'categoryKey': categoryKey,
    'includeInTotal': includeInTotal ? 1 : 0,
  };

  // Create from Map (SQLite row)
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    // Handle null or missing includeInTotal field (default to true for backward compatibility)
    final includeInTotalValue = map['includeInTotal'];
    final includeInTotal = includeInTotalValue == null
        ? true
        : includeInTotalValue == 1;
    return TransactionModel(
      id: map['id'],
      type: map['type'] == 1 ? TransactionType.expense : TransactionType.income,
      date: DateTime.parse(map['date']),
      title: map['title'],
      amount: map['amount'],
      notes: map['notes'],
      paymentMethod: map['paymentMethod'],
      iconBgColor: map['iconBgColor'],
      categoryKey: map['categoryKey'],
      icon: map['icon'],
      includeInTotal: includeInTotal,
    );
  }
}
