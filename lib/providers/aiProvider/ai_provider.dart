import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/data/category/category_item_data.dart';
import 'package:finance_manager_app/data/category/income_item_data.dart';
import 'package:finance_manager_app/models/categoryModel/category_item_model.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AiProvider with ChangeNotifier {
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
    if (textController.text.trim().isEmpty) return false;

    HapticFeedback.selectionClick();
    //final te = "I give wifi bill 500tk";
    final userText = textController.text.trim();
    //textController.text.trim();
    final today = DateTime.now().toIso8601String().split('T').first;

    final tt =
        '''
You are a finance parser for a Bangladeshi money app. Convert user text (Bangla/English/Banglish) into a JSON array of transactions.

REFERENCE_DATE: $today
USER INPUT:
"$userText"

FORMAT:
[{
 "title": string,
 "type": "income"|"expense",
 "amount": number,
 "categoryName": string,
 "date": string,        // ISO8601 format: YYYY-MM-DD
 "notes": string,
 "paymentMethod": string
}]

Rules:
- If multiple payments mentioned (e.g. “Lunch 200 and bus 50”) return multiple JSON objects.
- Detect income/expense from words: spent, paid, bought, খরচ, দিলাম, বিল, send = expense; got, received, earned, salary, পেলাম, আয় = income.
- If type = income and no clear income keyword appears, use categoryName = "salary".
- Extract numeric amount, remove tk/৳, convert Bangla digits.
- Payment: bkash, nagad, rocket, upay, credit, debit, bank; else cash.
- Category keywords decide categoryName; fallback = miscellaneous_income (for income) or miscellaneous_expense (for expense).
- Title = short name (e.g., Bus Fare).
- Return JSON only.
- If amounts are separated by commas, spaces, or plus signs ("200,200", "170 200", "170+200", "170 + 200"),
  create SEPARATE transactions for each amount.
- "+" NEVER means income. It only separates multiple amounts.

Date Calculation Rules:
1. "আজ", "today" → Use REFERENCE_DATE.
2. "গতকাল", "yesterday" → Calculate (REFERENCE_DATE - 1 day).
3. "আগামীকাল", "tomorrow" → Calculate (REFERENCE_DATE + 1 day).
4. "X দিন আগে", "X days ago" → Calculate (REFERENCE_DATE - X days).
5. For specific dates (e.g., "15 Oct", "১৫ই অক্টোবর"), use the year from REFERENCE_DATE unless a specific year is mentioned.
6. If NO date is found in the text, use REFERENCE_DATE.

Categories:
health_fitness, food_dining, bills_utilities, beauty, housing, transportation, entertainment,
shopping, groceries, education, personal, investment, marketing_advertising, travel_accommodation,
office_supplies_equipment, insurance, subscription_services, fuel_mileage, charity_donations,
kids, repairs, pets, sports, salary, business, sales_revenue, service_income,
freelance_contracts, investment_returns, rental_income, asset_sales, royalties_licensing,
interest_dividends, side_income, commissions_affiliates, refunds_reimbursements,
gifts, grants_subsidies, miscellaneous_income, miscellaneous_expense.
''';

    // Show loader for the whole processing duration and ensure it is
    // always cleared, even on errors.
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent?key=${dotenv.env['API_KEY']}',
      );

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "contents": [
                {
                  "parts": [
                    {"text": tt},
                  ],
                },
              ],
            }),
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) {
        _isLoading = false;
        errorMSG('Failed to fetch data');
        print(response.body);
        notifyListeners();
        return false;
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content =
            data['candidates']?[0]?['content']?['parts']?[0]?['text'];

        if (content == null || content.toString().trim().isEmpty) {
          errorMSG('No content in response');

          _isLoading = false;
          notifyListeners();
          return false;
        }

        // Clean Markdown fences (```json ... ```)
        final cleaned = content
            .replaceAll(RegExp(r'```json', caseSensitive: false), '')
            .replaceAll('```', '')
            .trim();
        if (cleaned.isEmpty) {
          errorMSG("No content in response");
          _isLoading = false;
          notifyListeners();
          return false;
        }

        // Decode with error handling
        final dynamic parsed;
        try {
          parsed = jsonDecode(cleaned);
        } catch (e) {
          errorMSG("Failed to parse response");
          _isLoading = false;
          notifyListeners();
          return false;
        }

        // Ensure it's a list (AI might sometimes return a single object)
        final List<dynamic> transactions = parsed is List ? parsed : [parsed];

        // Convert each transaction into TransactionModel
        _parsedDataEx = transactions.map<TransactionModel>((item) {
          final isIncome = item['type']?.toString().toLowerCase() == 'income';
          final categoryName =
              item['categoryName']?.toString().trim() ??
              (isIncome ? 'miscellaneous_income' : 'miscellaneous_expense');

          final categories = isIncome ? incomeCategoryItems : categoryItems;

          // Enhanced category matching helper
          CategoryItemModel findBestCategory(
            String rawName,
            List<CategoryItemModel> cats,
          ) {
            final q = rawName.trim().toLowerCase();
            if (q.isEmpty) return cats.first;

            // 1) Exact key match (categoryData.key)
            for (final c in cats) {
              //Find the Category
              if (c.key.toLowerCase() == q) {
                return c;
              }
            }

            // 2) Fallback to specific miscellaneous category
            final fallbackKey = isIncome
                ? 'miscellaneous_income'
                : 'miscellaneous_expense';
            for (final c in cats) {
              if (c.key.toLowerCase() == fallbackKey) {
                return c;
              }
            }

            return CategoryItemModel(
              fallbackKey,
              isIncome ? 'other_income' : 'other',
              Color(0xFF636E72),
            );
          }

          final matchedCategory = findBestCategory(categoryName, categories);

          // Normalize amount to int (TransactionModel.amount is int)
          int parseAmount(dynamic a) {
            if (a == null) return 0;
            if (a is int) return a;
            if (a is double) return a.toInt();
            final s = a.toString();
            // Remove non-digit characters (like currency symbols) then parse
            final cleaned = s.replaceAll(RegExp(r'[^0-9\.-]'), '');
            return int.tryParse(cleaned.split('.').first) ??
                (double.tryParse(cleaned)?.toInt() ?? 0);
          }

          return TransactionModel(
            title: item['title'] ?? '',
            type: isIncome ? TransactionType.income : TransactionType.expense,
            amount: parseAmount(item['amount']),
            categoryKey: matchedCategory.key,
            // Parse date string; if time part is missing (parsed at midnight),
            // combine with current time so UI doesn't show 12:00 AM.
            date: (() {
              final raw = (item['date'] ?? '').toString().trim();
              if (raw.isEmpty) return DateTime.now();
              final parsedDate = DateTime.tryParse(raw);
              if (parsedDate == null) return DateTime.now();
              // If parsed time is exactly midnight and original string looks like a date-only (YYYY-MM-DD)
              final hasTimePart =
                  raw.contains(':') ||
                  raw.toLowerCase().contains('t') && raw.contains(' ');
              if (parsedDate.hour == 0 &&
                  parsedDate.minute == 0 &&
                  !hasTimePart) {
                final now = DateTime.now();
                return DateTime(
                  parsedDate.year,
                  parsedDate.month,
                  parsedDate.day,
                  now.hour,
                  now.minute,
                  now.second,
                );
              }
              return parsedDate;
            })(),
            notes: item['notes'] ?? '',
            paymentMethod: item['paymentMethod'] ?? 'cash',
            icon: matchedCategory.icon,
            iconBgColor: matchedCategory.color.toARGB32(),
          );
        }).toList();

        // _isLoading = false; // Keep loading true for smooth navigation
        notifyListeners();
        return true;
      } else {
        errorMSG('AI request failed (${response.statusCode})');

        _isLoading = false;

        notifyListeners();
        return false;
      }
    } on TimeoutException {
      // Timeout exception snackbar
      Get.snackbar(
        '',
        'connection_timeout'.tr,
        titleText: const SizedBox.shrink(),
        messageText: Row(
          children: [
            const Icon(Icons.access_time, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'connection_timeout'.tr,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange[700],
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
      _isLoading = false;
      notifyListeners();
      return false;
    } on SocketException {
      Get.snackbar(
        '',
        'no_internet_connection'.tr,
        titleText: const SizedBox.shrink(),
        messageText: Row(
          children: [
            const Icon(Icons.wifi_off, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'no_internet_connection'.tr,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red[700],
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      errorMSG("something_went_wrong".tr);

      notifyListeners();
      return false;
    }
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

  void errorMSG(msg) {
    Get.snackbar(
      '',
      msg,
      titleText: const SizedBox.shrink(),

      backgroundColor: Colors.red[700],
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
    );
  }

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

  void saveTransaction(BuildContext context) {
    HapticFeedback.mediumImpact();
    _isLoading = true;
    notifyListeners();

    for (var tx in _parsedDataEx) {
      context.read<AddExpenseProvider>().addExpense(tx);
    }

    _isLoading = false;
    textController.clear();
    _parsedData = null;
    notifyListeners();
  }
}
