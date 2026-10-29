/// Reads bKash, Nagad, Rocket, Upay and bank SMS that the user pastes or
/// shares into the app. Offline and keyword based, so small wording changes
/// by the providers still parse.
enum SmsKind { income, expense, transfer }

class ParsedSms {
  final SmsKind kind;
  final int amount;
  final int fee;

  /// Payment-method key of the wallet the SMS is about.
  final String wallet;

  /// For transfers: the other wallet (e.g. `cash` for a cash out).
  final String? otherWallet;
  final String categoryKey;

  /// Translation key of the description (see [titleKeysEn]) and the other
  /// party (phone number or merchant), if found.
  final String titleKey;
  final String? party;
  final String? trxId;
  final DateTime date;
  final String raw;

  const ParsedSms({
    required this.kind,
    required this.amount,
    required this.fee,
    required this.wallet,
    this.otherWallet,
    required this.categoryKey,
    required this.titleKey,
    this.party,
    required this.trxId,
    required this.date,
    required this.raw,
  });

  /// English description, e.g. "Received from 01712345678".
  String get title {
    final base = titleKeysEn[titleKey] ?? titleKey;
    return party == null ? base : '$base $party';
  }

  /// Transfers go from [wallet] to [otherWallet] unless money came in.
  bool get transferIntoWallet =>
      kind == SmsKind.transfer && _inbound.hasMatch(raw.toLowerCase());
}

const titleKeysEn = {
  'sms_cash_out': 'Cash out',
  'sms_cash_in': 'Cash in',
  'sms_atm': 'ATM withdrawal',
  'sms_add_money': 'Add money',
  'sms_recharge': 'Mobile recharge',
  'sms_bill': 'Bill payment',
  'sms_received_from': 'Received from',
  'sms_sent_to': 'Sent to',
  'sms_payment_to': 'Payment to',
  'sms_debit': 'Debit',
};

final _inbound = RegExp(r'cash in|add money|added|deposit');

class SmsParser {
  static final _amountRe = RegExp(
    r'(?:tk\.?|bdt|৳)\s*:?\s*([\d,]+(?:\.\d{1,2})?)',
    caseSensitive: false,
  );
  static final _feeRe = RegExp(
    r'\b(?:fee|charge)\s*:?\s*(?:tk\.?|bdt|৳)?\s*:?\s*([\d,]+(?:\.\d{1,2})?)',
    caseSensitive: false,
  );
  static final _trxRe = RegExp(
    r'\b(?:trx\s*id|txn\s*id|trxid|txnid|transaction\s*id)\s*[:.]?\s*([A-Z0-9]{6,})',
    caseSensitive: false,
  );
  static final _dateRe = RegExp(
    r'(\d{1,2})[/-](\d{1,2})[/-](\d{2,4})(?:\s+(\d{1,2}):(\d{2}))?',
  );
  static final _phoneRe = RegExp(r'(?:\+?88)?(01\d{9})');
  static final _merchantRe = RegExp(
    r'\b(?:to|at)\s+([A-Za-z][A-Za-z0-9 &._-]{2,40}?)(?=\s+(?:successful|is successful|was|on|ref|fee|\.|,)|[.,]|$)',
    caseSensitive: false,
  );
  // "Fee Tk 5", "Balance: Tk 100", but not "Recharge Tk 100".
  static final _labelBefore = RegExp(
    r'\b(?:fee|charge|balance|bal)\b\.?\s*:?\s*$',
    caseSensitive: false,
  );
  static final _otpRe = RegExp(
    r'\b(?:otp|verification code|pin)\b',
    caseSensitive: false,
  );

  /// Splits pasted text into single messages and parses each one. Messages
  /// that aren't money movements (OTP, offers…) are skipped.
  static List<ParsedSms> parseAll(String text, {DateTime? now}) {
    return [
      for (final m in split(text))
        if (parse(m, now: now) case final p?) p,
    ];
  }

  static List<String> split(String text) {
    final chunks = text
        .split(RegExp(r'\n\s*\n'))
        .map((c) => c.trim())
        .where((c) => c.isNotEmpty);
    final result = <String>[];
    for (final chunk in chunks) {
      // Several SMS pasted without blank lines: each one ends at its TrxID.
      if (_trxRe.allMatches(chunk).length > 1) {
        var buffer = StringBuffer();
        for (final line in chunk.split('\n')) {
          buffer.writeln(line);
          if (_trxRe.hasMatch(line)) {
            result.add(buffer.toString().trim());
            buffer = StringBuffer();
          }
        }
        if (buffer.toString().trim().isNotEmpty) {
          result.add(buffer.toString().trim());
        }
      } else {
        result.add(chunk);
      }
    }
    return result;
  }

