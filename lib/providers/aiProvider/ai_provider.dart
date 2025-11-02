import 'dart:convert';

import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/data/category/expense_category_map.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/views/homeView/home_view.dart';
import 'package:finance_manager_app/views/mainView/main_view.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:provider/provider.dart';
import '../../models/categoryModel/category_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../data/category/expense_cateogries.dart';
import '../../data/category/income_cateogries.dart';

class AiProvider with ChangeNotifier {
  // AiService can be wired here in future if external AI logic is moved out

  final stt.SpeechToText _speech = stt.SpeechToText();
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  bool _isRecording = false;
  bool _showPreview = false;
  bool _isLoading = false;
  bool _speechEnabled = false;
  String? _speechErrorMessage;
  TransactionModel? _parsedData;
  List<TransactionModel> _parsedDataEx = [];

  // Getters
  bool get isRecording => _isRecording;
  bool get showPreview => _showPreview;
  bool get isLoading => _isLoading;
  bool get speechEnabled => _speechEnabled;
  String? get speechErrorMessage => _speechErrorMessage;
  TransactionModel? get parsedData => _parsedData;
  List<TransactionModel> get parsedDataEx => _parsedDataEx;
  bool get hasText => textController.text.trim().isNotEmpty;

  AiProvider() {
    initSpeech();
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    _speech.stop();
    _speech.cancel();
    super.dispose();
  }

