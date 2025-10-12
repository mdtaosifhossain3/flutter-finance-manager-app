import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'settings': 'Hello', 'welcome': 'Welcome',
      'reportTitle': 'Report',
      'search': 'Super AI search',
      'income': 'Income',
      //-------------------------------Welcome View-------------------------------
      "welcomeViewTitle":"Easy way to\nManage your Money",
      "welcomeViewSubtitle": "Organize your spending, plan your savings, and stay stress-free.",
      "welcomeViewButtonOne": "Get Started",
      "welcomeViewButtonTwo": "Preview Demo",
      //-------------------------------Home View-------------------------------

      "expensesTitle": "Expenses",
      "outOfText": "Out of",
      "periodDay": "D",
      "periodWeek": "W",
      "periodMonth": "M",
      "historyTitle": "History",
      "seeAllButton": "See All",
      "noTransactions": "No transactions yet",

      // -------------------------------Report View-------------------------------
      "spent": "Spent",
      "expenses": "Expenses",
      "monthlyBudget": "Monthly Budget",
      "6periods": "Last 6 Periods",
      "budget": "Budget",
      "within": "Within",
      "risk": "Risk",
      "overspending": "Overspending",

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
      // -------------------------------Category Item -------------------------------
      "transactions": "Transactions",
      "totalAmount":"Total Amount",
      "addFirstTransaction":"Add your first transaction to get started",
      "addTransaction": "Add Transaction",

      // -------------------------------Category Card-------------------------------
        "transactionDetails": "Transaction Details",
      "title":"Title",

      // -------------------------------Transaction Form Page -------------------------------
        "titleOptional": "Title (Optional)",
        "titleHint": "Enter transaction title",
        "amountRequired": "Amount *",
        "amountHint": "0.00",
        "amountRequiredError": "Amount is required",
        "amountValidError": "Enter a valid amount",
        "amountGreaterError": "Amount must be greater than 0",
        "dateRequired": "Date *",
        "paymentMethodRequired": "Payment Method *",
        "notesOptional": "Notes (Optional)",
        "notesHint": "Add any additional notes...",
        "saveTransaction": "Save Transaction",
        "successTitle": "Success!",
        "successMessage": "Transaction saved successfully!",
        "details": "Details:",
        "amount": "Amount",
        "payment": "Payment",
        "date": "Date",
        "notes": "Notes",
        "addAnother": "Add Another",
        "done": "Done",

        // Payment Methods
        "cash": "Cash",
        "bankTransfer": "Bank Transfer",
        "creditCard": "Credit Card",
        "debitCard": "Debit Card",
        "mobileWallet": "Mobile Wallet",
        "paypal": "PayPal",
        "check": "Check",


      // -------------------------------Budget Category-------------------------------
