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
    final banglaMonths = [
      'জানু',
      'ফেব্রু',
      'মার্চ',
      'এপ্রিল',
      'মে',
      'জুন',
      'জুলাই',
      'আগস্ট',
      'সেপ্টেম্বর',
      'অক্টোবর',
      'নভেম্বর',
      'ডিসেম্বর',
    ];

    // Convert numbers to Bangla digits
    String toBanglaDigits(String number) {
      const banglaDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
      return number
          .split('')
          .map((digit) {
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
          })
          .join('');
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
      return number
          .split('')
          .map((digit) => banglaDigits[int.parse(digit)])
          .join('');
    } else {
      return number;
    }
  }

  static String recievedIntAndconvertToBanglaDigits(int number) {
    final locale = Get.locale?.languageCode ?? 'en';
    const banglaDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

    if (locale == 'bn') {
      return number
          .toString()
          .split('')
          .map((digit) {
            return banglaDigits[int.parse(digit)];
          })
          .join('');
    } else {
      return number.toString();
    }
  }

  static String getLocalizedDate() {
    final now = DateTime.now();
    final locale = Get.locale?.languageCode ?? 'en';

    if (locale == 'bn') {
      final banglaDays = [
        'রবিবার',
        'সোমবার',
        'মঙ্গলবার',
        'বুধবার',
        'বৃহস্পতিবার',
        'শুক্রবার',
        'শনিবার',
      ];
      final banglaMonths = [
        'জানুয়ারি',
        'ফেব্রুয়ারি',
        'মার্চ',
        'এপ্রিল',
        'মে',
        'জুন',
        'জুলাই',
        'আগস্ট',
        'সেপ্টেম্বর',
        'অক্টোবর',
        'নভেম্বর',
        'ডিসেম্বর',
      ];

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

  static String generateEnglishCategory(banglaCategoryName) {
    Map<String, dynamic> data = {
      // -------------------------------Category Groups Expense-------------------------------
      'category': 'Categories',
      'health_fitness': 'Health & Fitness',
      'food_dining': 'Food & Dining',
      'bills_utilities': 'Bills & Utilities',
      'transportation': 'Transportation',
      'entertainment': 'Entertainment',
      'shopping': 'Shopping',
      'education': 'Education',
      'family_personal': 'Family & Personal',
      'investments_finance': 'Investments & Finance',
      'miscellaneous': 'Miscellaneous',

      // Health & Fitness
      'doctor': 'Doctor',
      'medicine': 'Medicine',
      'gym_exercise': 'Gym / Exercise',
      'cycling': 'Cycling',
      'yoga': 'Yoga',
      'sports': 'Sports',

      // Food & Dining
      'groceries': 'Groceries',
      'tea_coffee': 'Tea & Coffee',
      'restaurants': 'Restaurants',
      'snacks_fast_food': 'Snacks & Fast Food',
      'drinks_beverages': 'Drinks & Beverages',
      'home_cooking': 'Home Cooking',

      // Bills & Utilities
      'phone_bill': 'Phone Bill',
      'water_bill': 'Water Bill',
      'electricity_bill': 'Electricity Bill',
      'gas_bill': 'Gas Bill',
      'internet_wifi': 'Internet / WiFi',
      'house_rent': 'House Rent',

      // Transportation
      'fuel': 'Fuel',
      'parking': 'Parking',
      'public_transport': 'Public Transport',
      'taxi_ride_share': 'Taxi / Ride Share',
      'vehicle_maintenance': 'Vehicle Maintenance',

      // Entertainment
      'movies': 'Movies',
      'games': 'Games',
      'music': 'Music',
      'travel_trips': 'Travel & Trips',
      'streaming_services': 'Streaming Services',
      'events_shows': 'Events & Shows',

      // Shopping
      'clothes': 'Clothes',
      'electronics': 'Electronics',
      'books': 'Books',
      'accessories': 'Accessories',
      'gifts': 'Gifts',

      // Education
      'tuition_fees': 'Tuition Fees',
      'courses': 'Courses',
      'stationery': 'Stationery',
      'books_study_materials': 'Books & Study Materials',

      // Family & Personal
      'child_care': 'Child Care',
      'gifts_donations': 'Gifts & Donations',
      'pets': 'Pets',
      'personal_care': 'Personal Care',
      'salon_beauty': 'Salon / Beauty',

      // Investments & Finance
      'savings': 'Savings',
      'insurance': 'Insurance',
      'loan_emi': 'Loan EMI',
      'taxes': 'Taxes',

      // Miscellaneous
      'emergency': 'Emergency',
      'charity': 'Charity',
      'subscriptions': 'Subscriptions',
      'repairs': 'Repairs',
      'others': 'Others',

      // -------------------------------Category Groups Income-------------------------------

      // Income Groups
      'primary_income': 'Primary Income',
      'investments': 'Investments',
      'rental_assets': 'Rental & Assets',
      'side_income': 'Side Income',
      'other_income': 'Other Income',
      'passive_income': 'Passive Income',

      // Primary Income
      'salary': 'Salary',
      'business': 'Business',
      'freelance': 'Freelance',
      'contract_work': 'Contract Work',
      'overtime_pay': 'Overtime Pay',

      // Investments
      'stocks': 'Stocks',
      'dividends': 'Dividends',
      'crypto': 'Crypto',
      'mutual_funds': 'Mutual Funds',
      'bonds': 'Bonds',
      'real_estate': 'Real Estate',

      // Rental & Assets
      'rental': 'Rental',
      'vehicle_rent': 'Vehicle Rent',
      'property_lease': 'Property Lease',
      'equipment_hire': 'Equipment Hire',

      // Side Income
      'part_time': 'Part-time',
      'commission': 'Commission',
      'consulting': 'Consulting',
      'tutoring': 'Tutoring',
      'affiliate_marketing': 'Affiliate Marketing',
      'online_sales': 'Online Sales',
      'content_creation': 'Content Creation',

      // Other Income
      'bonus': 'Bonus',
      'refund': 'Refund',
      'donations': 'Donations',
      'awards_prizes': 'Awards & Prizes',
      'lottery_gambling': 'Lottery / Gambling',
      'cashback_rewards': 'Cashback / Rewards',
      'interest_income': 'Interest Income',

      // Passive / Digital Income
      'royalties': 'Royalties',
      'ads_revenue': 'Ads Revenue',
      'licensing': 'Licensing',
      'divine_donations': 'Divine Donations',

      // Final catch-all
      'other': 'Other',
    };

    return data[banglaCategoryName] ?? banglaCategoryName;
  }
}
