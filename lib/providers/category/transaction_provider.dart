import 'package:finance_manager_app/config/db/local/category_db/add_transaction_db_helper.dart';
import 'package:finance_manager_app/config/db/local/receipt_db/receipt_db_helper.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/services/home_widget_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddExpenseProvider extends ChangeNotifier {
  AddTransactionDbHelper addTransactionDbHelper;
  AddExpenseProvider({required this.addTransactionDbHelper});

  //-----------------------------All The Income Expense List-----------------------------
  List<TransactionModel> transactionData = [];
  bool isLoading = false;

  //Payment Method
  late String selectedPaymentMethod;
  //date selector
  late DateTime selectedDate;
  DateTime currentMonth = DateTime.now(); // Track currently displayed month

  void setselectedPaymentMethod(val) {
    selectedPaymentMethod = val;
    notifyListeners();
  }

  void setSelectedDate(picked) {
    selectedDate = DateTime(
      picked.year,
      picked.month,
      picked.day,
      DateTime.now().hour,
      DateTime.now().minute,
      DateTime.now().second,
    );
    notifyListeners();
  }

  void clearDate() {
    selectedDate = DateTime.now();
    notifyListeners();
  }

  //Events
  Future<void> addExpense(TransactionModel tn) async {
    try {
      await addTransactionDbHelper.addItem(tn);
      await getTransactionsForMonth(currentMonth);
      notifyListeners();
    } catch (er) {
      if (kDebugMode) {
        print(er);
      }
    }
  }

  Future<List<TransactionModel>> getTransactionsForMonth(DateTime date) async {
    // Yield to let the UI render the first frame
    await Future.delayed(Duration.zero);
    isLoading = true;
    notifyListeners();
    currentMonth = date;

    try {
      final startOfMonth = DateTime(date.year, date.month, 1);
      // Include the final second (dates are stored with microseconds)
      final endOfMonth = DateTime(
        date.year,
        date.month + 1,
        0,
        23,
        59,
        59,
        999,
        999,
      );

      final dt = await addTransactionDbHelper.getTransactionsByDateRange(
        startOfMonth.toIso8601String(),
        endOfMonth.toIso8601String(),
      );

      final transactions = dt.map((e) => TransactionModel.fromMap(e)).toList();

      transactionData = transactions;
      return transactions;
    } catch (e) {
      debugPrint("Error in getTransactionsForMonth: $e");
      return [];
    } finally {
      isLoading = false;
      notifyListeners();
      HomeWidgetService.refresh();
    }
  }

  // Future<void> getAllInitialTransactions() async {
  //   isLoading = true;
  //   await addTransactionDbHelper.getAllNotes();
  //   isLoading = false;
  //   notifyListeners();
  // }

  Future<void> selectDate(BuildContext context, selectedDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      notifyListeners();
    }
  }

  Future<void> updateTransaction(int itemId, TransactionModel tx) async {
    await addTransactionDbHelper.updateItem(itemID: itemId, tx: tx);
    await getTransactionsForMonth(currentMonth);
  }

  Future<void> deleteTransaction(int transactionID) async {
    await addTransactionDbHelper.deleteItem(transactionID);
    try {
      await ReceiptDbHelper.getInstance.deleteByTransaction(transactionID);
    } catch (e) {
      debugPrint("Error deleting receipt: $e");
    }
    await getTransactionsForMonth(currentMonth);
  }

  Future<void> deleteFullTransaction() async {
    try {
      await addTransactionDbHelper.deleteFull();
      transactionData = [];
      await ReceiptDbHelper.getInstance.deleteAll();
      notifyListeners();
    } catch (e) {
      debugPrint("Error in deleteFullTransaction: $e");
    }
  }
}
