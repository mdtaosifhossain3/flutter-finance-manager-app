import 'bangla_number.dart';
import 'parser_dictionary.dart';

/// One transaction read from the user's note.
class ParsedTransaction {
  final String title;
  final bool isIncome;
  final int amount;
  final String categoryKey;

  /// Date only (midnight); the caller adds the time of day.
  final DateTime date;
  final String paymentMethod;

  /// Descriptive words from the note, remembered when the user corrects the
  /// category so the next note with these words gets it right.
  final List<String> words;

  const ParsedTransaction({
    required this.title,
    required this.isIncome,
    required this.amount,
    required this.categoryKey,
    required this.date,
    required this.paymentMethod,
    required this.words,
  });

  @override
  String toString() =>
      '$title ${isIncome ? 'income' : 'expense'} $amount $categoryKey '
      '${date.toIso8601String().split('T').first} $paymentMethod';
}

/// Reads money notes written in Bangla, English or Banglish, offline and
/// without AI. See `parser_dictionary.dart` for the words it knows.
///
/// "গতকাল বিকাশে ১২০০ টাকা বাজার আর রিকশা ভাড়া ৫০" becomes two expenses dated
/// yesterday: Groceries 1200 (bkash) and Rickshaw Fare 50 (cash).
class TransactionParser {
  /// Words the user taught by correcting a category: word -> category key.
  final Map<String, String> learned;

  TransactionParser({Map<String, String> learned = const {}})
    : learned = {
        for (final e in learned.entries) normalizeText(e.key).trim(): e.value,
      };

  List<ParsedTransaction> parse(String input, {DateTime? today}) {
    final now = today ?? DateTime.now();
    final base = DateTime(now.year, now.month, now.day);

    final tokens = normalizeText(
      input,
    ).split(RegExp(r'\s+')).where((t) => t.isNotEmpty).map(_Token.new).toList();

    for (final t in tokens) {
      if (_dict.separators.contains(t.text)) t.kind = _Kind.separator;
    }
    _markDates(tokens, base);
    _markAmounts(tokens);
    _markWords(tokens);

    return _build(tokens, base);
  }

  // ---------------------------------------------------------------------------
  // Text normalization

  static final _nukta = {
    'য়': 'য়', // য়
    'ড়': 'ড়', // ড়
    'ঢ়': 'ঢ়', // ঢ়
  };

  /// Lowercases, unifies Bangla spelling, converts digits and puts spaces
  /// around numbers and punctuation so the text splits into clean tokens.
  static String normalizeText(String input) {
    var s = toAsciiDigits(input).toLowerCase();
    _nukta.forEach((from, to) => s = s.replaceAll(from, to));
    s = s
        .replaceAll('৳', ' tk ')
        .replaceAll('/-', ' ')
        .replaceAll(RegExp(r'[\n\r]'), ' , ')
        // 1,200 / 1,20,000 / 1,200,000 are one number; 200,200 is two.
        .replaceAllMapped(
          RegExp(r'\b\d{1,2}(?:,\d{2})*,\d{3}\b|\b\d{1,3}(?:,\d{3}){2,}\b'),
          (m) => m[0]!.replaceAll(',', ''),
        )
        // wi-fi -> wifi, but keep 15-10-2026
        .replaceAllMapped(
          RegExp(r'(?<=\p{L})-(?=\p{L})', unicode: true),
          (_) => '',
        )
        .replaceAll(RegExp(r'(?<!\d)-|-(?!\d)'), ' ')
        // A dot that is not a decimal point ends a sentence.
        .replaceAll(RegExp(r'(?<!\d)\.|\.(?!\d)'), ' , ')
        .replaceAllMapped(RegExp(r'[,+;:।!?&()]'), (m) => ' ${m[0]} ')
        // 500tk -> 500 tk, tk500 -> tk 500, ৩টা -> 3 টা
        .replaceAllMapped(RegExp(r'(\d)(?=[^\d\s.,/\-])'), (m) => '${m[1]} ')
        .replaceAllMapped(RegExp(r'([^\d\s.,/\-])(?=\d)'), (m) => '${m[1]} ');
    // পাঁচশো -> পাঁচ শো
    return s
        .split(RegExp(r'\s+'))
        .map(
          (w) =>
              w.replaceAllMapped(_dict.gluedHundreds, (m) => '${m[1]} ${m[2]}'),
        )
        .join(' ');
  }

