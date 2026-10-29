import 'package:finance_manager_app/services/parser/bangla_number.dart';

/// What we could read from a receipt. Every field may be missing; the user
/// checks and fixes them before anything is saved.
class ParsedReceipt {
  final String? merchant;
  final DateTime? date;
  final int? total;
  final String categoryKey;
  final String rawText;

  /// True when the read looks unreliable (no total, very little text, Bangla
  /// the on-device OCR can't read…). The screen then asks for a careful check.
  final bool weak;

  const ParsedReceipt({
    this.merchant,
    this.date,
    this.total,
    required this.categoryKey,
    required this.rawText,
    required this.weak,
  });
}

const _fallbackCategory = 'miscellaneous_expense';

/// Turns OCR text of a Bangladeshi shop receipt (printed POS slip, cash memo
/// or hand-written hisab) into store name, date and total. Offline and
/// keyword based.
class ReceiptParser {
  // Most specific first: "grand total" beats "total".
  static const _totalKeywords = [
    'grand total',
    'net payable',
    'total payable',
    'amount payable',
    'payable amount',
    'net amount',
    'net total',
    'total amount',
    'bill amount',
    'amount due',
    'সর্বমোট',
    'সর্ব মোট',
    'মোট টাকা',
    'নিট',
    'total',
    'payable',
    'মোট',
    'টোটাল',
  ];

  static final _notTotal = RegExp(
    r'sub\s*-?\s*total|total\s*(?:qty|quantity|items?|vat|tax|discount|saving|weight)|'
    r'\b(?:qty|items?|change|tendered|saved|savings|points?)\b',
    caseSensitive: false,
  );

  // 1,250.00 · 1,00,000 · 450 · 99.5 — never touching other digits.
  static final _numberRe = RegExp(
    r'(?<!\d)(\d{1,3}(?:,\d{2,3})+(?:\.\d{1,2})?|\d+(?:\.\d{1,2})?)(?![\d])',
  );
  static final _currencyRe = RegExp(
    r'(?:tk\.?|bdt|৳|টাকা|taka)',
    caseSensitive: false,
  );
  static final _phoneRe = RegExp(r'(?:\+?88)?0?1[3-9]\d{2}[-\s]?\d{6}');
  static final _timeRe = RegExp(
    r'\b\d{1,2}:\d{2}(?::\d{2})?\s*(?:am|pm)?',
    caseSensitive: false,
  );

  static final _numericDate = RegExp(
    r'(?<!\d)(\d{1,4})[/.\-](\d{1,2})[/.\-](\d{2,4})(?!\d)',
  );
  static final _textDate = RegExp(
    r'(?<!\d)(\d{1,2})(?:st|nd|rd|th)?[\s\-/.,]*'
    r'(jan|feb|mar|apr|may|jun|jul|aug|sep|sept|oct|nov|dec)[a-z]*[\s\-/.,]*(\d{2,4})',
    caseSensitive: false,
  );
  static final _textDateUs = RegExp(
    r'(jan|feb|mar|apr|may|jun|jul|aug|sep|sept|oct|nov|dec)[a-z]*[\s\-/.]*'
    r'(\d{1,2})(?:st|nd|rd|th)?[\s,\-/.]+(\d{2,4})',
    caseSensitive: false,
  );
  static const _months = {
    'jan': 1,
    'feb': 2,
    'mar': 3,
    'apr': 4,
    'may': 5,
    'jun': 6,
    'jul': 7,
    'aug': 8,
    'sep': 9,
    'sept': 9,
    'oct': 10,
    'nov': 11,
    'dec': 12,
  };

  static final _merchantSkip = RegExp(
    r'receipt|invoice|cash\s*memo|bill\s*no|memo\s*no|serial|vat\s*reg|\bbin\b|'
    r'mushak|tax|date|time|phone|tel\b|mobile|cell|hotline|address|'
    r'www\.|http|@|\.com|thank|customer|cashier|'
    r'counter|order|table|token|ক্যাশ\s*মেমো|রশিদ|রসিদ|তারিখ|মোবাইল|ফোন|ঠিকানা',
    caseSensitive: false,
  );
  // Address words only rule a line out next to a number ("House 12, Road 5"),
  // so "Coffee House" still counts as a name.
  static final _addressLine = RegExp(
    r'(?:road|house|sector|block|floor|lane|avenue|holding|বাড়ি|রোড|সেক্টর).*\d|'
    r'\d.*(?:road|house|sector|block|floor|lane|avenue|বাড়ি|রোড|সেক্টর)',
    caseSensitive: false,
  );
  static final _letters = RegExp(r'[A-Za-zঀ-৿]');
  static final _bangla = RegExp(r'[ঀ-৿]');

