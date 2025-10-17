import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HelperFunctions {
  HelperFunctions._();
  // Add your helper functions here
 static String formatDateToMonthDay(DateTime date) {

    final DateFormat formatter = DateFormat('MMMM d');
    return formatter.format(date);
  }

  static String getFormattedDateTime(DateTime date) {
    final locale = Get.locale?.languageCode ?? 'en';

    if (locale == 'bn') {
      return _getBanglaFormattedDateTime(date);
    } else {
      final formatter = DateFormat("dd MMM, h:mm a");
      return formatter.format(date);
    }
  }

  static String _getBanglaFormattedDateTime(DateTime date) {
    // Bangla months (short)
    final banglaMonths = ['জানু', 'ফেব্রু', 'মার্চ', 'এপ্রিল', 'মে', 'জুন', 'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'];

    // Convert numbers to Bangla digits
    String toBanglaDigits(String number) {
      const banglaDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
      return number.split('').map((digit) {
        if (digit == '0') return banglaDigits[0];
        if (digit == '1') return banglaDigits[1];
        if (digit == '2') return banglaDigits[2];
        if (digit == '3') return banglaDigits[3];
        if (digit == '4') return banglaDigits[4];
        if (digit == '5') return banglaDigits[5];
        if (digit == '6') return banglaDigits[6];
        if (digit == '7') return banglaDigits[7];
        if (digit == '8') return banglaDigits[8];
        if (digit == '9') return banglaDigits[9];
        return digit;
      }).join('');
    }

    final day = toBanglaDigits(date.day.toString().padLeft(2, '0'));
    final month = banglaMonths[date.month - 1];
    final hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final hour = toBanglaDigits(hour12.toString());
    final minute = toBanglaDigits(date.minute.toString().padLeft(2, '0'));
    final period = date.hour < 12 ? 'AM' : 'PM';

    return '$day $month, $hour:$minute $period';
  }

  static String formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy').format(date);
  }

  // Method to get localized date
  static String convertToBanglaDigits(String number) {
    const banglaDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

    final locale = Get.locale?.languageCode ?? 'en';

    if (locale == 'bn') {
      return number.split('').map((digit) => banglaDigits[int.parse(digit)]).join('');
    } else {
      return number;
    }
  }

  static String recievedIntAndconvertToBanglaDigits(int number) {
    final locale = Get.locale?.languageCode ?? 'en';
    const banglaDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

    if (locale == 'bn') {
      return number.toString().split('').map((digit) {
        return banglaDigits[int.parse(digit)];
      }).join('');    }

    else {
      return number.toString();
    }

  }


  static String getLocalizedDate() {
    final now = DateTime.now();
    final locale = Get.locale?.languageCode ?? 'en';

    if (locale == 'bn') {
      final banglaDays = ['রবিবার', 'সোমবার', 'মঙ্গলবার', 'বুধবার', 'বৃহস্পতিবার', 'শুক্রবার', 'শনিবার'];
      final banglaMonths = ['জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন', 'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'];

      final dayIndex = (now.weekday == 7) ? 0 : now.weekday;
      final monthIndex = now.month - 1;
      final banglaDay = convertToBanglaDigits(now.day.toString());

      return '${banglaDays[dayIndex]}, $banglaDay ${banglaMonths[monthIndex]}';
    } else {
      return DateFormat('EEEE, d MMMM').format(now);
    }
  }

  static String getLocalizedMonth(String monthName) {
    final locale = Get.locale?.languageCode ?? 'en';

    if (locale == 'bn') {
      return _toBanglaMonth(monthName);
    } else {
      return _toEnglishMonth(monthName);
    }
  }

  static String _toBanglaMonth(String monthName) {
    final monthMap = {
      'Jan': 'জানু',
      'Feb': 'ফেব্রু',
      'Mar': 'মার্চ',
      'Apr': 'এপ্রিল',
      'May': 'মে',
      'Jun': 'জুন',
      'Jul': 'জুলাই',
      'Aug': 'আগস্ট',
      'Sep': 'সেপ্টেম্বর',
      'Oct': 'অক্টোবর',
      'Nov': 'নভে',
      'Dec': 'ডিসে',
    };

    return monthMap[monthName] ?? monthName;
  }

  static String _toEnglishMonth(String monthName) {
    final monthMap = {
      'জানু': 'Jan',
      'ফেব্রু': 'Feb',
      'মার্চ': 'Mar',
      'এপ্রিল': 'Apr',
      'মে': 'May',
      'জুন': 'Jun',
      'জুলাই': 'Jul',
      'আগস্ট': 'Aug',
      'সেপ্টেম্বর': 'Sep',
      'অক্টো': 'Oct',
      'নভে': 'Nov',
      'ডিসে': 'Dec',
    };

    return monthMap[monthName] ?? monthName;
  }



 static double convertToLocalizedDigits(double value) {
    // Convert double to string (without scientific notation)
    String numberStr = value.toString();

    // If the current locale language code is not Bangla, return as-is
    if (Get.locale?.languageCode != 'bn') {
      return value;
    }

    // Map of English to Bangla digits
    const Map<String, String> banglaDigits = {
      '0': '০',
      '1': '১',
      '2': '২',
      '3': '৩',
      '4': '৪',
      '5': '৫',
      '6': '৬',
      '7': '৭',
      '8': '৮',
      '9': '৯',
      '.': '.', // keep the dot same
    };

    // Replace all digits with Bangla equivalents
    String converted = numberStr.split('').map((char) {
      return banglaDigits[char] ?? char;
    }).join();

    return double.tryParse(converted) ?? value;
  }

}