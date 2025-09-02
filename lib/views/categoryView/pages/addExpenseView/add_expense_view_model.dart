import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExpenseViewModel{
  AddExpenseViewModel._();
  static final TextEditingController amountController = TextEditingController();
  static final TextEditingController titleController = TextEditingController();
  static  final TextEditingController messageController = TextEditingController();

 static DateTime currentDate = DateTime.now();
 static String selectedCategory = '';

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate,
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //     });
  //   }
  // }

 static String formatDate(DateTime date) {
    return DateFormat('MMMM d, y').format(date); // e.g., August 12, 2025
  }
}