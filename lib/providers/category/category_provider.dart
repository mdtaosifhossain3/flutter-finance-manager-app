import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:flutter/widgets.dart';

class CategoryProvider extends ChangeNotifier {
  TransactionType selectedType = TransactionType.expense;

  void changeSelectedType(TransactionType val) {
    selectedType = val;
    notifyListeners();
  }

}