  /// Chains whose name OCR often breaks, matched loosely.
  static const _knownStores = {
    'shwapno': 'Shwapno',
    'swapno': 'Shwapno',
    'স্বপ্ন': 'স্বপ্ন',
    'agora': 'Agora',
    'meena bazar': 'Meena Bazar',
    'unimart': 'Unimart',
    'prince bazar': 'Prince Bazar',
    'lazz pharma': 'Lazz Pharma',
    'aarong': 'Aarong',
    'bata': 'Bata',
    'apex': 'Apex',
    'kfc': 'KFC',
    'pizza hut': 'Pizza Hut',
    'star kabab': 'Star Kabab',
    'sultan\'s dine': "Sultan's Dine",
    'chillox': 'Chillox',
    'star cineplex': 'Star Cineplex',
    'daraz': 'Daraz',
    'foodpanda': 'foodpanda',
    'pathao': 'Pathao',
    'uber': 'Uber',
  };

  /// Category hints. Latin words match whole words, Bangla as substrings.
  static const Map<String, List<String>> categoryKeywords = {
    'groceries': [
      'shwapno',
      'swapno',
      'agora',
      'meena bazar',
      'unimart',
      'prince bazar',
      'super shop',
      'supershop',
      'superstore',
      'grocery',
      'grocer',
      'mart',
      'rice',
      'dal',
      'lentil',
      'soybean oil',
      'onion',
      'potato',
      'egg',
      'atta',
      'sugar',
      'salt',
      'milk',
      'fish',
      'chicken',
      'beef',
      'মুদি',
      'চাল',
      'ডাল',
      'তেল',
      'পেঁয়াজ',
      'আলু',
      'ডিম',
      'আটা',
      'চিনি',
      'লবণ',
      'দুধ',
      'মাছ',
      'মুরগি',
      'গরুর মাংস',
      'সবজি',
      'বাজার',
      'স্বপ্ন',
    ],
    'food_dining': [
      'restaurant',
      'restora',
      'cafe',
      'café',
      'coffee',
      'kfc',
      'pizza',
      'burger',
      'biryani',
      'kacchi',
      'kabab',
      'chillox',
      'sultan',
      'dine',
      'bakery',
      'sweets',
      'mishti',
      'foodpanda',
      'waiter',
      'table no',
      'fried rice',
      'naan',
      'tea',
      'snacks',
      'set menu',
      'রেস্টুরেন্ট',
      'রেস্তোরাঁ',
      'হোটেল',
      'বিরিয়ানি',
      'কাচ্চি',
      'মিষ্টি',
      'চা',
      'নাস্তা',
      'ভাত',
      'খাবার',
    ],
    'health_fitness': [
      'pharmacy',
      'pharma',
      'medicine',
      'medical',
      'hospital',
      'clinic',
      'diagnostic',
      'lab',
      'tab',
      'tablet',
      'capsule',
      'cap',
      'syrup',
      'napa',
      'gym',
      'fitness',
      'doctor',
      'ঔষধ',
      'ওষুধ',
      'ফার্মেসি',
      'ফার্মেসী',
      'হাসপাতাল',
      'ডায়াগনস্টিক',
      'ক্লিনিক',
      'ডাক্তার',
    ],
    'fuel_mileage': [
      'filling station',
      'petrol',
      'octane',
      'diesel',
      'fuel',
      'cng station',
      'lubricant',
      'পেট্রোল',
      'অকটেন',
      'ডিজেল',
      'ফিলিং স্টেশন',
      'জ্বালানি',
    ],
    'transportation': [
      'uber',
      'pathao',
      'obhai',
      'parking',
      'toll',
      'metro rail',
      'bus',
      'ভাড়া',
      'রিকশা',
      'পার্কিং',
      'টোল',
    ],
    'travel_accommodation': [
      'resort',
      'air ticket',
      'airlines',
      'biman',
      'us-bangla',
      'novoair',
      'boarding',
      'flight',
      'রিসোর্ট',
      'বিমান',
    ],
    'bills_utilities': [
      'desco',
      'dpdc',
      'nesco',
      'electricity',
      'wasa',
      'titas',
      'gas bill',
      'internet',
      'broadband',
      'recharge',
      'বিদ্যুৎ',
      'গ্যাস',
      'পানির বিল',
      'ইন্টারনেট',
    ],
    'shopping': [
      'aarong',
      'yellow',
      'ecstasy',
      'bata',
      'apex',
      'lotto',
      'fashion',
      'garments',
      'clothing',
      'shoe',
      'shoes',
      'shirt',
      'pant',
      'saree',
      'panjabi',
      'electronics',
      'star tech',
      'ryans',
      'daraz',
      'mobile shop',
      'কাপড়',
      'জুতা',
      'শাড়ি',
      'পাঞ্জাবি',
      'জামা',
      'শার্ট',
    ],
    'education': [
      'library',
      'book',
      'books',
      'stationery',
      'school',
      'college',
      'university',
      'tuition',
      'coaching',
      'বই',
      'খাতা',
      'কলম',
      'স্কুল',
      'কোচিং',
      'লাইব্রেরি',
    ],
    'beauty': [
      'salon',
      'parlour',
      'parlor',
      'beauty',
      'cosmetics',
      'spa',
      'পার্লার',
      'সেলুন',
      'প্রসাধনী',
    ],
    'entertainment': ['cinema', 'cineplex', 'movie', 'blockbuster', 'সিনেমা'],
    'repairs': ['repair', 'servicing', 'workshop', 'মেরামত', 'সার্ভিসিং'],
    'office_supplies_equipment': ['printing', 'photocopy', 'toner', 'ফটোকপি'],
    'kids': ['toy', 'toys', 'baby', 'diaper', 'খেলনা'],
    'pets': ['pet', 'vet', 'cat food', 'dog food'],
  };

