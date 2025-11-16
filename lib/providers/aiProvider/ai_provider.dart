import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/data/category/category_item_data.dart';
import 'package:finance_manager_app/data/category/income_item_data.dart';
import 'package:finance_manager_app/models/categoryModel/category_item_model.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

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
          _speechErrorMessage = '${"speech_error".tr}: ${parts.join(' — ')}';
          _speechEnabled = false;
          _isRecording = false;
          notifyListeners();
        },
      );

      if (!_speechEnabled) {
        _speechErrorMessage ??=
            'speech_not_available'.tr;
      }
    } on PlatformException catch (e) {
      _speechEnabled = false;
      _speechErrorMessage = '${e.message}';
    } catch (e) {
      _speechEnabled = false;
      _speechErrorMessage = '${"speech_init_failed".tr}: ${e.toString()}';
    }
    notifyListeners();
  }

  void toggleRecording() {
    setSpeechError();
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
    "categoryName": string,         // must match one of the updated category keys below
    "date": string,                 // ISO8601 format: YYYY-MM-DD
    "notes": string,                // short optional context
    "paymentMethod": string         // one of: cash, bankTransfer, creditCard, debitCard, mobileWallet, check, bkash, nagad, rocket, upay
  }
]

---

### 🔹 Updated Category Mapping
Use these category keys exactly:

| Category Key | Keywords (Bangla + English + Banglish) |
|---------------|----------------------------------------|
| **health_fitness** | doctor, medicine, hospital, gym, yoga, ফার্মেসি, ডাক্তার, ব্যায়াম |
| **food_dining** | lunch, dinner, খাবার, restaurant, pizza, snacks, coffee, tea, juice, ভাত, রেস্টুরেন্ট |
| **bills_utilities** | electricity, gas, internet, water bill, mobile bill,recharge,topup,call,রিচার্জ বিদ্যুৎ, বিল, ওয়াইফাই, ফোন বিল |
| **beauty** | salon, parlor, spa, beauty, haircut, makeup, skin care, পার্লার |
| **housing** | rent, apartment, flat, house, utility, repair, ভাড়া, বাসা, বাড়ি |
| **transportation** | bus, cng, uber, rickshaw, taxi, car rent, গাড়ি ভাড়া, পরিবহন |
| **entertainment** | movie, concert, netflix, youtube, game, সিনেমা, গান, শো |
| **shopping** | clothes, dress, shoes, fashion, market, shop, dress, কেনাকাটা |
| **groceries** | grocery, bazar, vegetables, fruits, rice, fish, মুদিখানা, বাজার |
| **education** | tuition, course, exam, book, school, college, পড়াশোনা |
| **personal** | family, friend, gift, home, relative, personal, নিজের জন্য |
| **investment** | investment, savings, deposit, fund, mutual fund, crypto, বিনিয়োগ |
| **marketing_advertising** | marketing, ads, advertising, promotion, প্রচার |
| **travel_accommodation** | travel, trip, hotel, ticket, flight, tour, ভ্রমণ, যাত্রা |
| **office_supplies_equipment** | office, equipment, stationery, printer, laptop, desk |
| **insurance** | insurance, premium, policy, বীমা |
| **subscription_services** | subscription, netflix, spotify, membership, সাবস্ক্রিপশন |
| **fuel_mileage** | fuel, petrol, diesel, gas, refill, car fuel, তেল |
| **charity_donations** | donation, zakat, charity, gift money, অনুদান, দান |
| **kids** | child, kids, baby, toy, স্কুলের খরচ, বাচ্চা |
| **repairs** | repair, maintenance, fixing, service, মেরামত |
| **pets** | pet, dog, cat, food, পশু |
| **sports** | cricket, football, training, খেলা |
| **salary** | salary, pay, income, payment, job, মাসিক বেতন |
| **business** | business, sale, trade, purchase, deal, ব্যবসা |
| **sales_revenue** | sold, sale, sales income, বিক্রি |
| **service_income** | service, project, task, consulting, সেবা |
| **freelance_contracts** | freelance, contract, remote work, ফ্রিল্যান্স |
| **investment_returns** | profit, return, dividend, লাভ, শেয়ার আয় |
| **rental_income** | rent income, property, tenant, lease |
| **asset_sales** | asset sold, equipment sale, property sale |
| **royalties_licensing** | royalties, license, copyright, ads revenue |
| **interest_dividends** | bank interest, dividend, interest, সুদ |
| **side_income** | side job, part-time, commission, tutoring, extra income |
| **commissions_affiliates** | commission, affiliate, referral, bonus income |
| **refunds_reimbursements** | refund, reimbursement, cashback, ফেরত টাকা |
| **gifts** | gift, received gift, উপহার |
| **grants_subsidies** | grant, scholarship, government aid, ভর্তুকি |
| **miscellaneous** | anything else unmatched |

