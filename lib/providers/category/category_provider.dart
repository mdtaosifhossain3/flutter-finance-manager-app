
import 'package:flutter/material.dart';

import '../../config/enums/enums.dart';

class CategoryProvider extends ChangeNotifier {
  TransactionType selectedType = TransactionType.expense;
  bool isSearchBarShowed = true;
  String searchQuery = '';

  void changeSelectedType(TransactionType val) {
    selectedType = val;
    notifyListeners();
  }

  void setIsSearchBarShowed() {
    isSearchBarShowed = !isSearchBarShowed;
    if (!isSearchBarShowed) {
      searchQuery = '';
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    searchQuery = query.toLowerCase();
    notifyListeners();
  }
}