  static ParsedReceipt parse(String text, {DateTime? now}) {
    final clean = toAsciiDigits(text).replaceAll('\r', '');
    final lines = clean
        .split('\n')
        .map((l) => l.replaceAll(RegExp(r'[ \t]+'), ' ').trim())
        .where((l) => l.isNotEmpty)
        .toList();

    final merchant = findMerchant(lines);
    final date = findDate(clean, now: now ?? DateTime.now());
    final (total, sure) = findTotal(lines);
    final category = suggestCategory(clean, merchant: merchant);

    final letterCount = _letters.allMatches(clean).length;
    final weak =
        total == null ||
        !sure ||
        lines.length < 3 ||
        letterCount < 12 ||
        _bangla.hasMatch(clean);

    return ParsedReceipt(
      merchant: merchant,
      date: date,
      total: total,
      categoryKey: category,
      rawText: text.trim(),
      weak: weak,
    );
  }

  /// Store name: a known chain anywhere near the top, otherwise the first
  /// wordy line of the header that isn't an address, phone or title.
  static String? findMerchant(List<String> lines) {
    final head = lines.take(6).toList();
    for (final line in head) {
      final lower = line.toLowerCase();
      for (final e in _knownStores.entries) {
        if (lower.contains(e.key)) return e.value;
      }
    }
    for (final line in head) {
      if (_merchantSkip.hasMatch(line) || _addressLine.hasMatch(line)) continue;
      final letters = _letters.allMatches(line).length;
      final digits = RegExp(r'\d').allMatches(line).length;
      if (letters < 3 || digits > letters) continue;
      var name = line
          .replaceFirst(
            RegExp(r'^(?:welcome\s+to|স্বাগতম)\s*', caseSensitive: false),
            '',
          )
          .replaceAll(RegExp(r'^[^A-Za-zঀ-৿]+|[^A-Za-zঀ-৿).]+$'), '')
          .trim();
      if (name.length < 3) continue;
      if (name.length > 40) name = name.substring(0, 40).trim();
      return name;
    }
    return null;
  }

