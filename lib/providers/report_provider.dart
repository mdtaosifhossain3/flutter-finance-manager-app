import 'package:finance_manager_app/models/budget_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../config/enums/enums.dart';
import '../models/tempm/categoryModel/transaction_model.dart';
import 'category/expense_provider.dart';

class ReportProvider extends ChangeNotifier {
  final AddExpenseProvider transactionProvider;
  ReportProvider({required this.transactionProvider});

  final List<Map<String,dynamic>> montlydata= [];
  final List<Map<String,dynamic>> periodData= [];

  void periodDatafunction() {
    periodData.clear(); // clear old data before adding new ones

    for (var i in montlydata) {
      final int income = i["income"] ?? 0;
      final int expenses = i["expenses"] ?? 0;
      final String month = i["months"] ?? "";

      double riskThreshold = 0.8; // 80% of income

      if (expenses > income) {
        // Overspending
        final amount = expenses - income;
        periodData.add({
          "month": month,
          "overspending": amount,
          "risk": 0,
          "within": 0,
        });
      } else if (expenses >= income * riskThreshold && expenses <= income) {
        // At Risk
        final amount = expenses; // can also store % of income if you want
        periodData.add({
          "month": month,
          "overspending": 0,
          "risk": amount,
          "within": 0,
        });
      } else {
        // Within
        final amount = income - expenses;
        periodData.add({
          "month": month,
          "overspending": 0,
          "risk": 0,
          "within": amount,
        });
      }
    }

  }

  Map<String, dynamic> calculateTotals(List<TransactionModel> filteredTxns, String monthName) {
    double expenses = 0;
    double income = 0;

    for (var tx in filteredTxns) {
      if (tx.type == TransactionType.expense) {
        expenses += tx.amount;
      } else {
        income += tx.amount;
      }
    }

    return {
      "expenses": expenses,
      "income": income,
      "months": monthName,
    };
  }
  void getMonthlyTotals() {
    montlydata.clear(); // reset old values
    final now = DateTime.now();

    for (int month = 1; month <= 12; month++) {
      final startOfMonth = DateTime(now.year, month, 1);
      final endOfMonth = DateTime(now.year, month + 1, 0);

      final monthTxns = transactionProvider.expenseList.where((tx) {
        return tx.date.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
            tx.date.isBefore(endOfMonth.add(const Duration(days: 1)));
      }).toList();

      final monthName = DateFormat('MMM').format(startOfMonth);
      montlydata.add(calculateTotals(monthTxns, monthName));
    }

    notifyListeners();
  }
  double getMaxY() {
    if (montlydata.isEmpty) return 1000; // fallback

    double maxValue = 0;
    for (var month in montlydata) {
      double income = month["income"] ?? 0;
      double expense = month["expenses"] ?? 0;

      if (income > maxValue) maxValue = income;
      if (expense > maxValue) maxValue = expense;
    }

    // Add some padding (20%)
    return maxValue + (maxValue * 0.2);
  }

}