  // ---------------------------------------------------------------------------
  // Token marking

  void _markDates(List<_Token> tokens, DateTime base) {
    for (var i = 0; i < tokens.length; i++) {
      if (tokens[i].kind != _Kind.word) continue;
      final t = tokens[i].text;

      // Fixed words and phrases: today, gotokal, porshu, last week ...
      final fixed = _matchFixedDate(tokens, i, base);
      if (fixed != null) {
        _setDate(tokens, i, fixed.$2, fixed.$1);
        i += fixed.$2 - 1;
        continue;
      }

      // 2026-10-15, 15/10/2026, 15/10
      final iso = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$').firstMatch(t);
      if (iso != null) {
        final d = _validDate(
          int.parse(iso[1]!),
          int.parse(iso[2]!),
          int.parse(iso[3]!),
        );
        if (d != null) _setDate(tokens, i, 1, d);
        continue;
      }
      final dmy = RegExp(
        r'^(\d{1,2})[/-](\d{1,2})(?:[/-](\d{2}|\d{4}))?$',
      ).firstMatch(t);
      if (dmy != null) {
        var year = dmy[3] == null ? base.year : int.parse(dmy[3]!);
        if (year < 100) year += 2000;
        final d = _validDate(year, int.parse(dmy[2]!), int.parse(dmy[1]!));
        if (d != null) _setDate(tokens, i, 1, d);
        continue;
      }

      // "oct 15"
      final month = _dict.months[t];
      if (month != null && i + 1 < tokens.length) {
        final day = int.tryParse(tokens[i + 1].text);
        if (day != null && day >= 1 && day <= 31) {
          var len = 2;
          while (i + len < tokens.length &&
              _dict.ordinals.contains(tokens[i + len].text)) {
            len++;
          }
          final year = _yearAt(tokens, i + len);
          final d = _validDate(year ?? base.year, month, day);
          if (d != null) {
            _setDate(tokens, i, len + (year != null ? 1 : 0), d);
            i += len - 1;
          }
        }
        continue;
      }

      final n = int.tryParse(t) ?? _dict.numbers[t]?.toInt();
      if (n == null || i + 1 >= tokens.length) continue;

      // "3 din age", "৩ দিন আগে", "2 weeks ago"
      if (i + 2 < tokens.length && _dict.ago.contains(tokens[i + 2].text)) {
        final unit = tokens[i + 1].text;
        final days = _dict.days.contains(unit)
            ? n
            : _dict.weeks.contains(unit)
            ? n * 7
            : null;
        if (days != null) {
          _setDate(tokens, i, 3, base.subtract(Duration(days: days)));
          i += 2;
          continue;
        }
      }

      // "15 oct", "15th october 2025", "১৫ই অক্টোবর", "15 tarikh"
      if (int.tryParse(t) == null || n < 1 || n > 31) continue;
      var j = i + 1;
      var hadOrdinal = false;
      while (j < tokens.length && _dict.ordinals.contains(tokens[j].text)) {
        hadOrdinal = true;
        j++;
      }
      final m = j < tokens.length ? _dict.months[tokens[j].text] : null;
      if (m != null) {
        final year = _yearAt(tokens, j + 1);
        final d = _validDate(year ?? base.year, m, n);
        if (d != null) {
          final len = j - i + 1 + (year != null ? 1 : 0);
          _setDate(tokens, i, len, d);
          i += len - 1;
        }
      } else if (hadOrdinal) {
        final d = _validDate(base.year, base.month, n);
        if (d != null) {
          _setDate(tokens, i, j - i, d);
          i = j - 1;
        }
      }
    }
  }

