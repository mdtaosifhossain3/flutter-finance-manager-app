import 'package:finance_manager_app/config/db/local/category_db/add_transaction_db_helper.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddExpenseProvider extends ChangeNotifier {
  AddTransactionDbHelper addTransactionDbHelper =
      AddTransactionDbHelper.getInstance;
  List<TransactionModel> expenseList = [];
  IconData categoryIconData = Icons.info;
  late String selectedPaymentMethod;
  late DateTime selectedDate;

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
      getAllExpenses();
      notifyListeners();
    } catch (er) {
      if (kDebugMode) {
        print(er);
      }
    }
  }

  void getAllExpenses() async {
    final dt = await addTransactionDbHelper.getAllNotes();
    expenseList = dt.map((e) => TransactionModel.fromMap(e)).toList();
    notifyListeners();
  }

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
    getAllExpenses();
  }

  Future<void> deleteTransaction(int transactionID) async {
    await addTransactionDbHelper.deleteItem(transactionID);
    getAllExpenses();
  }

  void setCategoryIcon(IconData iconData) {
    categoryIconData = iconData;
    notifyListeners();
  }
}
