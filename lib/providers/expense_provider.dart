import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/db/local/local_db_helper.dart';
import '../models/expense_model.dart';

class AddExpenseProvider extends ChangeNotifier{
  LocalDBHelper localDBHelper = LocalDBHelper.getInstance;
  List<Expense> expenseList = [];
  IconData categoryIconData = Icons.info;

  //Events
  Future<void> addExpense({selectedDate,titleController,amountController,selectedCategory,messageController}) async {
    // Logic to add expense
    final ex = Expense(
        date: selectedDate.toString(),
        title: titleController.text,
        amount:double.parse(amountController.text),
        icon: categoryIconData.toString(),
        month: DateFormat('MMMM').format(DateTime.now()),
        time: DateFormat('h:mm a').format(DateTime.now()),
        categoryName: selectedCategory,
        message: messageController.text);

    await localDBHelper.addItem(ex);

    // final dt = await  localDBHelper.getAllNotes();
    // print('Fetched expenses: $dt');


    getAllExpenses();
    notifyListeners();
  }

  void getAllExpenses() async {
    final dt = await  localDBHelper.getAllNotes();
    // if (kDebugMode) {
    //   print('Fetched expenses: $dt');
    // }
    expenseList = dt.map((e) => Expense.fromMap(e)).toList();
    notifyListeners();
  }

Future<void> selectDate(BuildContext context,selectedDate) async {
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
// final dt = await  localDBHelper.getAllNotes();
// setState(() {
//   print('Fetched expenses: $dt');
// });
// Handle save expense
// ScaffoldMessenger.of(context).showSnackBar(
//   const SnackBar(
//     content: Text('Expense saved successfully!'),
//     backgroundColor: AppColors.carbbeanGreen,
//   ),
// );


  void setCategoryIcon(IconData iconData) {
    categoryIconData = iconData;
    notifyListeners();
  }
}