  (DateTime, int)? _matchFixedDate(List<_Token> tokens, int i, DateTime base) {
    (DateTime, int)? best;
    for (final (phrases, days) in _dict.fixedDates) {
      for (final p in phrases) {
        final len = _matchPhrase(tokens, i, p, allowSuffix: true);
        if (len > (best?.$2 ?? 0)) best = (base.add(Duration(days: days)), len);
      }
    }
    return best;
  }

  int? _yearAt(List<_Token> tokens, int i) {
    if (i >= tokens.length) return null;
    final y = int.tryParse(tokens[i].text);
    return (y != null && y >= 2000 && y <= 2100) ? y : null;
  }

  DateTime? _validDate(int y, int m, int d) {
    if (m < 1 || m > 12 || d < 1) return null;
    final date = DateTime(y, m, d);
    return date.month == m ? date : null;
  }

  void _setDate(List<_Token> tokens, int start, int len, DateTime date) {
    for (var k = start; k < start + len; k++) {
      tokens[k].kind = _Kind.date;
    }
    tokens[start].date = date;
  }

  void _markAmounts(List<_Token> tokens) {
    for (var i = 0; i < tokens.length; i++) {
      final tok = tokens[i];
      if (tok.kind != _Kind.word) continue;

      final start = i;
      var half = 0.0;
      if (_dict.halfMore.contains(tok.text) && i + 1 < tokens.length) {
        half = 0.5;
        i++;
      }
      final t = tokens[i].text;
      final digits = double.tryParse(t);
      final word = _dict.numbers[t];
      if (digits == null && word == null) {
        i = start;
        continue;
      }
      // Phone numbers and ids are not amounts.
      if (digits != null && t.replaceAll('.', '').length >= 10) {
        tokens[i].kind = _Kind.skip;
        continue;
      }

      final next = i + 1 < tokens.length ? tokens[i + 1].text : null;
      if (digits != null && next != null && _dict.units.contains(next)) {
        tokens[i].kind = _Kind.quantity; // "2 kg", "৩টা"
        continue;
      }

      var value = (digits ?? word!) + half;
      var end = i;
      final mult = next == null ? null : _dict.mults[next];
      if (mult != null) {
        value *= mult;
        end = i + 1;
        // "দুই হাজার পাঁচশো", "1 hajar 200 tk"
        while (end + 1 < tokens.length) {
          final n = tokens[end + 1].text;
          final nv = double.tryParse(n) ?? _dict.numbers[n];
          if (nv == null || end + 2 >= tokens.length) break;
          final after = tokens[end + 2].text;
          final m2 = _dict.mults[after];
          if (m2 != null && m2 < mult) {
            value += nv * m2;
            end += 2;
          } else if (double.tryParse(n) != null &&
              nv < mult &&
              _dict.currency.contains(after)) {
            value += nv;
            end += 1;
          } else {
            break;
          }
        }
      } else if (digits == null || half > 0) {
        // A number word (or "sare") needs a multiplier to count as money.
        i = start;
        continue;
      }

      for (var k = start; k <= end; k++) {
        tokens[k].kind = _Kind.skip;
      }
      tokens[start]
        ..kind = _Kind.amount
        ..value = value;
      i = end;
    }
  }

  void _markWords(List<_Token> tokens) {
    for (var i = 0; i < tokens.length; i++) {
      if (tokens[i].kind != _Kind.word) continue;
      final t = tokens[i].text;

      if (_dict.currency.contains(t)) {
        tokens[i].kind = _Kind.skip;
        continue;
      }
      final pay = _matchPayment(tokens, i);
      if (pay != null) {
        for (var k = i; k < i + pay.$2; k++) {
          tokens[k].kind = _Kind.payment;
        }
        tokens[i].payment = pay.$1;
        i += pay.$2 - 1;
        continue;
      }
      if (_matchesAny(t, _dict.incomeVerbSet)) {
        tokens[i].kind = _Kind.incomeVerb;
      } else if (_matchesAny(t, _dict.expenseVerbSet)) {
        tokens[i].kind = _Kind.expenseVerb;
      }
    }
  }