// Category Groups
      'basic_needs': 'Basic Needs',
      'food_lifestyle': 'Food & Lifestyle',
      'health_safety': 'Health & Safety',
      'education_growth': 'Education & Growth',
      'financial_goals': 'Financial Goals',
      'family_home': 'Family & Home',
      'work_business': 'Work & Business',

      // Basic Needs
      'utilities': 'Utilities',
      'rent_mortgage': 'Rent / Mortgage',
      'bills_subscriptions': 'Bills & Subscriptions',
      'internet_phone': 'Internet & Phone',

      // Food & Lifestyle
      'dining_out': 'Dining Out',
      'travel': 'Travel',
      'gym_fitness': 'Gym & Fitness',
      'hobbies': 'Hobbies',

      // Health & Safety
      'healthcare': 'Healthcare',
      'emergency_fund': 'Emergency Fund',

      // Education & Growth
      'courses_training': 'Courses & Training',
      'books_supplies': 'Books & Supplies',

      // Financial Goals
      'investment': 'Investment',
      'retirement_fund': 'Retirement Fund',
      'loan_repayment': 'Loan Repayment',
      'debt_payment': 'Debt Payment',

      // Family & Home
      'household_supplies': 'Household Supplies',
      'home_maintenance': 'Home Maintenance',

      // Work & Business
      'business_expenses': 'Business Expenses',
      'office_supplies': 'Office Supplies',
      'freelancing_tools': 'Freelancing Tools',
      'transportation_work': 'Transportation (Work)',

      // Miscellaneous
      'subscriptions_memberships': 'Subscriptions & Memberships',
      'events_celebrations': 'Events & Celebrations',
      'luxury_wants': 'Luxury / Wants',

    },
    'bn_BD': {
      'settings': 'হ্যালো', 'welcome': 'স্বাগতম',
      'reportTitle': 'রিপোর্ট',
      'search': 'অনুসন্ধান করুন',
      'income': 'আয়',

      //-------------------------------Welcome View-------------------------------
      "welcomeViewTitle": "টাকা ব্যবস্থাপনার\nসহজ সমাধান",
        "welcomeViewSubtitle": "খরচ সংগঠিত করুন, সঞ্চয়ের পরিকল্পনা করুন এবং নিশ্চিন্তে থাকুন।",
        "welcomeViewButtonOne": "শুরু করুণ",
        "welcomeViewButtonTwo": "ডেমো দেখুন",

      //-------------------------------Home View-------------------------------
      "expensesTitle": "খরচ",
      "outOfText": "এর মধ্যে",
      "periodDay": "দিন",
      "periodWeek": "সপ্তাহ",
      "periodMonth": "মাস",
      "historyTitle": "ইতিহাস",
      "seeAllButton": "সব দেখুন",
      "noTransactions": "এখনও কোন লেনদেন নেই",

      // -------------------------------Report View-------------------------------
        "spent": "খরচ",
        "expenses": "ব্যয়",
        "monthlyBudget": "মাসিক বাজেট",
        "6periods": "গত ৬ মাস",
        "budget": "বাজেট",
        "within": "মধ্যে",
        "risk": "ঝুঁকি",
        "overspending": "বাজেট ছাড়ানো",

      // ------------------------------- Category Groups Expense-------------------------------
      'category': 'ক্যাটাগরি',
      'health_fitness': 'স্বাস্থ্য ও ফিটনেস',
      'food_dining': 'খাবার ও ডাইনিং',
      'bills_utilities': 'বিল ও ইউটিলিটি',
      'transportation': 'যাতায়াত',
      'entertainment': 'বিনোদন',
      'shopping': 'কেনাকাটা',
      'education': 'শিক্ষা',
      'family_personal': 'পরিবার ও ব্যক্তিগত',
      'investments_finance': 'বিনিয়োগ ও অর্থ',
      'miscellaneous': 'বিবিধ',

      // Health & Fitness
      'doctor': 'ডাক্তার',
      'medicine': 'ঔষধ',
      'gym_exercise': 'জিম / ব্যায়াম',
      'cycling': 'সাইক্লিং',
      'yoga': 'যোগব্যায়াম',
      'sports': 'খেলাধুলা',

      // Food & Dining
      'groceries': 'গ্রোসারি',
      'tea_coffee': 'চা ও কফি',
      'restaurants': 'রেস্টুরেন্ট',
      'snacks_fast_food': 'স্ন্যাক্স ও ফাস্ট ফুড',
      'drinks_beverages': 'পানীয়',
      'home_cooking': 'বাসার রান্না',

      // Bills & Utilities
      'phone_bill': 'ফোন বিল',
      'water_bill': 'পানির বিল',
      'electricity_bill': 'বিদ্যুৎ বিল',
      'gas_bill': 'গ্যাস বিল',
      'internet_wifi': 'ইন্টারনেট / ওয়াইফাই',
      'house_rent': 'বাড়ি ভাড়া',

      // Transportation
      'fuel': 'জ্বালানী',
      'parking': 'পার্কিং',
      'public_transport': 'পাবলিক ট্রান্সপোর্ট',
      'taxi_ride_share': 'ট্যাক্সি / রাইড শেয়ার',
      'vehicle_maintenance': 'গাড়ি মেরামত',

      // Entertainment
      'movies': 'সিনেমা',
      'games': 'গেমস',
      'music': 'গান',
      'travel_trips': 'ভ্রমণ',
      'streaming_services': 'স্ট্রিমিং সার্ভিস',
      'events_shows': 'ইভেন্ট ও শো',

      // Shopping
      'clothes': 'পোশাক',
      'electronics': 'ইলেকট্রনিক্স',
      'books': 'বই',
      'accessories': 'অ্যাকসেসরিজ',
      'gifts': 'উপহার',

      // Education
      'tuition_fees': 'টিউশন ফি',
      'courses': 'কোর্স',
      'stationery': 'স্টেশনারি',
      'books_study_materials': 'বই ও পড়ার সামগ্রী',

      // Family & Personal
      'child_care': 'শিশু যত্ন',
      'gifts_donations': 'উপহার ও দান',
      'pets': 'পোষা প্রাণী',
      'personal_care': 'ব্যক্তিগত যত্ন',
      'salon_beauty': 'সেলুন / বিউটি',

      // Investments & Finance
      'savings': 'সঞ্চয়',
      'insurance': 'বীমা',
      'loan_emi': 'লোন ইএমআই',
      'taxes': 'ট্যাক্স',

      // Miscellaneous
      'emergency': 'জরুরী',
      'charity': 'দান',
      'subscriptions': 'সাবস্ক্রিপশন',
      'repairs': 'মেরামত',
      'others': 'অন্যান্য',

      // -------------------------------Category Groups Income-------------------------------
      // Income Groups
      'primary_income': 'প্রাথমিক আয়',
      'investments': 'বিনিয়োগ',
      'rental_assets': 'ভাড়া ও সম্পদ',
      'side_income': 'অতিরিক্ত আয়',
      'other_income': 'অন্যান্য আয়',
      'passive_income': 'প্যাসিভ ইনকাম',

      // Primary Income
      'salary': 'বেতন',
      'business': 'ব্যবসা',
      'freelance': 'ফ্রিল্যান্স',
      'contract_work': 'চুক্তিভিত্তিক কাজ',
      'overtime_pay': 'ওভারটাইম পে',

      // Investments
      'stocks': 'স্টক',
      'dividends': 'ডিভিডেন্ড',
      'crypto': 'ক্রিপ্টো',
      'mutual_funds': 'মিউচুয়াল ফান্ড',
      'bonds': 'বন্ড',
      'real_estate': 'রিয়েল এস্টেট',

      // Rental & Assets
      'rental': 'ভাড়া',
      'vehicle_rent': 'গাড়ি ভাড়া',
      'property_lease': 'প্রপার্টি লিজ',
      'equipment_hire': 'ইকুইপমেন্ট ভাড়া',

      // Side Income
      'part_time': 'খণ্ডকালীন',
      'commission': 'কমিশন',
      'consulting': 'কনসাল্টিং',
      'tutoring': 'টিউশন',
      'affiliate_marketing': 'অ্যাফিলিয়েট মার্কেটিং',
      'online_sales': 'অনলাইন বিক্রয়',
      'content_creation': 'কন্টেন্ট ক্রিয়েশন',

      // Other Income
      'bonus': 'বোনাস',
      'refund': 'রিফান্ড',
      'donations': 'দান',
      'awards_prizes': 'পুরস্কার',
      'lottery_gambling': 'লটারি / জুয়া',
      'cashback_rewards': 'ক্যাশব্যাক / রিওয়ার্ড',
      'interest_income': 'সুদ আয়',

      // Passive / Digital Income
      'royalties': 'রয়্যালটি',
      'ads_revenue': 'এডস রেভিনিউ',
      'licensing': 'লাইসেন্সিং',
      'divine_donations': 'দান',

      // Final catch-all
      'other': 'অন্যান্য',
      // -------------------------------Category Item -------------------------------

        "transactions": "লেনদেনসমূহ",
        "totalAmount": "মোট টাকা",
        "addFirstTransaction": "প্রথম লেনদেন যোগ করুন",
        "addTransaction": "ট্রানজেকশন যোগ করুন",

      // -------------------------------Category Card-------------------------------
      "title":"শিরোনাম",
      "transactionDetails":"লেনদেনের বিবরণ",


      // ------------------------------- Transaction Form Page -------------------------------
      "titleOptional": "শিরোনাম (ঐচ্ছিক)",
      "titleHint": "লেনদেনের শিরোনাম লিখুন",
      "amountRequired": "টাকা *",
      "amountHint": "০.০০",
      "amountRequiredError": "টাকার পরিমাণ প্রয়োজন",
      "amountValidError": "সঠিক টাকার পরিমাণ লিখুন",
      "amountGreaterError": "টাকার পরিমাণ ০ এর বেশি হতে হবে",
      "dateRequired": "তারিখ *",
      "paymentMethodRequired": "পেমেন্ট মাধ্যম *",
      "notesOptional": "নোট (ঐচ্ছিক)",
      "notesHint": "অতিরিক্ত নোট যোগ করুন...",
      "saveTransaction": "লেনদেন সংরক্ষণ করুন",
      "successTitle": "সফল!",
      "successMessage": "লেনদেন সফলভাবে সংরক্ষণ করা হয়েছে!",
      "details": "বিস্তারিত:",
      "amount": "টাকা",
      "payment": "পেমেন্ট",
      "date": "তারিখ",
      "notes": "নোট",
      "addAnother": "আরেকটি যোগ করুন",
      "done": "সম্পন্ন",

      // Payment Methods
      "cash": "ক্যাশ",
      "bankTransfer": "ব্যাংক ট্রান্সফার",
      "creditCard": "ক্রেডিট কার্ড",
      "debitCard": "ডেবিট কার্ড",
      "mobileWallet": "মোবাইল ওয়ালেট",
      "paypal": "পেপ্যাল",
      "check": "চেক",

      // -------------------------------Budget Category-------------------------------
      // Category Groups
      'basic_needs': 'মৌলিক চাহিদা',
      'food_lifestyle': 'খাবার ও লাইফস্টাইল',
      'health_safety': 'স্বাস্থ্য ও নিরাপত্তা',
      'education_growth': 'শিক্ষা ও উন্নয়ন',
      'financial_goals': 'আর্থিক লক্ষ্য',
      'family_home': 'পরিবার ও বাড়ি',
      'work_business': 'কাজ ও ব্যবসা',

      // Basic Needs
      'utilities': 'ইউটিলিটি',
      'rent_mortgage': 'ভাড়া / বন্ধক',
      'bills_subscriptions': 'বিল ও সাবস্ক্রিপশন',
      'internet_phone': 'ইন্টারনেট ও ফোন',

      // Food & Lifestyle
      'dining_out': 'বাইরে খাওয়া',
      'travel': 'ভ্রমণ',
      'gym_fitness': 'জিম ও ফিটনেস',
      'hobbies': 'শখ',

      // Health & Safety
      'healthcare': 'স্বাস্থ্যসেবা',
      'emergency_fund': 'জরুরী তহবিল',

      // Education & Growth
      'courses_training': 'কোর্স ও প্রশিক্ষণ',
      'books_supplies': 'বই ও সরঞ্জাম',

      // Financial Goals
      'investment': 'বিনিয়োগ',
      'retirement_fund': 'রিটায়ারমেন্ট ফান্ড',
      'loan_repayment': 'লোন পরিশোধ',
      'debt_payment': 'ঋণ পরিশোধ',

      // Family & Home
      'household_supplies': 'গৃহস্থালী সরঞ্জাম',
      'home_maintenance': 'বাড়ি রক্ষণাবেক্ষণ',

      // Work & Business
      'business_expenses': 'ব্যবসায়িক ব্যয়',
      'office_supplies': 'অফিস সরঞ্জাম',
      'freelancing_tools': 'ফ্রিল্যান্সিং টুলস',
      'transportation_work': 'যাতায়াত (কাজ)',

      // Miscellaneous
      'subscriptions_memberships': 'সাবস্ক্রিপশন ও সদস্যতা',
      'events_celebrations': 'ইভেন্ট ও উদযাপন',
      'luxury_wants': 'বিলাসিতা / চাহিদা',
    },


  };
}
