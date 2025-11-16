import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/models/homeModel/home_model.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeViewProvider extends ChangeNotifier {
  String selectedPeriod = 'Monthly';
  String _searchQuery = "";
  String get searchQuery => _searchQuery;
  bool isLoading = false;
  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  List<TransactionModel> get filteredTransactionsForReport {
    final range = getRange(dwm);
    final periodFiltered = transactionProvider.transactionData.where((tx) {
      return tx.date.isAfter(range.start) && tx.date.isBefore(range.end);
    }).toList();

    if (_searchQuery.isEmpty) return periodFiltered;

    return periodFiltered.where((tx) {
      return tx.categoryKey.toLowerCase().contains(_searchQuery) ||
          tx.amount.toString().contains(_searchQuery);
    }).toList();
  }

  List<CategorySummary> get filteredTransactionsForHome {
    final range = getRange(dwm);

    // Step 1: Filter transactions by date range
    final filtered = transactionProvider.transactionData.where((tx) {
      return tx.date.isAfter(range.start) && tx.date.isBefore(range.end);
    }).toList();

    final Map<String, CategorySummary> summaryMap = {};

    for (var tx in filtered) {
      final key = tx.categoryKey;

      if (summaryMap.containsKey(key)) {
        final existing = summaryMap[key]!;
        summaryMap[key] = CategorySummary(
          categoryName: existing.categoryName,
          count: existing.count + 1,
          total: existing.total + tx.amount,
          icon: existing.icon,
          iconBgColor: existing.iconBgColor,
          type: existing.type,
        );
      } else {
        summaryMap[key] = CategorySummary(
          categoryName: tx.categoryKey,
          count: 1,
          total: tx.amount,
          icon: tx.icon,
          iconBgColor: tx.iconBgColor,
          type: tx.type,
        );
      }
    }

    return summaryMap.values.toList();
  }

  String dwm = 'periodMonth'.tr;
  void setDWM(val) {
    dwm = val;
    notifyListeners();
  }

  AddExpenseProvider transactionProvider;
  HomeViewProvider({required this.transactionProvider}) {
    // Listen to updates from AddExpenseProvider
    transactionProvider.addListener(() {
      notifyListeners(); // <-- Rebuild home when transactions change
    });
  }

  //day week and month data
  List<TransactionModel> filterTransactions(String filter) {
    final range = getRange(filter);

    // Step 1: Filter transactions by date range
    final filtered = transactionProvider.transactionData.where((tx) {
      return tx.date.isAfter(range.start) && tx.date.isBefore(range.end);
    }).toList();

    // Step 2: Group by category and sum amounts
    final Map<String, Map<String, dynamic>> categorySummary = {};

    for (var tx in filtered) {
      final category = tx.categoryKey; // or tx.category if you use that field

      if (categorySummary.containsKey(category)) {
        // Already exists → update count & sum
        categorySummary[category]!['count'] += 1;
        categorySummary[category]!['total'] += tx.amount;
      } else {
        // New category → initialize
        categorySummary[category] = {'count': 1, 'total': tx.amount};
      }
    }

    return transactionProvider.transactionData.where((tx) {
      return tx.date.isAfter(range.start) && tx.date.isBefore(range.end);
    }).toList();
  }

  DateTimeRange getRange(String filter) {
    final now = DateTime.now();
    late DateTime start;
    late DateTime end;

    if (filter == "periodDay".tr) {
      start = DateTime(now.year, now.month, now.day);
      end = start
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
    } else if (filter == "periodWeek".tr) {
      start = now.subtract(Duration(days: now.weekday - 1));
      start = DateTime(start.year, start.month, start.day);

      end = start
          .add(const Duration(days: 7))
          .subtract(const Duration(seconds: 1));
    } else {
      start = DateTime(now.year, now.month, 1);
      end = DateTime(
        now.year,
        now.month + 1,
        1,
      ).subtract(const Duration(seconds: 1));
    }

    return DateTimeRange(start: start, end: end);
  }

  Map<String, int> calculateTotals(List<TransactionModel> filteredTxns) {
    int expenses = 0;
    int income = 0;

    for (var tx in filteredTxns) {
      if (tx.type == TransactionType.expense) {
        if (tx.amount == 0) {
          expenses = 0;
        }
        expenses += tx.amount;
      } else {
        if (tx.amount == 0) {
          income = 0;
        }
        income += tx.amount;
      }
    }

    return {"expenses": expenses, "income": income};
  }

  //Get total income and expense
  Map<String, int> getTotals() {
    final filtered = filterTransactions(dwm);
    return calculateTotals(filtered);
  }

  void updateSelectedPeriod(String period) {
    selectedPeriod = period;
    notifyListeners();
  }
}
