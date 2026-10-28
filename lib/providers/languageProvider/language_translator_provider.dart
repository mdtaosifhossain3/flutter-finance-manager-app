import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class LanguageTranslatorProvider with ChangeNotifier {
  Locale _locale = const Locale('bn', 'BD');

  Locale get locale => _locale;

  LanguageTranslatorProvider() {
    _loadLocale();
  }

  void setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();

    // update GetX locale too
    Get.updateLocale(locale);

    // save in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', locale.languageCode);
    prefs.setString('countryCode', locale.countryCode ?? '');
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('languageCode') ?? 'bn';
    final countryCode = prefs.getString('countryCode') ?? 'BD';
    _locale = Locale(langCode, countryCode);

    // set GetX locale
    Get.updateLocale(_locale);

    notifyListeners();
  }
}
