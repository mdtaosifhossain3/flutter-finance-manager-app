import 'dart:convert';

import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/data/category/category_item_data.dart';
import 'package:finance_manager_app/data/category/income_item_data.dart';
import 'package:finance_manager_app/models/categoryModel/category_item_model.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/services/parser/transaction_parser.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Turns the user's typed or spoken note into transactions with the offline
/// [TransactionParser] (no AI, no network).
class AiProvider with ChangeNotifier {
  // Words the user taught by correcting a category in the preview.
  static const String _learnedPrefsKey = 'parser_learned_words';
  static const int _maxLearnedWords = 500;

  Map<String, String>? _learned;
  TransactionParser? _parser;
  // What the parser guessed for each item in [_parsedDataEx], same order.
  List<ParsedTransaction> _guesses = [];

  // String? _speechErrorMessage;

  // UI / input
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  // Loading / preview / results
  bool _isLoading = false;
  TransactionModel? _parsedData;
  List<TransactionModel> _parsedDataEx = [];

  // Getters
  bool get isLoading => _isLoading;
  // String? get speechErrorMessage => _speechErrorMessage;
  TransactionModel? get parsedData => _parsedData;
  List<TransactionModel> get parsedDataEx => _parsedDataEx;
  bool get hasText => textController.text.trim().isNotEmpty;

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> processInput() async {
    final userText = textController.text.trim();
    if (userText.isEmpty) return false;

    HapticFeedback.selectionClick();

    _parser ??= TransactionParser(learned: await _loadLearned());
    final guesses = _parser!.parse(userText);
    if (guesses.isEmpty) {
      _showNoAmountFound();
      return false;
    }

    _guesses = guesses;
    _parsedDataEx = guesses.map(_toTransaction).toList();
    notifyListeners();
    return true;
  }

  TransactionModel _toTransaction(ParsedTransaction p) {
    final category = _findCategory(p.categoryKey, p.isIncome);
    // The parser gives a date only; add the current time so the UI doesn't
    // show 12:00 AM.
    final now = DateTime.now();

    return TransactionModel(
      title: p.title,
      type: p.isIncome ? TransactionType.income : TransactionType.expense,
      amount: p.amount,
      categoryKey: category.key,
      date: DateTime(
        p.date.year,
        p.date.month,
        p.date.day,
        now.hour,
        now.minute,
        now.second,
      ),
      notes: '',
      paymentMethod: p.paymentMethod,
      icon: category.icon,
      iconBgColor: category.color.toARGB32(),
    );
  }

  CategoryItemModel _findCategory(String key, bool isIncome) {
    final cats = isIncome ? incomeCategoryItems : categoryItems;
    final fallbackKey = isIncome
        ? 'miscellaneous_income'
        : 'miscellaneous_expense';

    for (final k in [key, fallbackKey]) {
      for (final c in cats) {
        if (c.key == k) return c;
      }
    }

    return CategoryItemModel(
      fallbackKey,
      isIncome ? 'other_income' : 'other',
      const Color(0xFF636E72),
    );
  }

  Future<Map<String, String>> _loadLearned() async {
    if (_learned != null) return _learned!;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_learnedPrefsKey);
      _learned = raw == null
          ? {}
          : Map<String, String>.from(jsonDecode(raw) as Map);
    } catch (e) {
      debugPrint('AiProvider: could not load learned words: $e');
      _learned = {};
    }
    return _learned!;
  }

  /// Remembers the words of every item whose category the user changed, so
  /// the same words get that category next time.
  Future<void> _learnFromCorrections() async {
    // Collect before the first await: the preview may be reset meanwhile.
    final corrections = <String, String>{};
    for (var i = 0; i < _parsedDataEx.length && i < _guesses.length; i++) {
      final finalKey = _parsedDataEx[i].categoryKey;
      if (finalKey == _guesses[i].categoryKey) continue;
      for (final word in _guesses[i].words) {
        corrections[word] = finalKey;
      }
    }
    if (corrections.isEmpty) return;

    final learned = await _loadLearned();
    corrections.forEach((word, key) {
      learned.remove(word); // re-insert so it counts as the newest
      learned[word] = key;
    });

    while (learned.length > _maxLearnedWords) {
      learned.remove(learned.keys.first);
    }
    _parser = TransactionParser(learned: learned);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_learnedPrefsKey, jsonEncode(learned));
    } catch (e) {
      debugPrint('AiProvider: could not save learned words: $e');
    }
  }

  void _showNoAmountFound() {
    Get.snackbar(
      '',
      'no_amount_found'.tr,
      titleText: const SizedBox.shrink(),
      messageText: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'no_amount_found'.tr,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.orange[800],
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
    );
  }

  // void setSpeechError() {
  //   if (_speechErrorMessage != null && !Get.isSnackbarOpen) {
  //     Get.snackbar(
  //       'Speech Error ⚠️',
  //       _speechErrorMessage!,
  //       snackPosition: SnackPosition.TOP,
  //       backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
  //       colorText: Colors.white,
  //       margin: const EdgeInsets.all(10),
  //       borderRadius: 10,
  //       duration: const Duration(seconds: 3),
  //     );
  //   }
  // }

  // keep other helper methods you already have (editTransaction, deleteTransaction, saveTransaction, resetPreview, etc.)
  void editTransaction() {
    notifyListeners();
  }

  void deleteTransaction() {
    HapticFeedback.lightImpact();
    textController.clear();
    _parsedData = null;
    notifyListeners();
  }

  void resetPreview() {
    _parsedDataEx = [];
    _guesses = [];
    notifyListeners();
  }

  void clearInput() {
    textController.clear();
    notifyListeners();
  }

  void updateIncludeInTotal(int index, bool value) {
    if (index >= 0 && index < _parsedDataEx.length) {
      final tx = _parsedDataEx[index];
      _parsedDataEx[index] = TransactionModel(
        id: tx.id,
        type: tx.type,
        date: tx.date,
        title: tx.title,
        amount: tx.amount,
        notes: tx.notes,
        paymentMethod: tx.paymentMethod,
        iconBgColor: tx.iconBgColor,
        categoryKey: tx.categoryKey,
        icon: tx.icon,
        includeInTotal: value,
      );
      notifyListeners();
    }
  }

  void updateCategory(int index, CategoryItemModel newCategory) {
    if (index >= 0 && index < _parsedDataEx.length) {
      final tx = _parsedDataEx[index];
      _parsedDataEx[index] = TransactionModel(
        id: tx.id,
        type: tx.type,
        date: tx.date,
        title: tx.title,
        amount: tx.amount,
        notes: tx.notes,
        paymentMethod: tx.paymentMethod,
        iconBgColor: newCategory.color.toARGB32(),
        categoryKey: newCategory.key,
        icon: newCategory.icon,
        includeInTotal: tx.includeInTotal,
      );
      notifyListeners();
    }
  }

  void removeTransactionAt(int index) {
    if (index < 0 || index >= _parsedDataEx.length) return;
    _parsedDataEx.removeAt(index);
    if (index < _guesses.length) _guesses.removeAt(index);
    notifyListeners();
  }

  void saveTransaction(BuildContext context) {
    HapticFeedback.mediumImpact();
    _isLoading = true;
    notifyListeners();

    for (var tx in _parsedDataEx) {
      context.read<AddExpenseProvider>().addExpense(tx);
    }
    _learnFromCorrections();

    _isLoading = false;
    textController.clear();
    _parsedData = null;
    notifyListeners();
  }
}
