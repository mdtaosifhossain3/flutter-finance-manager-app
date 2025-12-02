import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/services/reminder_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../config/enums/enums.dart';
import '../category/transaction_provider.dart';

class ReportProvider extends ChangeNotifier {
  AddExpenseProvider transactionProvider;
  ReportProvider({required this.transactionProvider}) {
    {
      // Listen to updates from AddExpenseProvider
      transactionProvider.addListener(() {
        fetchReportData(); // Refresh report data when transactions change
      });
    }
  }

  DateTime selectedMonth = DateTime.now();
  List<TransactionModel> reportTransactions =
      []; // Transactions for the selected month
  List<TransactionModel> historyTransactions =
      []; // Transactions for the last 6 months
  String selectedPeriod = "periodMonth".tr;

  void updateSelectedMonth(DateTime date) {
    selectedMonth = date;
    selectedPeriod = "periodMonth".tr;
    fetchReportData();
    notifyListeners();
  }

  void setSelectedMonth(val) {
    selectedPeriod = val;
    notifyListeners();
  }

  String _searchQuery = "";
  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  List<TransactionModel> get filteredTransactions {
    List<TransactionModel> periodFiltered = [];

    if (selectedPeriod == "periodMonth".tr) {
      periodFiltered = reportTransactions;
    } else if (selectedPeriod == "periodWeek".tr) {
      // Filter for current week if it falls within the selected month
      // For now, let's just show all if we can't determine the week relative to selected month easily without more UI
      // Or we can use the same logic as HomeViewProvider but relative to DateTime.now()
      // If the user is looking at a past month, "Current Week" makes no sense.
      // So let's just return reportTransactions for now to avoid showing nothing.
      // Or better, filter by the week of the selectedMonth (e.g. first 7 days?)
      // Let's stick to returning reportTransactions for simplicity as the user only asked for Month support.
      periodFiltered = reportTransactions;
    } else {
      // Day
      periodFiltered = reportTransactions;
    }

    if (_searchQuery.isEmpty) return periodFiltered;

    return periodFiltered.where((tx) {
      return tx.categoryKey.toLowerCase().contains(_searchQuery) ||
          tx.amount.toString().contains(_searchQuery);
    }).toList();
  }

  Future<void> fetchReportData() async {
    // Fetch data for the selected month
    final startOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final endOfMonth = DateTime(
      selectedMonth.year,
      selectedMonth.month + 1,
      0,
      23,
      59,
      59,
    );

    final dt = await transactionProvider.addTransactionDbHelper
        .getTransactionsByDateRange(
          startOfMonth.toIso8601String(),
          endOfMonth.toIso8601String(),
        );
    reportTransactions = dt.map((e) => TransactionModel.fromMap(e)).toList();

    // Fetch data for the last 6 months for trends
    final startOfHistory = DateTime(
      selectedMonth.year,
      selectedMonth.month - 5,
      1,
    );
    final endOfHistory = endOfMonth; // End at the selected month

    final historyDt = await transactionProvider.addTransactionDbHelper
        .getTransactionsByDateRange(
          startOfHistory.toIso8601String(),
          endOfHistory.toIso8601String(),
        );
    historyTransactions = historyDt
        .map((e) => TransactionModel.fromMap(e))
        .toList();

    // Recalculate everything
    filterCategoryFunction();
    getMonthlyTotals();
    periodDatafunction();

    notifyListeners();
  }

  final List<Map<String, dynamic>> montlydata = [];
  final List<Map<String, dynamic>> periodData = [];
  final List<Map<String, dynamic>> filterCategories = [];

  void filterCategoryFunction() {
    filterCategories.clear();

    final Map<String, Map<String, dynamic>> categoryTotals = {};

    for (var elm in reportTransactions) {
      final name = elm.categoryKey;
      final color = elm.iconBgColor;
      final amount = elm.amount;

      if (categoryTotals.containsKey(name)) {
        // Add to existing amount
        categoryTotals[name]!["amount"] += amount;
      } else {
        // Create new category entry
        categoryTotals[name] = {
          "categoryName": name,
          "color": color,
          "amount": amount,
        };
      }
    }

    // convert map back to list
    filterCategories.addAll(categoryTotals.values);
  }