  (String, int)? _matchPayment(List<_Token> tokens, int i) {
    (String, int)? best;
    _dict.payments.forEach((method, phrases) {
      for (final p in phrases) {
        final len = _matchPhrase(tokens, i, p, allowSuffix: true);
        if (len > (best?.$2 ?? 0)) best = (method, len);
      }
    });
    return best;
  }

  // ---------------------------------------------------------------------------
  // Building transactions

  List<ParsedTransaction> _build(List<_Token> tokens, DateTime base) {
    // A clause is the text between separators ("lunch 200, bus 50").
    final clauses = <List<int>>[[]];
    for (var i = 0; i < tokens.length; i++) {
      if (tokens[i].kind == _Kind.separator) {
        if (clauses.last.isNotEmpty) clauses.add([]);
      } else {
        clauses.last.add(i);
      }
    }

    // A date applies to its own clause and every clause after it.
    var currentDate = base;

    final result = <ParsedTransaction>[];
    _Guess? header; // clause without an amount, e.g. "bazar:" or "bkash e"
    _Guess? previous;

    for (final clause in clauses) {
      if (clause.isEmpty) continue;
      for (final i in clause) {
        if (tokens[i].date != null) {
          currentDate = tokens[i].date!;
          break;
        }
      }

      final amounts = clause
          .where((i) => tokens[i].kind == _Kind.amount)
          .toList();
      if (amounts.isEmpty) {
        header = _guess(tokens, clause);
        previous = null;
        continue;
      }

      final clauseVerb = _verbOf(tokens, clause);
      for (final segment in _segments(tokens, clause, amounts)) {
        final amount =
            tokens[segment.firstWhere((i) => tokens[i].kind == _Kind.amount)]
                .value!
                .round();
        if (amount <= 0) continue;

        final g = _guess(tokens, segment);
        g.verb ??= clauseVerb;
        // "lunch 200+150": a bare number repeats the previous item.
        g.inheritFrom(g.isBare ? (previous ?? header) : header);
        previous = g;

        result.add(_finish(g, amount, currentDate));
      }
    }
    return result;
  }

  /// Splits a clause with several amounts into one token range per amount.
  /// "rickshaw 50 bus 30" gives words before each amount; "50 rickshaw 30 bus"
  /// gives words after.
  List<List<int>> _segments(
    List<_Token> tokens,
    List<int> clause,
    List<int> amounts,
  ) {
    if (amounts.length == 1) return [clause];
    final firstAmount = clause.indexOf(amounts.first);
    final wordsFirst = clause
        .take(firstAmount)
        .any((i) => _isContent(tokens[i]));

    final cuts = <int>[0];
    for (var a = 1; a < amounts.length; a++) {
      final pos = clause.indexOf(amounts[a]);
      cuts.add(wordsFirst ? clause.indexOf(amounts[a - 1]) + 1 : pos);
    }
    cuts.add(clause.length);
    return [
      for (var c = 0; c < cuts.length - 1; c++)
        clause.sublist(cuts[c], cuts[c + 1]),
    ];
  }

  _Guess _guess(List<_Token> tokens, List<int> range) {
    final g = _Guess();
    for (final i in range) {
      final t = tokens[i];
      if (t.kind == _Kind.payment) g.payment ??= t.payment;
      if (_isContent(t)) g.words.add(t.text);
    }
    g.verb = _verbOf(tokens, range);

    // Learned words beat the dictionary: the user corrected these before.
    for (final w in g.words) {
      final key = _learnedFor(w);
      if (key != null) {
        g.learnedKey = key;
        return g;
      }
    }

    var bestScore = 0;
    for (final i in range) {
      if (tokens[i].kind != _Kind.word) continue;
      final content = _isContent(tokens[i]);
      for (final kw in _dict.keywords) {
        final len = _matchPhrase(tokens, i, kw.text, allowSuffix: true);
        var score = 0;
        if (len > 0 && range.contains(i + len - 1)) {
          score = kw.group.weight * 1000 + (len > 1 ? 500 : 0) + kw.text.length;
        } else if (content &&
            kw.fuzzy &&
            _fuzzy(tokens[i].text, kw.text.first)) {
          score = kw.group.weight * 1000 - 500 + kw.text.length;
        }
        // "bonus 5000 pelam": an income verb favours income categories.
        if (score > 0 && g.verb != null) {
          final income = incomeCategories.contains(kw.group.category);
          if (income == (g.verb == _Kind.incomeVerb)) score += 300;
        }
        if (score > bestScore) {
          bestScore = score;
          g.group = kw.group;
        }
      }
    }
    return g;
  }