  /// The total and whether it came from a "total" label (sure) or was a guess.
  static (int?, bool) findTotal(List<String> lines) {
    int? best;
    var bestRank = _totalKeywords.length;

    for (var i = 0; i < lines.length; i++) {
      final lower = lines[i].toLowerCase();
      final rank = _totalKeywords.indexWhere(lower.contains);
      if (rank < 0 ||
          _notTotal.hasMatch(lower) &&
              rank >= _totalKeywords.indexOf('total')) {
        continue;
      }
      // Amount on the same line, else the line below (two-column layouts).
      var amount = _lastAmount(lines[i]);
      if (amount == null && i + 1 < lines.length) {
        amount = _lastAmount(lines[i + 1]);
      }
      if (amount == null || amount <= 0) continue;
      // Same label again further down (e.g. a repeated "Total"): keep the later one.
      if (rank <= bestRank) {
        bestRank = rank;
        best = amount;
      }
    }
    if (best != null) return (best, true);

    // No label: the largest amount next to a currency sign, else the largest
    // amount at all (hand-written memos often have none of these).
    int? guess;
    for (final line in lines) {
      if (!_currencyRe.hasMatch(line)) continue;
      final a = _lastAmount(line);
      if (a != null && (guess == null || a > guess)) guess = a;
    }
    if (guess == null) {
      for (final line in lines) {
        final a = _lastAmount(line);
        if (a != null && (guess == null || a > guess)) guess = a;
      }
    }
    // A lone "1" or "5" is more likely OCR noise than a total.
    if (guess != null && guess < 10) guess = null;
    return (guess, false);
  }

  static int? _lastAmount(String line) {
    var s = line
        .replaceAll(_phoneRe, ' ')
        .replaceAll(_numericDate, ' ')
        .replaceAll(_textDate, ' ')
        .replaceAll(_timeRe, ' ');
    // Quantity markers like "2 x 120" or "5 kg": the price is what follows.
    s = s.replaceAll(
      RegExp(
        r'\b\d+(?:\.\d+)?\s*(?:x|pcs?|kg|g|gm|ltr?|ml|কেজি|পিস|লিটার|টি)(?![A-Za-z\u0980-\u09FF])',
        caseSensitive: false,
      ),
      ' ',
    );
    final matches = _numberRe.allMatches(s).toList();
    if (matches.isEmpty) return null;
    final value = double.tryParse(matches.last.group(1)!.replaceAll(',', ''));
    if (value == null || value <= 0 || value >= 10000000) return null;
    return value.round();
  }

  static DateTime? findDate(String text, {required DateTime now}) {
    for (final m in _numericDate.allMatches(text)) {
      final a = int.parse(m.group(1)!);
      final b = int.parse(m.group(2)!);
      final c = int.parse(m.group(3)!);
      final DateTime? d;
      if (m.group(1)!.length == 4) {
        d = _make(a, b, c); // 2026-10-29
      } else if (b > 12 && a <= 12) {
        d = _make(_year(c), a, b); // US style 10/29/2026
      } else {
        d = _make(_year(c), b, a); // Bangladesh: day first
      }
      if (d != null && _plausibleDate(d, now)) return _withTime(d, text, m.end);
    }
    for (final m in _textDate.allMatches(text)) {
      final d = _make(
        _year(int.parse(m.group(3)!)),
        _months[m.group(2)!.toLowerCase()]!,
        int.parse(m.group(1)!),
      );
      if (d != null && _plausibleDate(d, now)) return _withTime(d, text, m.end);
    }
    for (final m in _textDateUs.allMatches(text)) {
      final d = _make(
        _year(int.parse(m.group(3)!)),
        _months[m.group(1)!.toLowerCase()]!,
        int.parse(m.group(2)!),
      );
      if (d != null && _plausibleDate(d, now)) return _withTime(d, text, m.end);
    }
    return null;
  }

  static int _year(int y) => y < 100 ? 2000 + y : y;

  static DateTime? _make(int year, int month, int day) {
    if (month < 1 || month > 12 || day < 1 || day > 31) return null;
    final d = DateTime(year, month, day);
    // DateTime rolls 31/02 over to March; reject it instead.
    return d.month == month ? d : null;
  }

  static bool _plausibleDate(DateTime d, DateTime now) =>
      !d.isAfter(now.add(const Duration(days: 1))) &&
      d.isAfter(DateTime(now.year - 3, now.month, now.day));

