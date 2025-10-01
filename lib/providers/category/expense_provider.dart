import 'package:finance_manager_app/config/db/local/category_db/add_transaction_db_helper.dart';
import 'package:finance_manager_app/models/tempm/categoryModel/transaction_model.dart';
import 'package:flutter/material.dart';

class AddExpenseProvider extends ChangeNotifier{
  AddTransactionDbHelper addTransactionDbHelper = AddTransactionDbHelper.getInstance;
 List<TransactionModel> expenseList = [];
  IconData categoryIconData = Icons.info;



  //Events
  Future<void> addExpense(TransactionModel tn) async {
    try{
      await addTransactionDbHelper.addItem(tn);
      getAllExpenses();
      notifyListeners();
    }catch(er){
      print(er);
    }

  }

  void getAllExpenses() async {
    final dt = await  addTransactionDbHelper.getAllNotes();
    expenseList = dt.map((e) => TransactionModel.fromMap(e)).toList();
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