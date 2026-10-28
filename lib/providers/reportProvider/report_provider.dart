import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/services/reminder_helper.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/enums/enums.dart';
import '../category/transaction_provider.dart';

class ReportProvider extends ChangeNotifier {
  AddExpenseProvider transactionProvider;
  ReportProvider({required this.transactionProvider}) {
    // Refresh report data when transactions change
    transactionProvider.addListener(fetchReportData);
  }

  @override
  void dispose() {
    transactionProvider.removeListener(fetchReportData);
    super.dispose();
  }

  // Period keys; translate only when displaying so a language change
  // doesn't break the comparison
  static const String periodDay = 'periodDay';
  static const String periodWeek = 'periodWeek';
  static const String periodMonth = 'periodMonth';

  DateTime selectedMonth = DateTime.now();
  List<TransactionModel> reportTransactions =
      []; // Transactions for the selected month
  List<TransactionModel> historyTransactions =
      []; // Transactions for the last 6 months
  String selectedPeriod = periodMonth;

  // Bumped on every fetch so a slow, older fetch can't overwrite newer data
  int _fetchGeneration = 0;

  void updateSelectedMonth(DateTime date) {
    selectedMonth = date;
    selectedPeriod = periodMonth;
    fetchReportData();
    notifyListeners();
  }

  void setSelectedMonth(String period) {
    selectedPeriod = period;
    notifyListeners();
  }

  String _searchQuery = "";
  void setSearchQuery(String query) {
    _searchQuery = query.trim().toLowerCase();
    notifyListeners();
  }

  /// Start of the last [days] days of the selected month. For the current
  /// month that ends today; for a past month it ends on its last day.
  DateTime _periodStart(int days) {
    final now = DateTime.now();
    final isCurrentMonth =
        selectedMonth.year == now.year && selectedMonth.month == now.month;
    final anchor = isCurrentMonth
        ? DateTime(now.year, now.month, now.day)
        : DateTime(selectedMonth.year, selectedMonth.month + 1, 0);
    return DateTime(anchor.year, anchor.month, anchor.day - (days - 1));
  }

  /// Transactions for the selected period (day / week / month).
  List<TransactionModel> get periodTransactions {
    switch (selectedPeriod) {
      case periodDay:
        final start = _periodStart(1);
        return reportTransactions
            .where((tx) => !tx.date.isBefore(start))
            .toList();
      case periodWeek:
        final start = _periodStart(7);
        return reportTransactions
            .where((tx) => !tx.date.isBefore(start))
            .toList();
      default:
        return reportTransactions;
    }
  }

  List<TransactionModel> get filteredTransactions {
    final periodFiltered = periodTransactions;
    if (_searchQuery.isEmpty) return periodFiltered;

    return periodFiltered.where((tx) {
      return tx.categoryKey.toLowerCase().contains(_searchQuery) ||
          tx.categoryKey.tr.toLowerCase().contains(_searchQuery) ||
          tx.title.toLowerCase().contains(_searchQuery) ||
          tx.amount.toString().contains(_searchQuery) ||
          HelperFunctions.convertToBanglaDigits(
            tx.amount.toString(),
          ).contains(_searchQuery);
    }).toList();
  }

  /// Expense totals per category for the selected period.
  List<Map<String, dynamic>> get periodCategories =>
      _categoryTotals(periodTransactions);

  Future<void> fetchReportData() async {
    final generation = ++_fetchGeneration;

    // Fetch data for the selected month
    final startOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final endOfMonth = _endOfMonth(selectedMonth);

    final dt = await transactionProvider.addTransactionDbHelper
        .getTransactionsByDateRange(
          startOfMonth.toIso8601String(),
          endOfMonth.toIso8601String(),
        );

    // Fetch data for the last 6 months for trends
    final startOfHistory = DateTime(
      selectedMonth.year,
      selectedMonth.month - 5,
      1,
    );

    final historyDt = await transactionProvider.addTransactionDbHelper
        .getTransactionsByDateRange(
          startOfHistory.toIso8601String(),
          endOfMonth.toIso8601String(),
        );

    if (generation != _fetchGeneration) return; // a newer fetch started

    reportTransactions = dt.map((e) => TransactionModel.fromMap(e)).toList();
    historyTransactions = historyDt
        .map((e) => TransactionModel.fromMap(e))
        .toList();

    // Recalculate everything
    filterCategoryFunction();
    getMonthlyTotals();
    periodDatafunction();

    notifyListeners();
  }