---

### 🔹 Detection Rules

#### 1. Language & Context
- Handle mixed Bangla, English, Banglish.
- Keep JSON keys in English.

#### 2. Multiple Transactions
- If multiple payments mentioned (e.g. “Lunch 200 and bus 50”), return multiple JSON objects.

#### 3. Date Handling
- Understand expressions like:
  - “আজ”, “today” → today
  - “গতকাল”, “yesterday” → yesterday
  - “৩ দিন আগে”, “3 days ago” → N days ago
  - “১৫ই অক্টোবর”, “October 15” → exact date
- Default to today’s date → `${DateTime.now().toIso8601String().split('T').first}`

#### 4. Type Detection
- Expense words: spent, paid, bought, খরচ, দিলাম, send, bill, cash out, donated
- Income words: received, got, earned, salary, income, payment, bonus, পেলাম, আয়
- Default: expense

#### 5. Amount Extraction
- Extract numeric part only
- Remove symbols: “৳”, “tk”, “taka”, “BDT”
- Convert Bangla numerals (e.g. “৫০০” → 500)

#### 6. Category Detection
- Match using the keywords above
- Choose closest valid category key

#### 7. Payment Method Detection
| Keyword | Output |
|----------|---------|
| bkash, বিকাশ | bkash |
| nagad, নগদ | nagad |
| rocket, রকেট | rocket |
| upay, উপায় | upay |
| bank, transfer, cheque | bankTransfer |
| credit card, credit | creditCard |
| debit card, debit | debitCard |
| wallet, mobile wallet | mobileWallet |
| otherwise | cash |

#### 8. Notes
- Include short purpose or person if present.

#### 9. Title
- Lowercase
- Join multi-word titles with underscore, e.g. “bus fare” → `"bus_fare"`
- Must be relevant to the category.

#### 10. Output
- Always return a **valid JSON array**
- No extra text, no markdown, no comments.

---

### ✅ Example 1 (Banglish)
Input: “Ajke lunch e 200tk diyechi bkash e.”
Output:
[
  {
    "title": "lunch",
    "type": "expense",
    "amount": 200,
    "categoryName": "food_dining",
    "date": "2025-11-05",
    "notes": "Ajke lunch e diyechi",
    "paymentMethod": "bkash"
  }
]

### ✅ Example 2 (Bangla)
Input: “আমি আজ ১০০ টাকা বাসে খরচ করেছি নগদে।”
Output:
[
  {
    "title": "bus_fare",
    "type": "expense",
    "amount": 100,
    "categoryName": "transportation",
    "date": "2025-11-05",
    "notes": "বাসে খরচ করেছি",
    "paymentMethod": "nagad"
  }
]

### ✅ Example 3 (English, Multiple)
Input: “Got 10000 salary today, spent 300 for lunch and 100 for bus.”
Output:
[
  {
    "title": "salary",
    "type": "income",
    "amount": 10000,
    "categoryName": "salary",
    "date": "2025-11-05",
    "notes": "Received salary",
    "paymentMethod": "bankTransfer"
  },
  {
    "title": "lunch",
    "type": "expense",
    "amount": 300,
    "categoryName": "food_dining",
    "date": "2025-11-05",
    "notes": "",
    "paymentMethod": "cash"
  },
  {
    "title": "bus_fare",
    "type": "expense",
    "amount": 100,
    "categoryName": "transportation",
    "date": "2025-11-05",
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

        // Ensure it's a list (AI might sometimes return a single object)
        final List<dynamic> transactions = parsed is List ? parsed : [parsed];

        // Convert each transaction into TransactionModel
        _parsedDataEx = transactions.map<TransactionModel>((item) {
          final categoryName =
              item['categoryName']?.toString().trim() ?? 'miscellaneous';
          final isIncome = item['type']?.toString().toLowerCase() == 'income';

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

            return CategoryItemModel(
              'miscellaneous',
              Icons.category,
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

        _showPreview = true;
        notifyListeners();
      } else {
        _speechErrorMessage = 'AI request failed (${response.statusCode})';
        notifyListeners();
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
    } catch (e) {
      _speechErrorMessage = 'Error: $e';
      notifyListeners();
    } finally {
      // Always hide loader when work is done.

      _isLoading = false;
      notifyListeners();
    }
  }

  void setSpeechError() {
    if (_speechErrorMessage != null && !Get.isSnackbarOpen) {
      Get.snackbar(
        'Speech Error ⚠️',
        speechErrorMessage!,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        duration: const Duration(seconds: 3),
      );
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

  void resetPreview() {
    _showPreview = false;
    _parsedDataEx = [];
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
    textController.clear();

    _parsedData = null;
    _showPreview = false;

    // Navigator.pop(context, _parsedData?.toMap());
    // Get.to(MainView());

    notifyListeners();
  }
}