  /// Adds a time printed right after the date ("29/10/2026 07:45 PM").
  static DateTime _withTime(DateTime d, String text, int from) {
    final rest = text.substring(from, (from + 20).clamp(0, text.length));
    final m = RegExp(
      r'^[\s,]*(\d{1,2}):(\d{2})(?::\d{2})?\s*(am|pm)?',
      caseSensitive: false,
    ).firstMatch(rest);
    if (m == null) return DateTime(d.year, d.month, d.day, 12);
    var hour = int.parse(m.group(1)!);
    final minute = int.parse(m.group(2)!);
    final ampm = m.group(3)?.toLowerCase();
    if (ampm == 'pm' && hour < 12) hour += 12;
    if (ampm == 'am' && hour == 12) hour = 0;
    if (hour > 23 || minute > 59) return DateTime(d.year, d.month, d.day, 12);
    return DateTime(d.year, d.month, d.day, hour, minute);
  }

  /// Picks the category with the most keyword hits; the store name counts
  /// three times.
  static String suggestCategory(String text, {String? merchant}) {
    final body = text.toLowerCase();
    final name = merchant?.toLowerCase() ?? '';
    var bestKey = _fallbackCategory;
    var bestScore = 0;
    categoryKeywords.forEach((key, words) {
      var score = 0;
      for (final w in words) {
        if (_has(name, w)) score += 3;
        if (_has(body, w)) score += 1;
      }
      if (score > bestScore) {
        bestScore = score;
        bestKey = key;
      }
    });
    return bestKey;
  }

  static final _wordCache = <String, RegExp>{};

  static bool _has(String haystack, String word) {
    if (haystack.isEmpty) return false;
    if (_bangla.hasMatch(word)) return haystack.contains(word);
    final re = _wordCache.putIfAbsent(
      word,
      () => RegExp('(?<![a-z])${RegExp.escape(word)}(?![a-z])'),
    );
    return re.hasMatch(haystack);
  }
}

/// A saved receipt or transaction that looks like the one being added.
class DuplicateMatch {
  /// Same photo as a saved receipt (not just similar).
  final bool samePhoto;
  final int? transactionId;
  final String title;
  final int amount;
  final DateTime date;

  const DuplicateMatch({
    required this.samePhoto,
    required this.transactionId,
    required this.title,
    required this.amount,
    required this.date,
  });
}

/// Something already saved to compare against.
class DuplicateCandidate {
  final int? transactionId;
  final String? imageHash;
  final String title;
  final int amount;
  final DateTime date;

  const DuplicateCandidate({
    this.transactionId,
    this.imageHash,
    required this.title,
    required this.amount,
    required this.date,
  });
}

class ReceiptDuplicateChecker {
  /// Same photo first; otherwise the same amount on the same day, preferring
  /// one with a similar name.
  static DuplicateMatch? find({
    required String? imageHash,
    required int? amount,
    required DateTime? date,
    required String? merchant,
    required List<DuplicateCandidate> existing,
  }) {
    if (imageHash != null) {
      for (final c in existing) {
        if (c.imageHash == imageHash) return _match(c, samePhoto: true);
      }
    }
    if (amount == null || date == null) return null;
    final sameDay = existing.where(
      (c) =>
          c.amount == amount &&
          c.date.year == date.year &&
          c.date.month == date.month &&
          c.date.day == date.day,
    );
    if (sameDay.isEmpty) return null;
    final similar = sameDay.where((c) => similarNames(c.title, merchant));
    return _match(similar.isNotEmpty ? similar.first : sameDay.first);
  }

  static DuplicateMatch _match(
    DuplicateCandidate c, {
    bool samePhoto = false,
  }) => DuplicateMatch(
    samePhoto: samePhoto,
    transactionId: c.transactionId,
    title: c.title,
    amount: c.amount,
    date: c.date,
  );

  static bool similarNames(String a, String? b) {
    if (b == null) return false;
    Set<String> words(String s) => s
        .toLowerCase()
        .split(RegExp(r'[^a-z0-9ঀ-৿]+'))
        .where((w) => w.length > 1)
        .toSet();
    final wa = words(a), wb = words(b);
    if (wa.isEmpty || wb.isEmpty) return false;
    final common = wa.intersection(wb).length;
    return common / (wa.length < wb.length ? wa.length : wb.length) >= 0.5;
  }
}
