import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:flutter/material.dart';

class CategorySummary {
  final String categoryName;
  final int count;
  final int total;
  final IconData icon;
  final int iconBgColor;
  final TransactionType type;

  CategorySummary({
    required this.categoryName,
    required this.count,
    required this.total,
    required this.icon,
    required this.iconBgColor,
    required this.type,
  });
}
