import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeViewProvider extends ChangeNotifier {
  String selectedPeriod = 'Monthly';
  String _searchQuery = "";
  String get searchQuery => _searchQuery;
  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  List<TransactionModel> get filteredTransactions {
    final periodFiltered = filterTransactions(dwm);

    if (_searchQuery.isEmpty) return periodFiltered;

    return periodFiltered.where((tx) {
      return tx.categoryName.toLowerCase().contains(_searchQuery) ||
          tx.amount.toString().contains(_searchQuery);
    }).toList();
  }

  String dwm = 'periodWeek'.tr;
  void setDWM(val) {
    dwm = val;
    notifyListeners();
  }

  final AddExpenseProvider transactionProvider;
  HomeViewProvider({required this.transactionProvider});

  //day week and month data
  List<TransactionModel> filterTransactions(String filter) {
    final range = getRange(filter);

    return transactionProvider.expenseList.where((tx) {
      return tx.date.isAfter(range.start) && tx.date.isBefore(range.end);
    }).toList();
  }

  DateTimeRange getRange(String filter) {
    final now = DateTime.now();

    if (filter == "periodDay".tr) {
      return DateTimeRange(
        start: DateTime(now.year, now.month, now.day),
        end: DateTime(now.year, now.month, now.day, 23, 59, 59),
      );
    } else if (filter == "periodWeek".tr) {
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(Duration(days: 6));
      return DateTimeRange(
        start: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
        end: DateTime(
          endOfWeek.year,
          endOfWeek.month,
          endOfWeek.day,
          23,
          59,
          59,
        ),
      );
    } else {
      // month
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);
      return DateTimeRange(
        start: startOfMonth,
        end: DateTime(
          endOfMonth.year,
          endOfMonth.month,
          endOfMonth.day,
          23,
          59,
          59,
        ),
      );
    }
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
