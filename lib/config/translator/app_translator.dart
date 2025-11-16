import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'no_internet_connection': 'No internet connection',
      'connection_timeout': 'Connection timeout',
      "something_went_wrong": "Something went wrong, please try again later.",
      "permission_required": "Permission Required",
      "grant_permission_message":
          "Please grant 'Alarms & reminders' permission.",
      'reportTitle': 'Report',
      'search': 'Super AI search',
      'income': 'Income',
      "home": "Home",
      "report": "Report",
      "budget": "Budget",
      "settings": "Settings",

      "health_fitness": "Health",
      "food_dining": "Food",
      "bills_utilities": "Bills",
      "phone": "Phone",
      "beauty": "Beauty",
      "housing": "Housing",
      "transportation": "Transpor",
      "entertainment": "Entertainment",
      "shopping": "Shopping",
      "groceries": "Groceries",
      "education": "Education",
      "personal": "Personal",
      "investment": "Investment",
      "living_expenses": "Living",
      "marketing_advertising": "Marketing",
      "travel_accommodation": "Travel",
      "office_supplies_equipment": "Office",
      "insurance": "Insurance",
      "subscription_services": "Subscription",
      "fuel_mileage": "Fuel",
      "charity_donations": "Charity",
      "kids": "Kids",
      "repairs": "Repairs",
      "pets": "Pets",
      "sports": "Sports",
      "salary": "Salary",
      "business": "Business",
      "sales_revenue": "Sales",
      "service_income": "Service",
      "freelance_contracts": "Freelance",
      "investment_returns": "Investment Returns",
      "rental_income": "Rental",
      "asset_sales": "Asset",
      "royalties_licensing": "Royalties",
      "interest_dividends": "Profit",
      "side_income": "Side Income",
      "commissions_affiliates": "Commissions",
      "refunds_reimbursements": "Refunds",
      "gifts": "Gifts",
      "grants_subsidies": "Grants",
      "miscellaneous": "Others",

      //-------------------------------Welcome View-------------------------------
      "welcomeViewTitle": "Easy way to\nManage your Money",
      "welcomeViewSubtitle":
          "Organize your spending, plan your savings, and stay stress-free.",
      "welcomeViewButtonOne": "Get Started",
      "welcomeViewButtonTwo": "Preview Demo",

      //-------------------------------Home View-------------------------------
      "expensesTitle": "Expenses",
      "outOfText": "Out of",
      "periodDay": "Day",
      "periodWeek": "Week",
      "periodMonth": "Month",
      "historyTitle": "History",
      "seeAllButton": "See All",
      "noTransactions": "No transactions yet",

      // -------------------------------Report View-------------------------------
      "spent": "Spent",
      "expenses": "Expenses",
      "monthlyBudget": "Monthly Budget",
      "6periods": "Last 6 Periods",
      "within": "Within",
      "risk": "Risk",
      "overspending": "Overspending",
      "balance_summary": "Balance Summary",

      // -------------------------------Category Groups Expense-------------------------------
      'category': 'Categories',

      // Health & Fitness
      'doctor': 'Doctor',
      'medicine': 'Medicine',
      'gym_exercise': 'Gym / Exercise',
      'cycling': 'Cycling',
      'yoga': 'Yoga',

      // Food & Dining
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

      // Education
      'tuition_fees': 'Tuition Fees',
      'courses': 'Courses',
      'stationery': 'Stationery',
      'books_study_materials': 'Books & Study Materials',

      // Family & Personal
      'child_care': 'Child Care',
      'gifts_donations': 'Gifts & Donations',
      'personal_care': 'Personal Care',
      'salon_beauty': 'Salon / Beauty',

      // Investments & Finance
      'savings': 'Savings',
      'loan_emi': 'Loan EMI',
      'taxes': 'Taxes',

      // Miscellaneous
      'emergency': 'Emergency',
      'charity': 'Charity',
      'subscriptions': 'Subscriptions',
      'others': 'Others',

      // -------------------------------Category Groups Income-------------------------------

      // Income Groups
      'primary_income': 'Primary Income',
      'investments': 'Investments',
      'rental_assets': 'Rental & Assets',
      'other_income': 'Other Income',
      'passive_income': 'Passive Income',

      // Primary Income
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
      "totaltransactions": "transactions",
      "totalAmount": "Total Amount",
      "addFirstTransaction": "Add your first transaction to get started",
      "addTransaction": "Add Transaction",

      // -------------------------------Category Card-------------------------------
      "transactionDetails": "Transaction Details",
      "title": "Title",

      // -------------------------------Transaction Form Page -------------------------------
      "titleOptional": "Title",
      "titleRequiredError": "Title is required",
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
      "transactionUpdateMessage": "Transaction updated successfully!",

      "details": "Details:",
      "amount": "Amount",
      "payment": "Payment",
      "date": "Date",
      "notes": "Notes",
      "addAnother": "Add Another",
      "done": "Done",
      "edit": "Edit",
      "save": "Save",

      // Payment Methods
      "cash": "Cash",
      "bankTransfer": "Bank Transfer",
      "creditCard": "Credit Card",
      "debitCard": "Debit Card",
      "mobileWallet": "Mobile Wallet",
      "check": "Check",
      'bkash': "Bkash",
      'nagad': "Nagad",
      'rocket': "Rocket",
      'upay': "Upay",

      // -------------------------------Budget Category-------------------------------
      "budgetOverview": "Budget Overview",
      "noBudgetsYet": "No budgets yet",
      "budgetDeletedSuccess": "Budget Deleted Successfully",

      // -------------------------------Budget Card -------------------------------
      "overspent": "Overspent",
      "over": "Overspent",

      "of": "of",
      "left": "left",
      "overspentMessage":
          "You've exceeded your budget. Consider reducing spending.",
      "budgetLimitWarning":
          "You're close to your budget limit. Spend carefully.",
      "doingGreatMessage": "You're doing great! Keep it up.",
      // -------------------------------Budget Card View-------------------------------
      "allocated": "Allocated",
      "remaining": "Remaining",
      "budgetProgress": "Budget Progress",
      "addCategoryToBudget": "Add Category to Budget",
      "allocatedAmount": "Allocated Amount",
      "total": "Total",

      "categoryAddedSuccess": "Category added successfully!",
      "noCategoriesYet": "No categories yet",
      "addSpent": "Add Spent",
      "addAmount": "Add Amount",
      "amountUpdatedSuccess": "Amount updated successfully!",
      "categoryDeleted": "Category deleted",
      "deleted": "Deleted",

      // -------------------------------Budget Create-------------------------------
      "createBudget": "Create Budget",
      "createNewBudget": "Create New Budget",
      "setSpendingLimits": "Set spending limits and track your expenses",
      "budgetTitle": "Budget Title",
      "budgetTitleHint": "e.g., Monthly Groceries",
      "budgetTitleError": "Please enter a budget title",
      "budgetAmount": "Budget Amount",
      "budgetAmountHint": "0.00",
      "budgetAmountError": "Please enter budget amount",
      "budgetAmountValidError": "Please enter a valid amount",
      "categories": "Categories",
      "selectCategory": "Select a category",
      "pleaseAddCategory": "Please add at least one category",
      "startDate": "Start Date",
      "endDate": "End Date",
      "selectDate": "Select date",
      "startDateError": "Please select start date",
      "endDateError": "End date must be after start date",
      "cancel": "Cancel",
      "createBudgetButton": "Create Budget",
      "addCategory": "Add",
      "categoryAmount": "Amount",
      "delete": "Delete",
      "pleaseSelectCategory": "Please select a category",
      "pleaseEnterValidAmount": "Please enter a valid amount",
      "budgetCreatedSuccess": "Budget created successfully!",
      "dateFormat": "dd/mm/yyyy",

      // Snackbar messages
      "selectStartDate": "Please select a start date",
      "selectEndDate": "Please select an end date",
      "addOneCategory": "Please add at least one category",

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
      "budgetExceeded": "Budget Exceeded",

      // -------------------------------Reminder View -------------------------------
      "reminder": "Reminder",
      "no_reminders_yet": "No Reminders Yet",
      "create_first_reminder": "Create your first reminder to stay on track",
      "add_reminder": "Add Reminder",
      "delete_reminder": "Delete Reminder",
      "confirmation_message": "Are you sure you want to delete this reminder?",
      "reminder_title": "Enter reminder title",
      "description": "description",
      "optional_details": "Add details about this reminder (optional)",
      "schedule": "schedule",
      "update_reminder": "Update Reminder",
      "save_reminder": "Save Reminder",
      "update_success": "Reminder updated successfully",
      "create_success": "Reminder created successfully",
      "save_failed": "Failed to save reminder",
      "time": "Time",
      "edit_reminder": "Edit Reminder",
      "delete_success": "Reminder deleted successfully",
      "reminder_details": "Reminder Details",
      "active": "Active",
      "inactive": "Inactive",
      "scheduled_time": "Scheduled Time",
      "not_set": "Not set",

      // -------------------------------Setting View -------------------------------

      // Settings Page

      // General Settings
      "generalAppSettings": "🔧 General App Settings",
      "appTheme": "App Theme",
      "light": "Light",
      "dark": "Dark",
      "system": "System",
      "appLanguage": "App Language",
      "bangla": "Bangla",
      "english": "English",
      "notifications": "Notifications",
      "notificationsDescription": "Reminders, budget alerts, bill due dates",
      "budgetAlerts": "Budget Alerts",
      "budgetAlertsDescription": "Get notified when approaching budget limits",
      "billReminders": "Bill Reminders",
      "billRemindersDescription": "Notify before bill due dates",
      "logout": "Logout",

      // Finance Settings
      "financeSpecificSettings": "💰 Finance-Specific Settings",
      "defaultAccount": "Default Account",
      "defaultAccountDescription":
          "Choose which wallet/account opens by default",
      "mainWallet": "Main Wallet",
      "automaticTransactionImport": "Automatic Transaction Import",
      "automaticTransactionImportDescription":
          "Sync transactions from bank/CSV files",

      // Privacy & Security
      "privacySecurity": "🔒 Privacy & Security",
      "appLock": "App Lock",
      "appLockDescription": "PIN, fingerprint, or FaceID protection",
      "autoLockTimer": "Auto-Lock Timer",
      "1 minute": "1 minute",
      "5 minutes": "5 minutes",
      "15 minutes": "15 minutes",
      "30 minutes": "30 minutes",
      "never": "Never",
      "clearLocalData": "Clear Local Data",
      "resetApp": "Reset App",
      "exportData": "Export Data",

      // Other Settings
      "otherSettings": "🌐 Other Settings",
      "rateUs": "Rate Us",
      "shareApp": "Share App",
      "contactSupport": "Contact Support",
      "faq": "FAQ",
      "about": "About",
      "feedback": "Feedback",
      "termsPolicies": "Terms & Policies",
      "versionInfo": "Version Info",
      "versionInfoDescription": "Build version and update checker",

      "confirm_delete": "Confirm Delete",
      "delete_category_message":
          "Are you sure you want to delete this category? This action cannot be undone.",

      // ------------------------------- Notification View -------------------------------
      "notificationsTitle": "Notifications",
      "noNotifications": "No notifications yet",
      "weeklyFinancialSummaryTitle": "Weekly Financial Summary",
      "weeklyFinancialSummaryDescription":
          "Here's your weekly financial summary! Take a look at your expenses this week.",
      "monthlyFinancialReportTitle": "Monthly Financial Report",
      "monthlyFinancialReportDescription":
          "Here's your monthly financial report! Review your income and expenses this month.",

      "viewInsights": "View Insights",
      "close": "Close",

      "add_with_ai": "Add with AI",
      "smart_categorization": "Smart Categorization",
      "add_manually": "Add Manually",
      "enter_details": "Enter details yourself",
      "spent_on_food": "Spent On Food",
      "received_salary": "Received Salary",
      "bought_groceries": "Bought Groceries",
      "fuel_expense": "Fuel Expense",
      "input_placeholder": "Type or speak your transaction",
      "input_example": "Example: \"Example: I spent 50 taka on groceries\"",
      "ai_assistant": "AI Assistant",
      "process_with_ai": "Process With AI",
      "empty_field": "Empty Field ⚠️",
      "fields_empty_error": "Fields can’t be empty.",
      "invalid_input": "Invalid Input ❌",
      "invalid_prompt_error":
          "Please enter a valid transaction prompt (e.g., \"Paid 500 for food\").",
      "ai_suggestions": "AI Suggestions",
      "no_transactions_detected": "No transactions were detected in the input.",

      "speech_not_available":
          "Speech recognition not available on this device.",
      "speech_error": "Speech error:",
      "speech_init_failed": "Speech initialization failed",
    },
    'bn_BD': {
      'no_internet_connection': 'ইন্টারনেট সংযোগ নেই',
      'connection_timeout': 'সংযোগ সময়সীমা শেষ',
      "something_went_wrong":
          "কিছু সমস্যা হয়েছে, দয়া করে পরে আবার চেষ্টা করুন।",
      'reportTitle': 'রিপোর্ট',
      'search': 'অনুসন্ধান করুন',
      'income': 'আয়',
      "home": "হোম",
      "report": "রিপোর্ট",
      "budget": "বাজেট",
      "settings": "সেটিংস",
      "health_fitness": "স্বাস্থ্য",
      "food_dining": "খাবার",
      "bills_utilities": "বিল",
      "phone": "ফোন",
      "beauty": "বিউটি",
      "housing": "বাসা",
      "transportation": "যাতায়াত",
      "entertainment": "বিনোদন",
      "shopping": "কেনাকাটা",
      "groceries": "গ্রোসারি",
      "education": "শিক্ষা",
      "personal": "ব্যক্তিগত",
      "investment": "বিনিয়োগ",
      "living_expenses": "জীবনযাপন",
      "marketing_advertising": "বিজ্ঞাপন",
      "travel_accommodation": "ভ্রমণ",
      "office_supplies_equipment": "অফিস",
      "insurance": "বীমা",
      "subscription_services": "সাবস্ক্রিপশন",
      "fuel_mileage": "জ্বালানি",
      "charity_donations": "দান",
      "kids": "শিশু",
      "repairs": "মেরামত",
      "pets": "পোষা",
      "sports": "খেলাধুলা",
      "salary": "বেতন",
      "business": "ব্যবসা",
      "sales_revenue": "বিক্রয়",
      "service_income": "সেবা",
      "freelance_contracts": "ফ্রিল্যান্স",
      "investment_returns": "লভ্যাংশ",
      "rental_income": "ভাড়া",
      "asset_sales": "সম্পদ",
      "royalties_licensing": "রয়্যালটি",
      "interest_dividends": "মুনাফা",
      "side_income": "অতিরিক্ত",
      "commissions_affiliates": "কমিশন",
      "refunds_reimbursements": "রিফান্ড",
      "gifts": "উপহার",
      "grants_subsidies": "অনুদান",
      "miscellaneous": "অন্যান্য",
      //-------------------------------Welcome View-------------------------------
      "welcomeViewTitle": "সহজে টাকার ব্যবস্থাপনা",
      "welcomeViewSubtitle":
          "খরচ গুছিয়ে রাখুন, সঞ্চয়ের পরিকল্পনা করুন আর নিশ্চিন্তে থাকুন।",
      "welcomeViewButtonOne": "শুরু করুন",
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
      "within": "মধ্যে",
      "risk": "ঝুঁকি",
      "overspending": "বাজেট ছাড়ানো",
      "balance_summary": "হিসাবের সারসংক্ষেপ",

      // ------------------------------- Category Groups Expense-------------------------------
      'category': 'ক্যাটাগরি',
      'family_personal': 'পরিবার ও ব্যক্তিগত',
      'investments_finance': 'বিনিয়োগ ও অর্থ',

      // Health & Fitness
      'doctor': 'ডাক্তার',
      'medicine': 'ঔষধ',
      'gym_exercise': 'জিম / ব্যায়াম',
      'cycling': 'সাইক্লিং',
      'yoga': 'যোগব্যায়াম',

      // Food & Dining
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

      // Education
      'tuition_fees': 'টিউশন ফি',
      'courses': 'কোর্স',
      'stationery': 'স্টেশনারি',
      'books_study_materials': 'বই ও পড়ার সামগ্রী',

      // Family & Personal
      'child_care': 'শিশু যত্ন',
      'gifts_donations': 'উপহার ও দান',
      'personal_care': 'ব্যক্তিগত যত্ন',
      'salon_beauty': 'সেলুন / বিউটি',

      // Investments & Finance
      'savings': 'সঞ্চয়',
      'loan_emi': 'লোন ইএমআই',
      'taxes': 'ট্যাক্স',

      // Miscellaneous
      'emergency': 'জরুরী',
      'charity': 'দান',
      'subscriptions': 'সাবস্ক্রিপশন',
      'others': 'অন্যান্য',

      // -------------------------------Category Groups Income-------------------------------
      // Income Groups
      'primary_income': 'প্রাথমিক আয়',
      'investments': 'বিনিয়োগ',
      'rental_assets': 'ভাড়া ও সম্পদ',
      'other_income': 'অন্যান্য আয়',
      'passive_income': 'প্যাসিভ ইনকাম',

      // Primary Income
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
      "totaltransactions": "টি লেনদেন",
      "totalAmount": "মোট টাকা",
      "addFirstTransaction": "প্রথম লেনদেন যোগ করুন",
      "addTransaction": "ট্রানজেকশন যোগ করুন",

      // -------------------------------Category Card-------------------------------
      "title": "শিরোনাম",
      "transactionDetails": "লেনদেনের বিবরণ",

      // ------------------------------- Transaction Form Page -------------------------------
      "titleOptional": "শিরোনাম",
      "titleRequiredError": "শিরোনাম আবশ্যক",
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
      "transactionUpdateMessage": "লেনদেন সফলভাবে আপডেট করা হয়েছে",
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
      "check": "চেক",
      'bkash': "বিকাশ",
      'nagad': "নগদ",
      'rocket': "রকেট",
      'upay': "উপায়",

      // -------------------------------Budget OverView-------------------------------
      "budgetOverview": "বাজেটের সারসংক্ষেপ",
      "noBudgetsYet": "এখনও কোনো বাজেট নেই",
      "budgetDeletedSuccess": "বাজেট সফলভাবে মুছে ফেলা হয়েছে",

      // -------------------------------Budget Card -------------------------------
      "of": "এর",
      "left": "বাকি",
      "over": "অতিরিক্ত",
      "overspent": "অতিরিক্ত খরচ",
      "overspentMessage":
          "আপনি আপনার বাজেট ছাড়িয়ে গেছেন। খরচ কমানোর কথা বিবেচনা করুন।",
      "budgetLimitWarning": "আপনার বাজেট প্রায় শেষ। খরচে একটু সতর্ক থাকুন।",
      "doingGreatMessage": "চমৎকার করছেন! এভাবেই চালিয়ে যান।",
      // -------------------------------Budget Card View -------------------------------
      "allocated": "বরাদ্দকৃত",
      "remaining": "অবশিষ্ট",
      "budgetProgress": "বাজেট অগ্রগতি",
      "addCategoryToBudget": "বাজেটে ক্যাটাগরি যোগ করুন",
      "allocatedAmount": "বরাদ্দকৃত টাকা",
      "total": "বরাদ্দকৃত",

      "categoryAddedSuccess": "ক্যাটাগরি সফলভাবে যোগ করা হয়েছে!",
      "noCategoriesYet": "এখনও কোন ক্যাটাগরি নেই",
      "addSpent": "খরচ যোগ করুন",
      "addAmount": "টাকা যোগ করুন",
      "amountUpdatedSuccess": "টাকা সফলভাবে আপডেট করা হয়েছে!",
      "categoryDeleted": "ক্যাটাগরি মুছে ফেলা হয়েছে",
      "deleted": "মুছে ফেলা হয়েছে",

      // -------------------------------Budget Create -------------------------------
      "createBudget": "বাজেট তৈরি করুন",
      "createNewBudget": "নতুন বাজেট তৈরি করুন",
      "setSpendingLimits":
          "খরচের সীমা নির্ধারণ করুন এবং আপনার ব্যয় ট্র্যাক করুন",
      "budgetTitle": "বাজেটের শিরোনাম",
      "budgetTitleHint": "যেমন, মাসিক বাজার খরচ",
      "budgetTitleError": "বাজেটের শিরোনাম লিখুন",
      "budgetAmount": "বাজেটের টাকা",
      "budgetAmountHint": "০.০০",
      "budgetAmountError": "বাজেটের টাকার পরিমাণ লিখুন",
      "budgetAmountValidError": "সঠিক টাকার পরিমাণ লিখুন",
      "categories": "ক্যাটাগরি সমূহ",
      "selectCategory": "একটি ক্যাটাগরি নির্বাচন করুন",
      "pleaseAddCategory": "অন্তত একটি ক্যাটাগরি যোগ করুন",
      "startDate": "শুরুর তারিখ",
      "endDate": "শেষের তারিখ",
      "selectDate": "তারিখ নির্বাচন করুন",
      "startDateError": "শুরুর তারিখ নির্বাচন করুন",
      "endDateError": "শেষের তারিখ শুরুর তারিখের পরে হতে হবে",
      "cancel": "বাতিল",
      "createBudgetButton": "বাজেট তৈরি করুন",
      "addCategory": "যোগ করুন",
      "categoryAmount": "টাকা",
      "delete": "মুছুন",
      "pleaseSelectCategory": "একটি ক্যাটাগরি নির্বাচন করুন",
      "pleaseEnterValidAmount": "সঠিক টাকার পরিমাণ লিখুন",
      "budgetCreatedSuccess": "বাজেট তৈরি হয়েছে সফলভাবে!",
      "dateFormat": "দিন/মাস/বছর",

      // Snackbar messages
      "selectStartDate": "শুরুর তারিখ নির্বাচন করুন",
      "selectEndDate": "শেষের তারিখ নির্বাচন করুন",
      "addOneCategory": "অন্তত একটি ক্যাটাগরি যোগ করুন",

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
      "budgetExceeded": "বাজেট ছাড়িয়ে গেছে",

      // -------------------------------Reminder View -------------------------------
      "reminder": "রিমাইন্ডার",
      "no_reminders_yet": "এখনও কোনো রিমাইন্ডার নেই",
      "create_first_reminder": "প্রথম রিমাইন্ডারটি তৈরি করুন",
      "add_reminder": "রিমাইন্ডার তৈরি করুন",
      "delete_reminder": "রিমাইন্ডার মুছুন",
      "confirmation_message":
          "আপনি কি নিশ্চিত, এই রিমাইন্ডারটি মুছে ফেলতে চান?",
      "reminder_title": "রিমাইন্ডারের শিরোনাম লিখুন",
      "description": "বিবরণ",
      "optional_details": "রিমাইন্ডার সম্পর্কে বিস্তারিত লিখুন (ঐচ্ছিক)",
      "schedule": "সময়সূচী",
      "update_reminder": "রিমাইন্ডার আপডেট করুন",
      "save_reminder": "রিমাইন্ডার সংরক্ষণ করুন",
      "update_success": "রিমাইন্ডার সফলভাবে আপডেট করা হয়েছে",
      "create_success": "রিমাইন্ডার সফলভাবে তৈরি করা হয়েছে",
      "save_failed": "রিমাইন্ডার সংরক্ষণ করতে ব্যর্থ",
      "time": "সময়",
      "edit_reminder": "রিমাইন্ডার সম্পাদনা করুন",
      "delete_success": "রিমাইন্ডার সফলভাবে মুছে ফেলা হয়েছে",
      "reminder_details": "রিমাইন্ডার বিবরণ",
      "active": "সক্রিয়",
      "inactive": "নিষ্ক্রিয়",
      "scheduled_time": "নির্ধারিত সময়",
      "not_set": "সেট করা নেই",

      // ------------------------------- Setting View -------------------------------
      "appTheme": "থিম",
      "appLanguage": "অ্যাপ ভাষা",
      "notifications": "নোটিফিকেশন",
      "logout": "লগআউট",
      "resetApp": "রিসেট",
      "shareApp": "শেয়ার",
      "contactSupport": "সাপোর্ট",
      "faq": "প্রশ্নোত্তর",
      "about": "সম্পর্কে",
      "feedback": "ফিডব্যাক",
      "termsPolicies": "শর্তাবলী",
      "confirm_delete": "আপনি কি মুছে ফেলতে চান?",
      "delete_category_message":
          "আপনি কি নিশ্চিত এই ক্যাটাগরিটি মুছে ফেলতে চান? মুছে ফেললে আর ফিরে পাওয়া যাবে না।",

      // ------------------------------- Notification View -------------------------------
      "notificationsTitle": "নোটিফিকেশন",
      "noNotifications": "কোনো নোটিফিকেশন নেই",
      "weeklyFinancialSummaryTitle": "সাপ্তাহিক আর্থিক সারাংশ",
      "weeklyFinancialSummaryDescription": "এই সপ্তাহের খরচের সারাংশ দেখে নিন!",
      "monthlyFinancialReportTitle": "মাসিক আর্থিক রিপোর্ট",
      "monthlyFinancialReportDescription": "গত মাসের আয়-খরচ এক নজরে দেখে নিন!",
      "viewInsights": "বিস্তারিত দেখুন",
      "close": "বন্ধ",

      "add_with_ai": "AI দিয়ে যোগ করুন",
      "smart_categorization": "স্মার্ট শ্রেণীবিন্যাস",
      "add_manually": "ম্যানুয়ালি যোগ করুন",
      "enter_details": "বিবরণ নিজে লিখুন",
      "spent_on_food": "খাবারের খরচ",
      "received_salary": "বেতন পেয়েছি ",
      "bought_groceries": "কেনাকাটা করেছি",
      "fuel_expense": "জ্বালানির খরচ",
      "ai_assistant": "AI সহায়ক",
      "process_with_ai": "AI দিয়ে প্রক্রিয়া করুন",
      "input_placeholder": "আপনার লেনদেন লিখুন অথবা বলুন",
      "input_example": "উদাহরণ: \"আমি আজ ২৭০ টাকায় বিরিয়ানি খেয়েছি।",
      "empty_field": "ফাঁকা ফিল্ড ⚠️",
      "fields_empty_error": "ফিল্ডগুলি ফাঁকা রাখা যাবে না।",
      "invalid_input": "ইনভ্যালিড ইনপুট ❌",
      "invalid_prompt_error":
          "দয়া করে একটি বৈধ লেনদেন প্রম্পট লিখুন (যেমন: \"খাবারের জন্য ৫০০ টাকা দিলাম\")",
      "edit": "এডিট",
      "save": "সংরক্ষণ",
      "ai_suggestions": "AI সাজেশন",
      "no_transactions_detected": "কোনো লেনদেন সনাক্ত করা যায়নি।",
      "speech_not_available": "এই ডিভাইসে স্পিচ রিকগনিশন উপলব্ধ নেই।",
      "speech_error": "স্পিচ ত্রুটি:",
      "speech_init_failed": "স্পিচ ইনিশিয়ালাইজেশন ব্যর্থ হয়েছে",
      "permission_required": "অনুমতি প্রয়োজন",
      "grant_permission_message":
          "দয়া করে 'অ্যালার্ম ও রিমাইন্ডার' অনুমতি প্রদান করুন।",
    },
  };
}
