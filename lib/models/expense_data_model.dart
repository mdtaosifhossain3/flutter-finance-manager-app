import 'package:flutter/material.dart';

class ExpenseData {
  final String category;
  final double amount;
  final int percentage;
  final bool isIncreasing;
  final IconData icon;
  final Color color;

  ExpenseData(
    this.category,
    this.amount,
    this.percentage,
    this.isIncreasing,
    this.icon,
    this.color,
  );
}