  String? _learnedFor(String word) {
    final direct = learned[word];
    if (direct != null) return direct;
    for (final e in learned.entries) {
      if (_wordMatches(word, e.key)) return e.value;
    }
    return null;
  }

  _Kind? _verbOf(List<_Token> tokens, List<int> range) {
    for (final i in range) {
      final k = tokens[i].kind;
      if (k == _Kind.incomeVerb || k == _Kind.expenseVerb) return k;
    }
    return null;
  }

  ParsedTransaction _finish(_Guess g, int amount, DateTime date) {
    var category =
        g.learnedKey ?? g.group?.category ?? g.inheritedCategory ?? '';
    final categoryIsIncome = incomeCategories.contains(category);

    // An explicit verb wins; otherwise the category decides.
    final isIncome = switch (g.verb) {
      _Kind.incomeVerb => true,
      _Kind.expenseVerb => false,
      _ => categoryIsIncome,
    };
    if (category.isEmpty) {
      category = isIncome ? 'miscellaneous_income' : 'miscellaneous_expense';
    } else if (isIncome && !categoryIsIncome) {
      category = incomeEquivalent[category] ?? 'miscellaneous_income';
    } else if (!isIncome && categoryIsIncome) {
      category = expenseEquivalent[category] ?? 'miscellaneous_expense';
    }

    final title = g.group?.title ?? g.inheritedTitle ?? _titleFrom(g.words);

    return ParsedTransaction(
      title: title.isNotEmpty ? title : (isIncome ? 'Income' : 'Expense'),
      isIncome: isIncome,
      amount: amount,
      categoryKey: category,
      date: date,
      paymentMethod: g.payment ?? 'cash',
      words: List.unmodifiable(g.words),
    );
  }

  String _titleFrom(List<String> words) => words
      .take(3)
      .map(
        (w) => RegExp(r'^[a-z]').hasMatch(w)
            ? w[0].toUpperCase() + w.substring(1)
            : w,
      )
      .join(' ');

  // ---------------------------------------------------------------------------
  // Matching helpers

  bool _isContent(_Token t) =>
      t.kind == _Kind.word &&
      t.text.length >= 2 &&
      !_dict.stop.contains(t.text) &&
      !_dict.units.contains(t.text) &&
      !_dict.numbers.containsKey(t.text) &&
      double.tryParse(t.text) == null;

  /// Length of [phrase] (in tokens) matched at [i], or 0.
  int _matchPhrase(
    List<_Token> tokens,
    int i,
    List<String> phrase, {
    bool allowSuffix = false,
  }) {
    if (i + phrase.length > tokens.length) return 0;
    for (var k = 0; k < phrase.length; k++) {
      final t = tokens[i + k];
      if (t.kind != _Kind.word) return 0;
      final ok = allowSuffix
          ? _wordMatches(t.text, phrase[k])
          : t.text == phrase[k];
      if (!ok) return 0;
    }
    return phrase.length;
  }

  static bool _wordMatches(String token, String word) {
    if (token == word) return true;
    if (!token.startsWith(word)) return false;
    return _dict.suffixes.contains(token.substring(word.length));
  }

  bool _matchesAny(String token, Set<String> words) =>
      words.contains(token) || words.any((w) => _wordMatches(token, w));

  /// One typo in a longer Banglish word: "resturant", "bkassh".
  static bool _fuzzy(String a, String b) {
    if (a.length < 5 || (a.length - b.length).abs() > 1) return false;
    var i = 0, j = 0, edits = 0;
    while (i < a.length && j < b.length) {
      if (a[i] == b[j]) {
        i++;
        j++;
        continue;
      }
      if (++edits > 1) return false;
      if (a.length > b.length) {
        i++;
      } else if (a.length < b.length) {
        j++;
      } else {
        i++;
        j++;
      }
    }
    return edits + (a.length - i) + (b.length - j) <= 1;
  }

