import 'package:flutter/cupertino.dart';

import '../../models/categoryModel/transaction_model.dart';
import 'transaction_provider.dart';

class CategoryItemProvider extends ChangeNotifier {
  DateTime selectedMonth = DateTime.now();
  final AddExpenseProvider transactionProvider;

  CategoryItemProvider({required this.transactionProvider});

  List<TransactionModel> filteredTransactions({String? selectedCategory}) {
    return transactionProvider.expenseList.where((transaction) {
      final matchesMonth =
          transaction.date.year == selectedMonth.year &&
          transaction.date.month == selectedMonth.month;

      final matchesCategory =
          selectedCategory == null ||
          transaction.categoryName == selectedCategory;

      return matchesMonth && matchesCategory;
    }).toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  void setSelectedMonth(DateTime? month) {
    selectedMonth = month!;
    notifyListeners();
  }
}
