import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme(); // Load theme when provider is created
  }

  Future<void> setTheme(String value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value == "Light") {
      _themeMode = ThemeMode.light;
    } else if (value == "Dark") {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }

    // Save to SharedPreferences
    await prefs.setString('themeMode', _themeMode.toString());

    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('themeMode');

    if (savedTheme != null) {
      if (savedTheme.contains("light")) {
        _themeMode = ThemeMode.light;
      } else if (savedTheme.contains("dark")) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.system;
      }
      notifyListeners();
    }
  }
}
