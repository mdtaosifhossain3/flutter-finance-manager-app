import 'package:flutter/cupertino.dart';

class  CategoryItemProvider extends ChangeNotifier {
  DateTime selectedMonth = DateTime.now();


  void setSelectedMonth(DateTime? month) {
    selectedMonth = month!;
    notifyListeners();
  }
}