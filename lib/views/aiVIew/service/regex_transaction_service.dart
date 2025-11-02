import 'package:finance_manager_app/config/enums/enums.dart';
import '../../../models/categoryModel/category_data_model.dart';
import '../../../models/categoryModel/transaction_model.dart';

class RegexTransactionParser {
  final List<CategoryData> expenseCategories;
  final List<CategoryData> incomeCategories;

  RegexTransactionParser({
    required this.expenseCategories,
    required this.incomeCategories,
  });

  /// Parse full text -> multiple transactions
  List<TransactionModel> parseText(String text) {
    final List<TransactionModel> transactions = [];

    // Split by comma, "and", or "এবং"
    final parts = text.split(RegExp(r'[,.]| এবং | and ')).map((e) => e.trim()).toList();

    for (final part in parts) {
      if (part.isEmpty) continue;

      final match = _parseSingleTransaction(part);
      if (match != null) transactions.add(match);
    }

    return transactions;
  }

  /// Parse single sentence into transaction
  TransactionModel? _parseSingleTransaction(String input) {
    String normalized = _normalizeBanglaNumbers(input.toLowerCase());

    // === Detect Date ===
    final detectedDate = _detectDate(normalized);

    // === Detect Amount ===
    final amountRegex = RegExp(r'(\d{1,6})\s*(taka|tk|৳)?');
    final amountMatch = amountRegex.firstMatch(normalized);
    final amount = amountMatch != null ? int.tryParse(amountMatch.group(1) ?? '') ?? 0 : 0;
    if (amount == 0) return null;

    // === Detect Type ===
    final expenseWords = ['spent', 'buy', 'bought', 'paid', 'purchase', 'খরচ', 'কিনলাম', 'দিলাম'];
    final incomeWords = ['earned', 'got', 'received', 'income', 'salary', 'পেলাম', 'আয়', 'জিতলাম'];

    final isExpense = expenseWords.any((w) => normalized.contains(w));
    final isIncome = incomeWords.any((w) => normalized.contains(w));

    final type = isIncome ? TransactionType.income : TransactionType.expense;

    // === Detect Category ===
    final matchedCategory = _detectCategory(normalized, type);

    // === Title ===
    final title = _extractTitle(normalized, matchedCategory.name, amount);

    return TransactionModel(
      type: type,
      date: detectedDate,
      title: title,
      categoryName: matchedCategory.name,
      amount: amount,
      notes: input,
      paymentMethod: "Cash",
      icon: matchedCategory.icon,
      iconBgColor: matchedCategory.color.value,
      categoryKey: matchedCategory.key,
    );
  }

  /// Detect category by matching with keywords
  CategoryData _detectCategory(String text, TransactionType type) {
    final categories = type == TransactionType.expense ? expenseCategories : incomeCategories;

    for (final cat in categories) {
      if (text.contains(cat.name.toLowerCase()) ||
          text.contains(cat.key.toLowerCase())) {
        return cat;
      }
    }

    // Fallback to "Other"
    return categories.firstWhere(
          (cat) => cat.key == "other",
      orElse: () => categories.last,
    );
  }

  /// Detect date phrases (Bangla + English)
  DateTime _detectDate(String text) {
    final now = DateTime.now();
    final lower = text.toLowerCase();

    // Bangla / English relative terms
    if (lower.contains("আজ") || lower.contains("today")) return now;
    if (lower.contains("গতকাল") || lower.contains("yesterday")) return now.subtract(const Duration(days: 1));
    if (lower.contains("পরশু") || lower.contains("day before yesterday")) return now.subtract(const Duration(days: 2));

    // Date formats (15/10/2025 or 15-10-2025)
    final numericDateRegex = RegExp(r'(\d{1,2})[/-](\d{1,2})([/-](\d{2,4}))?');
    final numericMatch = numericDateRegex.firstMatch(lower);
    if (numericMatch != null) {
      final day = int.tryParse(numericMatch.group(1) ?? '') ?? now.day;
      final month = int.tryParse(numericMatch.group(2) ?? '') ?? now.month;
      final year = int.tryParse(numericMatch.group(3)?.replaceAll(RegExp(r'[/-]'), '') ?? '') ?? now.year;
      return DateTime(year, month, day);
    }

    // English month format (on 15 october)
    final monthNames = {
      'january': 1, 'february': 2, 'march': 3, 'april': 4, 'may': 5, 'june': 6,
      'july': 7, 'august': 8, 'september': 9, 'october': 10, 'november': 11, 'december': 12
    };

    for (final month in monthNames.keys) {
      final reg = RegExp(r'(\d{1,2})\s*' + month);
      final match = reg.firstMatch(lower);
      if (match != null) {
        final day = int.tryParse(match.group(1) ?? '') ?? now.day;
        return DateTime(now.year, monthNames[month]!, day);
      }
    }

    // If nothing found
    return now;
  }

  /// Replace Bangla digits with English
  String _normalizeBanglaNumbers(String text) {
    const banglaDigits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    for (int i = 0; i < banglaDigits.length; i++) {
      text = text.replaceAll(banglaDigits[i], i.toString());
    }
    return text;
  }

  /// Generate readable title
  String _extractTitle(String text, String category, int amount) {
    return text.contains(category.toLowerCase())
        ? "Transaction for $category"
        : "Transaction of $amount Tk";
  }
}
