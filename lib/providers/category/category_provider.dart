
import 'dart:async';

import 'package:flutter/material.dart';

import '../../config/enums/enums.dart';

class CategoryProvider extends ChangeNotifier {

  TransactionType selectedType = TransactionType.expense;
  bool isSearchBarShowed = true;
  String _searchQuery = '';
  Timer? _debounce;

  String get searchQuery => _searchQuery;

  void changeSelectedType(TransactionType val) {
    if (val != selectedType) {
      selectedType = val;
      notifyListeners();
    }
  }

  void setIsSearchBarShowed() {
    isSearchBarShowed = !isSearchBarShowed;
    if (!isSearchBarShowed) {
      _searchQuery = '';
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized == _searchQuery) return; // no need to rebuild

    // debounce input to avoid spamming rebuilds
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _searchQuery = normalized;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