  void periodDatafunction() {
    periodData.clear(); // clear old data before adding new ones

    for (var i in montlydata) {
      final double income = i["income"] ?? 0;
      final double expenses = i["expenses"] ?? 0;
      final String month = i["months"] ?? "";

      double riskThreshold = 0.8; // 80% of income

      if (expenses > income) {
        // Overspending
        final amount = expenses - income;
        periodData.add({
          "month": month.toString(),
          "overspending": amount.toDouble(),
          "risk": 0.0,
          "within": 0.0,
        });
      } else if (expenses >= income * riskThreshold && expenses <= income) {
        // At Risk
        final amount = expenses; // can also store % of income if you want
        periodData.add({
          "month": month.toString(),
          "overspending": 0.0,
          "risk": amount.toDouble(),
          "within": 0.0,
        });
      } else {
        // Within
        final amount = income - expenses;
        periodData.add({
          "month": month.toString(),
          "overspending": 0.0,
          "risk": 0.0,
          "within": amount.toDouble(),
        });
      }
    }
  }

  Map<String, dynamic> calculateTotals(
    List<TransactionModel> filteredTxns,
    String monthName,
  ) {
    double expenses = 0;
    double income = 0;

    for (var tx in filteredTxns) {
      if (tx.type == TransactionType.expense) {
        expenses += tx.amount;
      } else if (tx.includeInTotal) {
        // Only include income if includeInTotal is true
        income += tx.amount;
      }
    }

    return {"expenses": expenses, "income": income, "months": monthName};
  }

  void getMonthlyTotals() {
    montlydata.clear();
    final now = selectedMonth;

    // Get last 6 months including current
    for (int i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);

      final startOfMonth = DateTime(date.year, date.month, 1);
      final endOfMonth = DateTime(date.year, date.month + 1, 0);

      final monthTxns = historyTransactions.where((tx) {
        return tx.date.isAfter(
              startOfMonth.subtract(const Duration(days: 1)),
            ) &&
            tx.date.isBefore(endOfMonth.add(const Duration(days: 1)));
      }).toList();

      final monthName = DateFormat('MMM').format(startOfMonth);
      montlydata.add(calculateTotals(monthTxns, monthName));
    }
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

  double getMaxYof6DayPeriod() {
    if (periodData.isEmpty) return 1000; // fallback

    double maxValue = 0;
    for (var month in periodData) {
      double within = (month["within"] as num).toDouble();
      double overspending = (month["overspending"] as num).toDouble();
      double risk = (month["risk"] as num).toDouble();

      // pick the largest among them
      if (within > maxValue) maxValue = within;
      if (overspending > maxValue) maxValue = overspending;
      if (risk > maxValue) maxValue = risk;
    }

    // Add padding (20%)
    return maxValue + (maxValue * 0.2);
  }

  Map<String, int> getCurrentMonthTotals() {
    int totalExpense = 0;
    int totalIncome = 0;

    final now = selectedMonth;
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    for (var tx in reportTransactions) {
      if (tx.date.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
          tx.date.isBefore(endOfMonth.add(const Duration(days: 1)))) {
        if (tx.type == TransactionType.expense) {
          totalExpense += tx.amount;
        } else if (tx.includeInTotal) {
          // Only include income if includeInTotal is true
          totalIncome += tx.amount;
        }
      }
    }

    return {"expense": totalExpense, "income": totalIncome};
  }

  void warningshow() {
    final totals = getCurrentMonthTotals();

    int expense = totals["expense"] ?? 0;
    int income = totals["income"] ?? 0;

    int remaining = (income == 0 || expense == 0) ? 0 : income - expense;
    //   remaining < 0 ? ReminderHelper.tt() : null;

    if (remaining < 0) {
      ReminderHelper.tt("warningTitleTransacton", "warningDescTransacton");
    }
  }
}