  Future<void> initSpeech() async {
    _speechErrorMessage = null;
    try {
      _speechEnabled = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            _isRecording = false;
            notifyListeners();
          }
        },
        onError: (error) {
          final parts = <String>[];
          if (error.errorMsg.isNotEmpty) {
            parts.add(error.errorMsg);
          }
          parts.add(error.permanent ? 'Permanent' : 'Transient');
          _speechErrorMessage = 'Speech error: ${parts.join(' — ')}';
          _speechEnabled = false;
          _isRecording = false;
          notifyListeners();
        },
      );

      if (!_speechEnabled) {
        _speechErrorMessage ??=
            'Speech recognition not available on this device.';
      }
    } catch (e) {
      _speechEnabled = false;
      _speechErrorMessage = 'Speech initialization failed: ${e.toString()}';
    }
    notifyListeners();
  }

  void toggleRecording() {
    if (!_speechEnabled) {
      HapticFeedback.vibrate();
      return;
    }

    if (!_isRecording) {
      _startListening();
    } else {
      _stopListening();
    }
  }

  void _startListening() {
    _isRecording = true;
    HapticFeedback.mediumImpact();
    notifyListeners();

    _speech.listen(
      onResult: (result) {
        textController.text = result.recognizedWords;
        textController.selection = TextSelection.fromPosition(
          TextPosition(offset: textController.text.length),
        );
        notifyListeners();
      },
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 3),
      onSoundLevelChange: null,
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
      ),
    );
  }

  void _stopListening() {
    HapticFeedback.lightImpact();
    _speech.stop();
    _isRecording = false;
    notifyListeners();
  }

  Future<void> processInput() async {
    if (textController.text.trim().isEmpty) return;

    HapticFeedback.selectionClick();
    //final te = "I give wifi bill 500tk";
    final userText = textController.text.trim();
    //textController.text.trim();

    final prompt =
        '''
You are a professional Bangladeshi personal finance assistant for a money management app.
Your task is to analyze the user's input (which may be in Bangla, English, or Banglish) and convert it into one or more structured transaction records.

USER INPUT:
"$userText"

Return only a **valid JSON array** (no comments or text outside the array) of one or more transaction objects using this structure:

[
  {
    "title": string,                // short transaction title like "Lunch", "Bus Fare", "Bkash Send Money"
    "type": "income" or "expense",  // logical transaction type
    "amount": number,               // numeric value only, currency symbols removed
    "categoryName": string,         // must match an existing category from the user’s expense/income category lists
    "date": string,                 // ISO8601 format: YYYY-MM-DD
    "notes": string,                // short optional context
    "paymentMethod": string         // one of: cash, bankTransfer, creditCard, debitCard, mobileWallet, check, bkash, nagad, rocket, upay
  }
]

### RULES:

1. **Language & Context**
   - The user may mix Bangla, English, or Banglish (e.g., "আমি আজ ২০০ টাকা লাঞ্চ খরচ করছি", "500tk lunch dilam", "Paid 200 taka for bus").
   - Detect meaning, numbers, and dates from all languages.
   - Ensure JSON keys remain in English.

2. **Multiple Transactions**
   - If the user mentions multiple payments in one message (e.g., “Lunch 200 and bus 50”), return separate objects.
   - Each object must include all required fields.

3. **Date Handling**
   - Understand natural language expressions like:
     - “আজ”, “আজকে”, “today” → today
     - “গতকাল”, “yesterday” → yesterday
     - “৩ দিন আগে”, “3 days ago” → 3 days before today
     - “১৫ই অক্টোবর”, “on 15 Oct”, “October 15” → specific date
   - Output all dates in ISO8601 format (YYYY-MM-DD).
   - Assume today’s date is ${DateTime.now().toIso8601String().split('T').first} if none given.

4. **Type Detection**
   - Expense indicators → “spent”, “paid”, “bought”, “খরচ”, “দিলাম”, “send”, “gave”, “bill”, “transfer”, “cash out”, “donated”.
   - Income indicators → “received”, “got”, “earned”, “salary”, “income”, “payment”, “bonus”, “refund”, “পেলাম”, “আয়”.
   - Default to “expense” if unclear.

5. **Amount Extraction**
   - Extract numeric value and remove words like “৳”, “tk”, “taka”, “BDT”.
   - Handle Bangla numerals (e.g., “৫০০ টাকা” → 500).
   - Each transaction must have an amount.

6. **Category Detection**
   - Infer categoryName using the following mapping logic:
     - food_dining → “ভাত”, “Lunch”, “Dinner”, “খাবার”, “Pizza”, “Restaurant”,“Groceries”
     - transportation → “Bus”, “CNG”, “Uber”, “Rickshaw”, “গাড়ি ভাড়া”
     - bills_utilities → “Electricity”, “Gas”, “Internet”, “Mobile Bill”, “বিদ্যুৎ বিল”
     - health_fitness → “Doctor”, “Medicine”, “Hospital”, “Gym”, “ফার্মেসি”, "Yoga","Sports"
     - education → “Tuition”, “Course”, “Exam”, “School”, “Book”, “কলেজ”
     - entertainment → “Movie”, “Concert”, “Game”, “Netflix”, “সিনেমা”
     - shopping → “Clothes”, “Mobile”, “Gift”, “Market”, “Dress”
     - family_personal → “Family”, “Friend”, “Gift”, “Child”, “Relative”, “Home”
     - investments_finance → “Bkash Send”, “Nagad Cash Out”, “Loan Repayment”, “Savings”, “Investment”
     - primary_income → “Salary”, “Freelance”, “Project”, “Bonus”, “Payment Received”
     - miscellaneous → if no clear match
     - investments → 'stocks','dividends','crypto','mutual_funds','bonds','real_estate'
     - rental_assets → 'rental','vehicle_rent','property_lease',','equipment_hire'
     - side_income → 'part_time','commission','consulting','tutoring','affiliate_marketing','online_sales','content_creation'
     - other_income → 'bonus','incomegifts','refund','donations','awards_prizes','cashback_rewards','lottery_gambling','interest_income'
     - passive_income → 'royalties','ads_revenue','licensing','divine_donations'

   - Always choose the closest valid category name from the known category lists.

7. **Payment Method Detection**
   - Match common keywords:
     - “bkash”, “বিকাশ” → bkash
     - “nagad”, “নগদ” → nagad
     - “rocket”, “রকেট” → rocket
     - “upay”, “উপায়” → upay
     - “bank”, “transfer”, “cheque”, “bankTransfer” → bankTransfer
     - “credit card”, “credit” → creditCard
     - “debit card”, “debit” → debitCard
     - “wallet”, “mobile wallet” → mobileWallet
     - Otherwise default → cash

8. **Notes**
   - Include any extra details that describe purpose, person, or situation (e.g., “for mother”, “office lunch”, “friend paid”).

9. **Output**
   - Always return a JSON array, even for one transaction.
   - No explanations, no comments, no markdown — only JSON.
10. **Ttle**
  - Must Needed
  - lowerCase
  - if the word is two or more then joind with _ (example: ads_revenue)
  - Always choose the closest valid title from the known category lists.


### EXAMPLES:

**Example 1 (Banglish):**
Input: “Ajke lunch e 200tk diyechi bkash e.”
Output:
[
  {
    "title": "Lunch",
    "type": "expense",
    "amount": 200,
    "categoryName": "food_dining",
    "date": "2025-11-02",
    "notes": "Ajke lunch e diyechi",
    "paymentMethod": "bkash"
  }
]

**Example 2 (Bangla):**
Input: “আমি আজ ১০০ টাকা বাসে খরচ করেছি নগদে।”
Output:
[
  {
    "title": "Bus Fare",
    "type": "expense",
    "amount": 100,
    "categoryName": "transportation",
    "date": "2025-11-02",
    "notes": "বাসে খরচ করেছি",
    "paymentMethod": "nagad"
  }
]

**Example 3 (English, Multiple):**
Input: “Got 10000 salary today, spent 300 for lunch and 100 for bus.”
Output:
[
  {
    "title": "Salary",
    "type": "income",
    "amount": 10000,
    "categoryName": "primary_income",
    "date": "2025-11-02",
    "notes": "Received salary",
    "paymentMethod": "bankTransfer"
  },
  {
    "title": "Lunch",
    "type": "expense",
    "amount": 300,
    "categoryName": "food_dining",
    "date": "2025-11-02",
    "notes": "",
    "paymentMethod": "cash"
  },
  {
    "title": "Bus Fare",
    "type": "expense",
    "amount": 100,
    "categoryName": "transportation",
    "date": "2025-11-02",
    "notes": "",
    "paymentMethod": "cash"
  }
]
''';

    // Show loader for the whole processing duration and ensure it is
    // always cleared, even on errors.
    _isLoading = true;
    notifyListeners();

    try {
      final apiKey = "AIzaSyDnGndb9_Cq-yvlMqbpAOjJdZjHU-R5rrA";
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content =
            data['candidates']?[0]?['content']?['parts']?[0]?['text'];

        if (content == null) throw 'No content in response';

        // Clean Markdown fences (```json ... ```)
        final cleaned = content
            .replaceAll(RegExp(r'```json', caseSensitive: false), '')
            .replaceAll('```', '')
            .trim();

        // Decode the cleaned content
        final parsed = jsonDecode(cleaned);
        print(parsed);

        // Ensure it's a list (AI might sometimes return a single object)
        final List<dynamic> transactions = parsed is List ? parsed : [parsed];

        // Convert each transaction into TransactionModel
        _parsedDataEx = transactions.map<TransactionModel>((item) {
          final categoryName =
              item['categoryName']?.toString().trim() ?? 'miscellaneous';
          final isIncome = item['type']?.toString().toLowerCase() == 'income';

          final categories = isIncome ? incomeCategories : expenseCategories;

          // Enhanced category matching helper
          CategoryData findBestCategory(
            String rawName,
            List<CategoryData> cats,
          ) {
            final q = rawName.trim().toLowerCase();
            if (q.isEmpty) return cats.first;

            // 1) Exact key match (categoryData.key)
            for (final c in cats) {
              //Find the Category
              if (c.groupKey.toLowerCase() == q) {
                if (item['title'] == c.key) return c;
              }
            }

            // 1)Not Exact key match (categoryData.key)
            for (final c in cats) {
              //Find the Category
              if (c.groupKey.toLowerCase() == q) {
                if (item['title'] != c.key) {
                  return CategoryData(
                    'others',
                    Icons.category,
                    Color(0xFF636E72),
                    'miscellaneous',
                  );
                }
              }
            }

            return CategoryData(
              'others',
              Icons.category,
              Color(0xFF636E72),
              'miscellaneous',
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
            categoryName: matchedCategory.groupKey,
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

        _showPreview = true;
        notifyListeners();
      } else {
        _speechErrorMessage = 'AI request failed (${response.statusCode})';
        notifyListeners();
      }
    } catch (e) {
      _speechErrorMessage = 'Error: $e';
      notifyListeners();
    } finally {
      // Always hide loader when work is done.
      _isLoading = false;
      notifyListeners();
    }
  }

  void editTransaction() {
    _showPreview = false;
    notifyListeners();
  }

  void deleteTransaction() {
    HapticFeedback.lightImpact();
    textController.clear();
    _showPreview = false;
    _parsedData = null;
    notifyListeners();
  }

  void clearInput() {
    textController.clear();
    notifyListeners();
  }

  void saveTransaction(BuildContext context) {
    HapticFeedback.mediumImpact();
    _isLoading = true;
    notifyListeners();
    for (var tx in _parsedDataEx) {
      context.read<AddExpenseProvider>().addExpense(tx);
    }
    _isLoading = false;
    notifyListeners();
    Navigator.pop(context, _parsedData?.toMap());
  }
}