  /// Last microsecond of [date]'s month. Dates are stored as ISO strings
  /// with microseconds, so 23:59:59 alone would miss the final second.
  static DateTime _endOfMonth(DateTime date) =>
      DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999, 999);

  final List<Map<String, dynamic>> montlydata = [];
  final List<Map<String, dynamic>> periodData = [];
  final List<Map<String, dynamic>> filterCategories = [];

  /// Groups expenses (not income) by category.
  List<Map<String, dynamic>> _categoryTotals(List<TransactionModel> txns) {
    final Map<String, Map<String, dynamic>> categoryTotals = {};

    for (var elm in txns) {
      if (elm.type != TransactionType.expense) continue;
      final name = elm.categoryKey;

      if (categoryTotals.containsKey(name)) {
        categoryTotals[name]!["amount"] += elm.amount;
      } else {
        categoryTotals[name] = {
          "categoryName": name,
          "color": elm.iconBgColor,
          "amount": elm.amount,
        };
      }
    }

    // Biggest category first
    return categoryTotals.values.toList()
      ..sort((a, b) => (b["amount"] as int).compareTo(a["amount"] as int));
  }

  void filterCategoryFunction() {
    filterCategories
      ..clear()
      ..addAll(_categoryTotals(reportTransactions));
  }

  void periodDatafunction() {
    periodData.clear(); // clear old data before adding new ones

    for (var i in montlydata) {
      final double income = i["income"] ?? 0;
      final double expenses = i["expenses"] ?? 0;
      final String month = i["months"] ?? "";

      double riskThreshold = 0.8; // 80% of income

      // Every bar shows the gap between income and expenses:
      // the amount over (red), the small amount left (orange) or the
      // amount saved (blue)
      if (expenses > income) {
        periodData.add({
          "month": month,
          "overspending": expenses - income,
          "risk": 0.0,
          "within": 0.0,
        });
      } else if (expenses > 0 && expenses >= income * riskThreshold) {
        periodData.add({
          "month": month,
          "overspending": 0.0,
          "risk": income - expenses,
          "within": 0.0,
        });
      } else {
        periodData.add({
          "month": month,
          "overspending": 0.0,
          "risk": 0.0,
          "within": income - expenses,
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
      final startOfMonth = DateTime(now.year, now.month - i, 1);
      final startOfNextMonth = DateTime(now.year, now.month - i + 1, 1);

      final monthTxns = historyTransactions.where((tx) {
        return !tx.date.isBefore(startOfMonth) &&
            tx.date.isBefore(startOfNextMonth);
      }).toList();

      // English key; the charts translate it with getLocalizedMonth
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

  Map<String, int> getCurrentMonthTotals() => _totals(reportTransactions);

  static Map<String, int> _totals(List<TransactionModel> txns) {
    int totalExpense = 0;
    int totalIncome = 0;

    for (var tx in txns) {
      if (tx.type == TransactionType.expense) {
        totalExpense += tx.amount;
      } else if (tx.includeInTotal) {
        // Only include income if includeInTotal is true
        totalIncome += tx.amount;
      }
    }

    return {"expense": totalExpense, "income": totalIncome};
  }

  /// Warns once per month when this month's expenses go over its income.
  /// Reads the database directly so it sees the transaction that was just
  /// saved, and always checks the real current month, not the one the
  /// report screen happens to show.
  Future<void> warningshow() async {
    try {
      final now = DateTime.now();
      final rows = await transactionProvider.addTransactionDbHelper
          .getTransactionsByDateRange(
            DateTime(now.year, now.month, 1).toIso8601String(),
            _endOfMonth(now).toIso8601String(),
          );
      final totals = _totals(rows.map(TransactionModel.fromMap).toList());
      final expense = totals["expense"] ?? 0;
      final income = totals["income"] ?? 0;

      final prefs = await SharedPreferences.getInstance();
      final key = 'overspend_warned_${now.year}_${now.month}';

      // No income recorded means nothing to compare against
      if (income > 0 && expense > income) {
        if (prefs.getBool(key) ?? false) return;
        await prefs.setBool(key, true);
        await ReminderHelper.tt(
          "warningTitleTransacton",
          "warningDescTransacton",
        );
      } else {
        // Back under the limit: warn again if it goes over later
        await prefs.remove(key);
      }
    } catch (e) {
      debugPrint("warningshow error: $e");
    }
  }
}
