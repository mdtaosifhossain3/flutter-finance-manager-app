/// Number helpers for Bangla, Banglish and English money text.
library;

/// Converts Bangla digits (০-৯) to ASCII digits.
String toAsciiDigits(String s) => s.replaceAllMapped(
  RegExp('[০-৯]'),
  (m) => String.fromCharCode(m[0]!.codeUnitAt(0) - 0x09E6 + 0x30),
);

/// Number words. They only count as an amount when a multiplier follows
/// ("dui hajar", "পাঁচ শো"), so "ek" or "at" on their own stay plain words.
const Map<String, double> numberWords = {
  // Bangla
  'এক': 1, 'দুই': 2, 'দু': 2, 'তিন': 3, 'চার': 4, 'পাঁচ': 5, 'ছয়': 6,
  'সাত': 7, 'আট': 8, 'নয়': 9, 'দশ': 10, 'এগারো': 11, 'বারো': 12,
  'পনেরো': 15, 'বিশ': 20, 'পঁচিশ': 25, 'ত্রিশ': 30, 'চল্লিশ': 40,
  'পঞ্চাশ': 50, 'ষাট': 60, 'সত্তর': 70, 'আশি': 80, 'নব্বই': 90,
  'দেড়': 1.5, 'আড়াই': 2.5,
  // Banglish
  'ek': 1, 'dui': 2, 'du': 2, 'tin': 3, 'char': 4, 'pach': 5, 'panch': 5,
  'choy': 6, 'chhoy': 6, 'sat': 7, 'saat': 7, 'at': 8, 'aat': 8, 'noy': 9,
  'dosh': 10, 'das': 10, 'bish': 20, 'pochish': 25, 'tirish': 30,
  'chollish': 40, 'ponchash': 50, 'pachas': 50, 'der': 1.5, 'dedh': 1.5,
  'arai': 2.5, 'adai': 2.5,
  // English
  'one': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5, 'six': 6,
  'seven': 7, 'eight': 8, 'nine': 9, 'ten': 10, 'twenty': 20, 'thirty': 30,
  'forty': 40, 'fifty': 50, 'half': 0.5,
};

/// "সাড়ে তিন হাজার" = 3500: adds a half to the number that follows.
const Set<String> halfMoreWords = {'সাড়ে', 'sare', 'sarhe'};

const Map<String, double> multipliers = {
  'k': 1000,
  'hajar': 1000,
  'hazar': 1000,
  'hajaar': 1000,
  'hajer': 1000,
  'thousand': 1000,
  'হাজার': 1000,
  'lakh': 100000,
  'lac': 100000,
  'lakhs': 100000,
  'laakh': 100000,
  'লাখ': 100000,
  'লক্ষ': 100000,
  'crore': 10000000,
  'koti': 10000000,
  'কোটি': 10000000,
  'sho': 100,
  'so': 100,
  'shoto': 100,
  'shot': 100,
  'hundred': 100,
  'শো': 100,
  'শ': 100,
  'শত': 100,
};