  static ParsedSms? parse(String sms, {DateTime? now}) {
    final text = sms.replaceAll(RegExp(r'\s+'), ' ').trim();
    final lower = text.toLowerCase();
    if (_otpRe.hasMatch(lower) && !lower.contains('trxid')) return null;

    final amount = _firstAmount(text);
    if (amount == null || amount <= 0) return null;

    final feeMatch = _feeRe.firstMatch(text);
    final fee = feeMatch == null ? 0 : _toInt(feeMatch.group(1)!);
    final trxId = _trxRe.firstMatch(text)?.group(1)?.toUpperCase();
    final date = _date(text) ?? now ?? DateTime.now();
    final wallet = _wallet(lower);
    final phone = _phoneRe.firstMatch(text)?.group(1);
    final party = phone ?? _merchantRe.firstMatch(text)?.group(1)?.trim();

    ParsedSms build(
      SmsKind kind,
      String category,
      String title, {
      String? other,
    }) => ParsedSms(
      kind: kind,
      amount: amount,
      fee: fee,
      wallet: wallet,
      otherWallet: other,
      categoryKey: category,
      titleKey: title,
      party: party,
      trxId: trxId,
      date: date,
      raw: sms.trim(),
    );

    // Order matters: "cash out" must win over "out", "received" etc.
    if (lower.contains('cash out') || lower.contains('cashout')) {
      return build(SmsKind.transfer, '', 'sms_cash_out', other: 'cash');
    }
    if (lower.contains('cash in')) {
      return build(SmsKind.transfer, '', 'sms_cash_in', other: 'cash');
    }
    if (lower.contains('atm') && _isDebit(lower)) {
      return build(SmsKind.transfer, '', 'sms_atm', other: 'cash');
    }
    if (lower.contains('add money') || lower.contains('added money')) {
      return build(
        SmsKind.transfer,
        '',
        'sms_add_money',
        other: wallet == 'bankTransfer' ? 'bkash' : 'bankTransfer',
      );
    }
    if (lower.contains('recharge') ||
        lower.contains('top up') ||
        lower.contains('top-up')) {
      return build(SmsKind.expense, 'bills_utilities', 'sms_recharge');
    }
    if (lower.contains('bill')) {
      return build(SmsKind.expense, 'bills_utilities', 'sms_bill');
    }
    if (lower.contains('received') ||
        lower.contains('credited') ||
        lower.contains('deposited') ||
        lower.contains('remittance') ||
        lower.contains('cashback')) {
      return build(SmsKind.income, 'miscellaneous_income', 'sms_received_from');
    }
    if (lower.contains('send money') ||
        lower.contains('sent') ||
        lower.contains('transferred to')) {
      return build(SmsKind.expense, 'miscellaneous_expense', 'sms_sent_to');
    }
    if (lower.contains('payment') ||
        lower.contains('paid') ||
        lower.contains('purchase') ||
        lower.contains('pos ')) {
      return build(SmsKind.expense, 'shopping', 'sms_payment_to');
    }
    if (_isDebit(lower)) {
      return build(SmsKind.expense, 'miscellaneous_expense', 'sms_debit');
    }
    return null;
  }

  static bool _isDebit(String lower) =>
      lower.contains('debited') ||
      lower.contains('withdrawn') ||
      lower.contains('withdrawal');

  /// The transaction amount: the first amount that isn't the fee or balance.
  static int? _firstAmount(String text) {
    for (final m in _amountRe.allMatches(text)) {
      final before = text.substring(0, m.start);
      if (_labelBefore.hasMatch(before)) continue;
      return _toInt(m.group(1)!);
    }
    return null;
  }

  static String _wallet(String lower) {
    if (lower.contains('nagad')) return 'nagad';
    if (lower.contains('rocket') || lower.contains('dbbl mobile')) {
      return 'rocket';
    }
    if (lower.contains('upay')) return 'upay';
    if (lower.contains('bkash')) return 'bkash';
    if (RegExp(r'a/c|account|acct|card|bank').hasMatch(lower)) {
      return lower.contains('card') && !lower.contains('a/c')
          ? 'debitCard'
          : 'bankTransfer';
    }
    // bKash SMS often don't name bKash but always carry "TrxID".
    if (lower.contains('trxid') || lower.contains('trx id')) return 'bkash';
    if (lower.contains('txnid') || lower.contains('txn id')) return 'nagad';
    return 'bkash';
  }

  static DateTime? _date(String text) {
    final m = _dateRe.firstMatch(text);
    if (m == null) return null;
    final day = int.parse(m.group(1)!);
    final month = int.parse(m.group(2)!);
    var year = int.parse(m.group(3)!);
    if (year < 100) year += 2000;
    if (month < 1 || month > 12 || day < 1 || day > 31) return null;
    final hour = m.group(4) == null ? 12 : int.parse(m.group(4)!);
    final minute = m.group(5) == null ? 0 : int.parse(m.group(5)!);
    return DateTime(year, month, day, hour.clamp(0, 23), minute.clamp(0, 59));
  }

  static int _toInt(String s) => double.parse(s.replaceAll(',', '')).round();
}
