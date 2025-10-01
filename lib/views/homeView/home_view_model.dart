import 'package:finance_manager_app/models/tempm/categoryModel/transaction_model.dart';
import 'package:flutter/material.dart';

class HomeViewModel{
 static String selectedPeriod = 'M';
 static late AnimationController progressController;
 static late Animation<double> progressAnimation;

 static String formatCurrency(double amount) {
    if (amount >= 1000) {
      return amount
          .toStringAsFixed(0)
          .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
      );
    }
    return amount.toStringAsFixed(2);
  }
}
class PeriodData {
  final double expenses;
  final double budget;
  final String title;
  final List<TransactionModel> transactions;

  PeriodData({
    required this.expenses,
    required this.budget,
    required this.title,
    required this.transactions,
  });
}

