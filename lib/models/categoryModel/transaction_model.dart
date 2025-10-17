import 'package:flutter/material.dart';

import '../../../config/enums/enums.dart';

class TransactionModel {
  final int? id;
  final TransactionType type;
  final DateTime date;
  final String title;
  final String categoryName;
  final int amount;
  final String? notes;
  final String paymentMethod;
  final IconData icon;
  final int iconBgColor;
  final String categoryKey;

  TransactionModel({
    this.id,
    required this.type,
    required this.date,
    required this.title,
    required this.categoryName,
    required this.amount,
    this.notes,
    required this.paymentMethod,
    required this.icon,
    required this.iconBgColor,
    required this.categoryKey,

  });

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type == TransactionType.expense ? 1 : 0,
      'date': date.toIso8601String(),
      'title': title,
      'categoryName': categoryName,
      'amount': amount,
      'notes': notes,
      'paymentMethod': paymentMethod,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'iconBgColor': iconBgColor,
      'categoryKey': categoryKey,

    };
  }
  Map<String, dynamic> toMapForUpdate() => {
    'type': type == TransactionType.expense ? 1 : 0,
    'date': date.toIso8601String(),
    'title': title,
    'categoryName': categoryName,
    'amount': amount,
    'notes': notes,
    'paymentMethod': paymentMethod,
    'iconCodePoint': icon.codePoint,
    'iconFontFamily': icon.fontFamily,
    'iconBgColor': iconBgColor,
    'categoryKey': categoryKey,

  };

  // Create from Map (SQLite row)
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      type: map['type'] == 1 ? TransactionType.expense : TransactionType.income,
      date: DateTime.parse(map['date']),
      title: map['title'],
      categoryName: map['categoryName'],
      amount: map['amount'] ,
      notes: map['notes'],
      paymentMethod: map['paymentMethod'],
      iconBgColor: map['iconBgColor'],
      categoryKey: map['categoryKey'],
      icon: IconData(
        map['iconCodePoint'],
        fontFamily: map['iconFontFamily'],
      ),

    );
  }
}