  static final _dict = _CompiledDictionary();
}

enum _Kind {
  word,
  separator,
  amount,
  quantity,
  date,
  payment,
  incomeVerb,
  expenseVerb,
  skip,
}

class _Token {
  final String text;
  _Kind kind = _Kind.word;
  double? value;
  DateTime? date;
  String? payment;

  _Token(this.text);
}

/// What one clause or segment says, before it becomes a transaction.
class _Guess {
  final List<String> words = [];
  KeywordGroup? group;
  String? learnedKey;
  String? payment;
  _Kind? verb;
  String? inheritedCategory;
  String? inheritedTitle;

  bool get hasCategory => group != null || learnedKey != null;
  bool get isBare => words.isEmpty && !hasCategory;

  /// Fills in what this item didn't say from an earlier item or header.
  /// A bare number copies everything; a described item only borrows the
  /// category (when it has none), payment and income/expense verb.
  void inheritFrom(_Guess? from) {
    if (from == null) return;
    if (isBare) {
      words.addAll(from.words);
      inheritedTitle = from.group?.title ?? from.inheritedTitle;
    }
    if (!hasCategory) {
      inheritedCategory =
          from.learnedKey ?? from.group?.category ?? from.inheritedCategory;
    }
    payment ??= from.payment;
    verb ??= from.verb;
  }
}

class _Keyword {
  final KeywordGroup group;
  final List<String> text;
  final bool fuzzy;

  _Keyword(this.group, this.text)
    : fuzzy = text.length == 1 && RegExp(r'^[a-z]{5,}$').hasMatch(text.first);
}

/// The dictionary with every word run through [normalizeText], so Bangla
/// spelling variants and the input always compare equal.
class _CompiledDictionary {
  late final RegExp gluedHundreds = RegExp(
    '^(${numberWords.keys.where((w) => w.codeUnitAt(0) > 0x0980).map(_n).join('|')})'
    '(শো|শ|শত)\$',
  );

  late final keywords = [
    for (final g in categoryKeywords)
      for (final w in g.words) _Keyword(g, _phrase(w)),
  ];
  late final payments = {
    for (final e in paymentKeywords.entries)
      e.key: e.value.map(_phrase).toList(),
  };
  late final fixedDates = <(List<List<String>>, int)>[
    (todayWords.map(_phrase).toList(), 0),
    (yesterdayWords.map(_phrase).toList(), -1),
    (tomorrowWords.map(_phrase).toList(), 1),
    (dayBeforeYesterdayWords.map(_phrase).toList(), -2),
    (lastWeekWords.map(_phrase).toList(), -7),
  ];
  late final months = {for (final e in monthWords.entries) _n(e.key): e.value};
  late final numbers = {
    for (final e in numberWords.entries) _n(e.key): e.value,
  };
  late final mults = {for (final e in multipliers.entries) _n(e.key): e.value};
  late final separators = separatorWords.map(_n).toSet();
  late final currency = currencyWords.map(_n).toSet();
  late final units = unitWords.map(_n).toSet();
  late final stop = stopWords.map(_n).toSet();
  late final suffixes = wordSuffixes.map(_n).toSet();
  late final incomeVerbSet = incomeVerbs.map(_n).toSet();
  late final expenseVerbSet = expenseVerbs.map(_n).toSet();
  late final ordinals = ordinalWords.map(_n).toSet();
  late final days = dayUnits.map(_n).toSet();
  late final weeks = weekUnits.map(_n).toSet();
  late final ago = agoWords.map(_n).toSet();
  late final halfMore = halfMoreWords.map(_n).toSet();

  static String _n(String w) {
    var s = w.toLowerCase();
    TransactionParser._nukta.forEach((from, to) => s = s.replaceAll(from, to));
    return s;
  }

  static List<String> _phrase(String w) => _n(w).split(' ');
}
