import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeViewProvider extends  ChangeNotifier{
  String selectedPeriod = 'Monthly';

  void updateSelectedPeriod(String period) {
    selectedPeriod = period;
    notifyListeners();
  }

}