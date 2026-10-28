import 'package:flutter/material.dart';

class CustomCategoryModel {
  final int? id; // auto-increment in SQLite
  final bool isExpense;
  final String name;
  final int iconCodePoint; // store icon as int
  final String iconFontFamily; // store font family
  final int colorValue; // store color as int
  final String? groupName;

  CustomCategoryModel({
    this.id,
    required this.isExpense,
    required this.name,
    required this.iconCodePoint,
    required this.iconFontFamily,
    required this.colorValue,
    this.groupName,
  });

  /// Convert IconData back from stored fields
  IconData get iconData => IconData(
    iconCodePoint,
    fontFamily: iconFontFamily,
  );

  /// Convert color back from int
  Color get color => Color(colorValue);

  /// Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isExpense': isExpense ? 1 : 0,
      'name': name,
      'iconCodePoint': iconCodePoint,
      'iconFontFamily': iconFontFamily,
      'colorValue': colorValue,
      'groupName': groupName,
    };
  }

  /// From Map (SQLite → Dart)
  factory CustomCategoryModel.fromMap(Map<String, dynamic> map) {
    return CustomCategoryModel(
      id: map['id'],
      isExpense: map['isExpense'] == 1,
      name: map['name'],
      iconCodePoint: map['iconCodePoint'],
      iconFontFamily: map['iconFontFamily'],
      colorValue: map['colorValue'],
      groupName: map['groupName'],
    );
  }
}
