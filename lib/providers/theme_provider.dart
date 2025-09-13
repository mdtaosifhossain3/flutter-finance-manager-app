import 'package:flutter/material.dart';
import '../config/theme/app_theme.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = true;

  ThemeData get theme => _isDark ? AppThemes.darkTheme : AppThemes.lightTheme;

  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
