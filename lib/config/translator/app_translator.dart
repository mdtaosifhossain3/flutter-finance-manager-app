import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      "chargeOntimeText": "One-time charge: ৳2 (incl. VAT, SD & SC)",
      "check_sms_title": "Check SMS",
      "check_sms_desc":
          "You have successfully subscribed. Please wait for the confirmation.",
      "yes": "Yes",
      "no": "No",
      "coming_soon_title": "Coming Soon",
      "coming_soon_desc":
          "This payment method will be available soon. Please stay with us.",
      "enter_mobile_title": "Enter Mobile Number",
      "enter_mobile_desc": "Only Robi (018) and Airtel (016) numbers",
      "more": "More",
      "login": "Login",
      "register": "Register",
      "email": "Email",
      "password": "Password",
      "forget_password": "Forgot Password?",
      "reset_password": "Reset Password",
      "continue_google": "Continue with Google",
      "continue": "Continue",
      "create_account": "Create Account",
      "name": "Name",
      "send_reset_link": "Send reset link",
      "feedbackTitle": "We would love to hear your thoughts!",

      "feedbackLabel": "Your Feedback",

      "feedbackHint": "Please enter feedback",

      "feedbackSubmit": "Submit",

      "feedbackSuccess": "Thank you for your feedback!",
      "aboutbody":
          "Hishab Rakhi is a smart and modern money management app designed "
          "specifically for Bangladeshi users. It helps you track daily expenses, "
          "add income, plan budgets, view detailed financial reports, set reminders, "
          "and improve your savings habits with AI-powered assistance.\n\n"
          "Hishab Rakhi is built with a focus on simplicity, privacy, and accuracy, "
          "ensuring users can manage their finances without any hassle.\n\n"
          "This app is proudly developed by MD Taosif Hossain and powered by "
          "Fluttbiz IT Solutions.",

      "dev": "Developer: MD Taosif Hossain",
      "companyName": "Company: Fluttbiz IT Solutions",
      "q1": "How does Hishab Rakhi work?",
      "a1":
          "You can add expenses, income, budgets, and track detailed reports easily.",

      "q2": "Is my data safe?",
      "a2": "Yes, your data is securely stored and never shared with anyone.",

      "q3": "Is Hishab Rakhi free?",
      "a3": "Yes, Hishab Rakhi is free with optional Pro features.",

      "q4": "What is Hishab Rakhi Pro?",
      "a4":
          "Hishab Rakhi Pro unlocks advanced features like unlimited AI taps and premium tools.",

      "q5": "Can I track both income and expenses?",
      "a5":
          "Yes, the app allows complete tracking of expenses, income, and reports.",

      "q6": "Does Hishab Rakhi support Bangla?",
      "a6": "Yes, the app fully supports the Bangla language.",

      "q7": "How does the AI help?",
      "a7":
          "AI can understand Bangla/English and automatically generate transactions for you.",

      "q8": "Can I backup my data?",
      "a8": "Yes, you can store cloud backups to keep your data safe.",

      "q9": "Does the app send reminders?",
      "a9":
          "Yes, you can set daily reminders for budgets, reports, and money tips.",

      "q10": "How can I contact support?",
      "a10": "You can contact us via email or Messenger from the Support page.",

      "more_ai": "Get More AI Credits?",
      "endedai": "Your free AI credits have ended.",
      "30days": "Unlimited AI Credits for 30 Days",
      "buy": "Buy Now",
      "cancelBuy": "Cancel",
      'transaction_detected': 'Transaction Detected',
      'items_found': 'item(s) found',
      'try_different_input': 'Try describing your transaction differently',
      'today': 'Today',
      'yesterday': 'Yesterday',
      'ai_assistant_title': 'AI Money Assistant',
      'ai_assistant_subtitle':
          'Describe your transaction naturally, and I\'ll help organize it',
      'try_examples': 'Try these examples',
      'spent_50_groceries': 'Spent 500 on groceries',
      'lunch_25_today': 'Lunch 250 today',
      'fuel_40_yesterday': 'Fuel Expense 180 tk yesterday',
      'ai_tip': 'Include amount, category, and date for best results',
      'analyzing_transaction': 'Analyzing Transaction',
      'please_wait': 'Please wait a moment...',
      'processing': 'Processing...',
      'input_placeholder_detailed': 'Example: "Spent 50 on groceries"',
      'proceed': 'Proceed',
      'preferences': 'Preferences',
      'manage_app_settings':
          'Manage your app settings to match your style and needs',
      'no_internet_connection': 'No internet connection',
      'connection_timeout': 'Connection timeout',
      "something_went_wrong": "Something went wrong, please try again later.",
      "permission_required": "Permission Required",
      "grant_permission_message":
          "Please grant 'Alarms & reminders' permission.",
      'reportTitle': 'Report',
      'search': 'Super AI search',
      'income': 'Income',
      'pro_features': 'Pro Features',
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
      "transportation": "Transport",
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
      "miscellaneous_expense": "Others",
      "miscellaneous_income": "Other Income",

      // ------------------------------- Auth & Settings New Keys -------------------------------
      'pro_user': 'Pro User',
      'free_user': 'Free User',
      'guest_user': 'Guest User',
      'no_email_linked': 'No email linked',
      'pro_button': 'Pro',
      'light_theme': 'Light',
      'dark_theme': 'Dark',
      'system_theme': 'System',
      'english_lang': 'English',
      'bangla_lang': 'Bangla',
      'logout_confirmation': 'Are you sure you want to logout?',
      'welcome_back': 'Welcome Back',
      'sign_in_continue': 'Sign in to continue',
      'enter_email_error': 'Please enter your email',
      'valid_email_error': 'Please enter a valid email',
      'enter_password_error': 'Please enter your password',
      'password_length_error': 'Password must be at least 6 characters',
      'sign_in_google': 'Sign in with Google',
      'no_account': "Don't have an account? ",
      'sign_up_button': 'Sign Up',
      'sign_up_started': 'Sign up to get started',
      'enter_name_error': 'Please enter your name',
      'sign_up_google': 'Sign up with Google',
      'already_have_account': 'Already have an account? ',
      'reset_password_desc':
          'Enter your email to receive a password reset link',
      'logged_in_success': 'Logged in successfully',
      'registered_success': 'Registered successfully',
      'password_reset_sent':
          'Reset password link sent to your email. Check inbox or spam.',
      'google_login_success': 'Logged in with Google successfully',
      'logged_out_success': 'Logged out successfully',
      'account_deleted_title': 'Account Deleted',
      'account_deleted_msg':
          'Your account and data have been permanently deleted.',
      'security_check_title': 'Security Check',
      'relogin_delete_msg': 'Please log in again to delete your account.',
      'error_title': 'Error',
      'unknown_error': 'An unknown error occurred',
      'user_not_found': 'No user found for that email.',
      'wrong_password': 'Wrong password provided for that user.',
      'email_in_use': 'The account already exists for that email.',
      'weak_password': 'The password provided is too weak.',
      'operation_not_allowed': 'Operation not allowed. Please contact support.',
      'network_error': 'Network error. Please check your connection.',
      'too_many_requests': 'Too many requests. Try again later.',
      'invalid_credential': 'Invalid email or password.',
      'invalid_credential_session': 'Invalid credentials or session expired.',
      'auth_failed': 'Authentication failed.',
      'google_sign_in_failed': 'Google Sign-In failed: ',
      'plan_expired': 'Plan Expired',
      'reset_delete_options': 'Reset/Delete',
      'reset_delete_description': 'Manage your app data and account settings.',
      'reset_app_data': 'Reset App Data',
      'reset_app_data_desc':
          'Clear all local data (transactions, budgets, etc.) without deleting your account.',
      'delete_account': 'Delete Account',
      'delete_account_desc':
          'Permanently delete your account and all associated data.',
      'reset_app_data_confirmation':
          'Are you sure you want to reset app data? This will delete all local transactions and budgets. This action cannot be undone.',
      'delete_account_confirmation':
          'Are you sure you want to delete your account? This will permanently delete your account and all data from the cloud and local storage. This action cannot be undone.',
      'app_data_reset_success': 'App data reset successfully.',
      'reset': 'Reset',
      'delete': 'Delete',

      // ------------------------------- Pricing View -------------------------------
      'check_out': 'Check Out',
      'manage_plan': 'Manage Plan',
      'choose_pricing_plan': 'Choose Your Pricing Plan',
      'set_reminder': 'Set Reminder',
      'monthly_weekly_reports': 'Monthly/Weekly Reports',
      'reports': 'Reports',
      'set_budget': 'Set Budget',
      'no_ads': 'No Ads',
      'starter_plan': 'Starter Plan',
      'smart_plan': 'Smart Plan',
      'pro_plan': 'Pro Plan',
      'ultimate_plan': 'Ultimate Plan',
      '900_credits': '900 AI Credits',
      '2700_credits': '2700 AI Credits',
      '2700_credits_pro': '2700 AI Credit',
      '5500_credits_pro': '5500 AI Credits',
      '11000_credits': '11000 AI Credits',
      '27000_credits': '27000 AI Credits',
      'monthly': 'monthly',
      '3_months': '3 month',
      '6_months': '6 month',
      'credits_left': 'Credits Left',
      'no_credits': 'No Credits Left',
      'buy_now': 'Buy Now',
      '500_credits_for_30tk': '60 Credits for ৳30',
      'purchase_credits_title': 'Purchase AI Credits',
      'purchase_credits_desc': 'Get 60 AI credits for only ৳30',
      'purchase_plan_msg':
          'Please purchase a plan to continue using AI features.',
      'or_continue_with': 'Or continue with',
      'enter_email': 'Enter your email',
      'enter_password': 'Enter your password',
      'whatsapp_error': 'Could not open WhatsApp. Please try again.',
      'feedback_footer': 'We value your feedback to improve our app.',
      '1_year': '1 year',
      'choose_plan': 'Choose Plan',
      'payment_success': 'Payment Success',
      'payment_success_message':
          'Thank you for your purchase! Your plan has been activated successfully.',
      'number_verified_title': 'Number Verified Successfully 🎉',
      'subscribe_instruction': 'Now subscribe to your preferred plan',
      'purchase_now_button': 'Purchase Now',
      'subscription_success_msg': 'Subscription Successful!',
      'data_backup': 'Data Backup',
      'unlimited_ai_credits': 'Unlimited AI Credits',
      'premium_support': 'Premium Support',
      'go_premium': 'Go Premium',
      'unlock_all_features':
          'Unlock all features and supercharge your experience',
      'cancel_anytime': 'Cancel anytime • Secure payment',
      'select_subscription': 'Select Subscription',
      'choose_best_plan': 'Choose the plan that works best for you',
      'daily_plan': 'Daily Plan',
      'monthly_plan': 'Monthly Plan',
      'per_day': 'per day',
      'per_month': 'per month',
      'all_premium_features': 'All Premium Features',
      'renews_daily': 'Renews Daily',
      'cancel_anytime_short': 'Cancel Anytime',
      'save_34_percent': 'Save 67% vs Daily',
      'best_value': 'Best Value',
      'flexible': 'FLEXIBLE',
      'most_popular': 'MOST POPULAR',
      'continue_with': 'Continue with',
      'powered_by_bdapps': 'Powered by BDApps • Secure Payment',
      'all_plans_include': 'All Plans Include',
      'ai_credits': 'AI Credits',
      'advanced_reports': 'Advanced Reports',
      'unsubscribe': 'Unsubscribe (Pro Plan)',
      'unsubscribe_confirmation': 'Are you sure you want to unsubscribe?',
      'unsubscribe_success': 'Unsubscribed successfully',
      'buy_more_ai_credits_plan': 'AI credits plan',
      'not_subscribed_error': 'You are not subscribed to the service',
      'already_subscribed': 'This number is already subscribed',

      // ------------------------------- OTP Views -------------------------------
      'registration': 'Registration',
      'mobile_verification': 'Mobile Number Verification',
      'enter_phone_number_desc': 'Please enter your phone number to register',
      'enter_phone_hint': 'Enter Robi/Airtel number...',
      'please_enter_number': 'Please enter number',
      'number_must_be_11_digits': 'Number must be 11 digits',
      'enter_valid_bd_number': 'Enter valid Bangladeshi number (01...)',
      'send_code': 'Send Code',
      'otp_will_be_sent': 'An OTP code will be sent to verify your number.',
      'account_activation': 'Account Activation',
      'enter_otp_desc': 'Please enter the OTP code to activate your account',
      'enter_otp_hint': 'Enter OTP...',
      'please_enter_otp': 'Please enter OTP',
      'otp_must_be_6_digits': 'OTP must be 6 digits',
      'verify_number': 'Verify Number',
      'retry_otp_desc':
          'If you don\'t receive OTP, try again after a few seconds.',

      // ------------------------------- Balance Check Dialog -------------------------------
      'balance_check_title': 'Check Balance',
      'balance_check_message':
          'Please make sure you have enough balance in your account before proceeding.',

      // ------------------------------- SMS Confirmation Dialog -------------------------------
      'subscription_initiated_title': 'Subscription Initiated',
      'subscription_initiated_desc':
          'Successfully subscribed. Please wait for the confirmation SMS.',
      'okay': 'Okay',
      'sms_confirmation_title': 'SMS Confirmation',
      'sms_confirmation_message':
          'Please wait while we confirm your subscription via SMS.',
      'seconds': 'seconds',

      //-------------------------------Welcome View-------------------------------
      "welcomeViewTitle": "Easy way to\nManage your Money",
      "welcomeViewSubtitle":
          "Organize your spending, plan your savings, and stay stress-free.",
      "welcomeViewButtonOne": "Get Started",
      "welcomeViewButtonTwo": "Preview Demo",
      "preview": "Preview",
      "viewMore": "View More",

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
      'my_salary': 'Salary 12000 tk',

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
      "recentActivity": "Recent Activity",

      // -------------------------------Category Card-------------------------------
      "transactionDetails": "Transaction Details",
      "title": "Title",
      "warningTitleTransacton": "Overspending Alert",
      "warningDescTransacton":
          "You just added an expense that exceeds your income.",
      "expense": "Expense",

      // -------------------------------Transaction Form Page -------------------------------
      "titleOptional": "Title (Optional)",
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
      "resetDescription":
          "Reset completed successfully. All of your data has been deleted from the system",

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
      "daily_budget_limit_title": "Daily Budget Limit",
      "budget_exceeded_title": "Budget Exceeded!",
      "budget_exceeded_message": "You have exceeded your budget for",
      "review_transactions_title": "Review Your Transactions",
      "review_transactions_message":
          "Take a moment to review today's transactions and ensure everything is tracked!",
      "include_in_total_income": "Include in total income",
      "enbudget_expired_title": "Budget Expired",
      "label_days": "Days",
      "label_expired": "Expired",
      "label_days_left": "Days Left",
      "label_status": "Status",
      "label_daily_limit": "Daily Limit",
      "daily_spend_advice_one": "You can spend up to ৳",
      "daily_spend_advice_two": "today to stay on track.",
      "budget_exceeded_message_start": "You ",
      "budget_exceeded_message_end": "have exceeded your budget for",
      "budget_expired_message_start": "Your budget period for",
      "budget_expired_message_end": "has ended.",
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
      "edit_record": "Edit Record",
      "given_taken_report": "Given-Taken Report",
      "share": "Share",
      "download": "Download",
      "given_taken_summary": "Given-Taken Summary",
      "get": "Get",
      "pay": "Pay",

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
      "appearance": "Appearance",

      "confirm_delete": "Confirm Delete",
      "delete_category_message":
          "Are you sure you want to delete this category? This action cannot be undone.",
      "reset_confirmation_title": "Reset App?",
      "reset_confirmation_message":
          "Are you sure you want to reset? This will delete all your transactions and data. This action cannot be undone.",

      // ------------------------------- Notification View -------------------------------
      "notificationsTitle": "Notifications",
      "noNotifications": "No notifications yet",
      "weeklyFinancialSummaryTitle": "Weekly Financial Summary",
      "weeklyFinancialSummaryDescription":
          "Here's your weekly financial summary! Take a look at your expenses this week.",
      "monthlyFinancialReportTitle": "Monthly Financial Report",
      "monthlyFinancialReportDescription":
          "Here's your monthly financial report! Review your income and expenses this month.",

      "notification_settings": "Notification Settings",
      "all_notifications": "All Notifications",
      "all_notifications_desc": "Enable or disable all app notifications",
      "notification_types": "Notification Types",
      "daily_finance_tip_desc":
          "Get daily tips to improve your financial health",
      "daily_transaction_review": "Daily Transaction Review",
      "daily_transaction_review_desc":
          "Reminder to review your daily transactions",
      "budget_alerts_desc": "Get notified when you exceed your budget limits",
      "budget_alerts": "Budget Alerts",

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
      "input_placeholder": "Type your transaction",
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
      "save_today_for_tomorrow":
          "Save a little today — it becomes a lot tomorrow.",
      "skip_unnecessary_purchase":
          "Skip one unnecessary purchase today, save the difference!",
      "saving_is_a_habit": "Saving is a habit, not a number. Start small.",
      "daily_savings_goal": "Set a daily savings goal — even 10 taka counts.",
      "future_emergency_savings":
          "Future emergencies are solved by today’s savings.",
      "pay_yourself_first": "Pay yourself first — save before you spend.",
      "save_five_percent_challenge":
          "Challenge: Save at least 5% of today’s income!",
      "review_savings_goal": "Review your savings goal — adjust if needed.",
      "track_spending_daily":
          "Saving is easier when spending is tracked. Don’t forget today’s entries!",
      "budget_limit_check":
          "Check your budget — are you still within limits today?",
      "daily_budget_check": "A daily budget check keeps money stress away.",
      "plan_todays_spending": "Plan today’s spending before you spend.",
      "update_categories":
          "Update your categories — budget smarter, not harder.",
      "delay_if_not_in_budget": "If it's not in the budget, delay it.",
      "budget_is_roadmap": "Your budget is your roadmap — follow it daily.",
      "review_last_week_expenses":
          "Revisit last week's expenses — any mistakes to fix?",
      "think_before_buying":
          "Think twice before buying — do you really need it?",
      "avoid_emotional_spending":
          "Avoid emotional spending — give it 10 minutes before buying.",
      "compare_prices":
          "Compare prices before every purchase. Saves more than you think.",
      "shopping_list_reminder":
          "Carry a list when shopping — avoid impulse buys!",
      "track_all_income": "Track all income — big or small.",
      "invest_in_yourself":
          "Skill development pays back with interest — invest in yourself.",
      "extra_income_acceleration":
          "Every extra taka you earn accelerates your goals!",
      "save_extra_income": "Save at least 20% of extra income.",
      "use_bonuses_wisely":
          "Use bonuses wisely — save or invest, don’t blow it.",
      "daily_financial_habit":
          "Financial success is a daily habit — stay consistent.",
      "avoid_tracking_delay":
          "Don’t delay — small tracking delays lead to big mistakes.",
      "review_monthly_goals":
          "Review your monthly goals — progress starts today.",
      "consistency_is_superpower":
          "Consistency is your superpower — stay on track!",

      "daily_finance_tip": "Daily Finance Tips",
      "support": "Support",
      'failed_to_fetch_data': 'Failed to fetch data',
      'no_content_in_response': 'No content in response',
      'failed_to_parse_response': 'Failed to parse response',
      'ai_request_failed': 'AI request failed',

      // ------------------------------- Pro Feature -------------------------------
      'premium': 'Premium',
      'premium_required': 'Premium Required',
      'premium_required_message':
          'Upgrade to Pro to continue using this feature.',
      'free_trial_ended': 'Your free trial has ended.',
      'buy_pro': 'Buy Pro',
      'later': 'Later',
      'trial_active': 'Trial Active',
      'days_left': 'Days Left',
      '20_days_trial': '20 Days Free Trial',
      'pro_active': 'Pro Active',
      'lifetime': 'Lifetime',
      "repeat_daily": "Repeat Daily",
      "given_taken": "Given–Taken",
      "transaction_type": "Transaction Type",
      "features": "Features",
      "you_will_get": "You Will Get",
      "you_need_to_pay": "You Need to Pay",
      "given": "Given",
      "taken": "Taken",
      "no_contacts_yet": "No contacts yet",
      "add_person_to_track": "Add a person to track lending",
      "add_person": "Add Person",
      "edit_person": "Edit Person",
      "delete_person": "Delete Person",
      "person_name": "Person Name",
      "phone_number": "Phone Number",
      "address": "Address",
      "initial_amount": "Initial Amount",
      "net_balance": "Net Balance",
      "transactions_history": "Transactions History",
      "records": "Records",
      "add_record": "Add Record",
      "settle_up": "Settle Up",
      "mark_as_settled": "Mark as Settled",
      "confirm_delete_person":
          "Are you sure you want to delete this person and all their transactions?",
      "confirm_delete_transaction":
          "Are you sure you want to delete this transaction?",
      "delete_transaction": "Delete Transaction",
      "amount_required": "Amount is required",
      "enter_valid_amount": "Please enter a valid amount",
      "name_required": "Name is required",
      "enter_name": "Please enter a name",
      "enter_phone_number": "Enter phone number (optional)",
      "enter_address": "Enter address (optional)",
      "enter_note": "Enter note (optional)",
      "transaction_added": "Transaction added successfully",
      "transaction_updated": "Transaction updated successfully",
      "transaction_deleted": "Transaction deleted successfully",
      "person_deleted": "Person deleted successfully",
      "person_added": "Person added successfully",
      "person_updated": "Person updated successfully",
      "success": "Success",
      "settled_successfully": "Settled successfully",
      "confirm_settle_up": "Are you sure you want to settle the full balance?",
      "error": "Error",
      "failed_to_load_transactions": "Failed to load transactions",
      "failed_to_save_contact": "Failed to save contact",
      "failed_to_save_transaction": "Failed to save transaction",
      "failed_to_settle_up": "Failed to settle up",
      "connect_internet_to_buy":
          "Please connect to the internet to purchase a plan.",

      // App Lock Translations
      'unlock_your_app': 'Unlock Your App',
      'use_biometric_or_pin': 'Use your biometric or PIN',
      'authenticating': 'Authenticating...',
      'authenticate_to_unlock': 'Authenticate to unlock Hisab Rakhi',
      'device_check_failed': 'Device check failed',
      'biometric_check_failed': 'Biometric check failed',
      'authentication_failed': 'Authentication failed',
      'biometric_hardware_not_available':
          'Biometric hardware not available on this device',
      'no_biometric_enrolled':
          'No fingerprint / face enrolled in device settings',
      'locked_out': 'Too many attempts. Try again later',
      'permanently_locked_out': 'Biometric locked. Use device PIN to unlock',
      'passcode_not_set': 'No screen lock set on this device',
      'app_lock': 'App Lock',
      'app_lock_enabled': 'App Lock Enabled',
      'enable_app_lock': 'Enable App Lock',
      'disable_app_lock': 'Disable App Lock',
      'app_lock_enabled_description':
          'Your financial data is protected with device security.',
      'app_lock_disabled_description':
          'Secure your financial data using fingerprint, face ID, or PIN.',
      'please_enter_pin': 'Please enter PIN',
      'incorrect_pin': 'Incorrect PIN. Try again.',
      'no_pin_set': 'No PIN set for this app',
      'failed_to_set_pin': 'Failed to set PIN',
      'failed_to_clear_pin': 'Failed to clear PIN',
      'failed_to_set_biometric': 'Failed to set biometric preference',
      'enter_app_pin': 'Enter your app PIN',
      'enter_pin_hint': '0000',
      'unlock': 'Unlock',
      'biometric_not_available': 'Biometric is not available on this device',
      'set_app_pin': 'Set App PIN',
      'create_secure_pin': 'Create a secure PIN to protect your app',
      'enter_pin': 'Enter PIN',
      'confirm_pin': 'Confirm PIN',
      'set_pin': 'Set PIN',
      'pin_must_be_4_digits': 'PIN must be at least 4 digits',
      'pins_do_not_match': 'PINs do not match',
      'app_lock_enabled_success': 'App lock enabled successfully!',
      'failed_to_enable_app_lock': 'Failed to enable app lock',

      // Savings Feature
      'savingsGoals': 'Savings',
      'noSavingsGoalsYet': 'No Savings Goals Yet',
      'createYourFirstGoal': 'Start saving today by creating your first goal',
      'createGoal': 'Create Goal',
      'saved': 'Saved',
      'target': 'Target',
      'goalCompleted': 'Goal Completed',
      'goalsCompleted': 'Goals Completed',
      'totalSaved': 'Total Saved',
      'deleteGoal': 'Delete Goal',
      'confirmDeleteGoal': 'Are you sure you want to delete this goal?',
      'goalDeleted': 'Goal deleted successfully',

      // Phase 5: Create/Edit Goal
      'editGoal': 'Edit Goal',
      'goalName': 'Goal Name',
      'enterGoalName': 'e.g., Emergency Fund, Vacation',
      'goalNameRequired': 'Goal name is required',
      'goalNameTooShort': 'Goal name must be at least 2 characters',
      'targetAmount': 'Target Amount',
      'enterAmount': 'Enter target amount',
      'invalidAmount': 'Please enter a valid amount',

      'goalSummary': 'Goal Summary',
      'notSet': 'Not set',
      'update': 'Update',
      'create': 'Create',
      'goalCreated': 'Goal created successfully!',
      'goalUpdated': 'Goal updated successfully!',

      // Phase 6: Goal Details
      'progress': 'Progress',
      'completed': 'Completed',
      'inProgress': 'In Progress',
      'addOrRemoveAmount': 'Add or Remove Amount',
      'goalInfo': 'Goal Information',
      'createdAt': 'Created At',
      'recentTransactions': 'Recent Transactions',
      'viewAll': 'View All',
      'added': 'Added',
      'removed': 'Removed',

      // Phase 7: Add/Remove Amount
      'add': 'Add',
      'remove': 'Remove',

      'note': 'Note',
      'enterNote': 'Add notes (optional)',
      'transactionSummary': 'Transaction Summary',
      'type': 'Type',
      'adding': 'Adding',
      'removing': 'Removing',
      'newBalance': 'New Balance',
      'transactionAdded': 'Transaction added successfully!',
      'cannotRemoveMoreThanSaved': 'Cannot remove more than current balance',

      // Phase 8: Transactions List
      'allTransactions': 'All Transactions',
      'confirmDelete': 'Confirm Delete',
      'deleteTransactionWarning':
          'Are you sure you want to delete this transaction?',
      'transactionDeleted': 'Transaction deleted successfully',
      'editTransactionTBD': 'Edit transaction feature coming soon',
      'addMoney': 'Add Money',
      'started': 'Started',
      'keepGoing': 'Keep Going!',
      'milestoneAchieved': 'Milestone Achieved! 🎉',
      'milestoneReached_one': 'You\'ve reached',
      'milestoneReached_other': 'of your goal',
      'moneyAdded': 'Money Added',
      'moneyRemoved': 'Money Removed',
      'commonTags': 'Common Tags',
      'deleteTransaction': 'Delete Transaction',
      'optional': 'Optional',

      // Phase 9: Edit/Delete Transaction
      'editTransaction': 'Edit Transaction',
      'transactionUpdated': 'Transaction updated successfully',

      // OPTIONAL: Enhanced Features
      'dailySavingNeeded': 'Daily Saving Needed',
      'milestone': 'Milestone',
      'milestone25': '25% Milestone',
      'milestone50': '50% Milestone',
      'milestone75': '75% Milestone',
      'milestoneComplete': 'Goal Completed',
      'commonNotes': 'Common Notes',

      // ------------------------------- Notes Feature -------------------------------
      'no_notes_yet': 'No notes yet',
      'create_first_note': 'Tap + to create your first note',
      'delete_note_title': 'Delete Note',
      'delete_note_message': 'Are you sure you want to delete this note?',
      'note_deleted': 'Note deleted',
      'add_note': 'Add Note',
      'edit_note': 'Edit Note',
      'write_your_note_here': 'Write your note here...',
      'discard_changes': 'Discard Changes?',
      'discard_note_message':
          'You have unsaved changes. Are you sure you want to discard them?',
      'discard': 'Discard',
      'note_content_empty': 'Note content cannot be empty',
      'note_updated': 'Note updated successfully',
      'note_added': 'Note added successfully',
      'failed_to_save_note': 'Failed to save note',
    },
    'bn_BD': {
      'proceed': 'এগিয়ে যান',

      "chargeOntimeText": "এককালীন চার্জ: ৳২ (ভ্যাট, এসডি এবং এএসসি সহ)",

      "check_sms_title": "এসএমএস চেক করুন",
      "check_sms_desc":
          "আপনি সফলভাবে সাবস্ক্রাইব করেছেন। নিশ্চিতকরণের জন্য অপেক্ষা করুন।",
      "yes": "হ্যাঁ",
      "no": "না",
      "coming_soon_title": "শীঘ্রই আসছে",
      "coming_soon_desc":
          "এই পেমেন্ট মেথডটি শীঘ্রই চালু হবে। অনুগ্রহ করে আমাদের সাথেই থাকুন।",
      "enter_mobile_title": "মোবাইল নম্বর দিন",
      "enter_mobile_desc": "শুধুমাত্র রবি (018) এবং এয়ারটেল (016) নম্বর",

      "login": "লগইন",
      "register": "রেজিস্টার",
      "email": "ইমেইল",
      "password": "পাসওয়ার্ড",
      "forget_password": "পাসওয়ার্ড ভুলে গেছেন?",
      "reset_password": "পাসওয়ার্ড রিসেট",
      "continue_google": "গুগল দিয়ে চালু করুন",
      "continue": "চালিয়ে যান",
      "create_account": "একাউন্ট তৈরি করুন",
      "name": "নাম",
      "send_reset_link": "রিসেট লিংক পাঠান",
      "repeat_daily": "প্রতিদিন রিপিট হবে",
      "connect_internet_to_buy":
          "প্ল্যান কিনতে দয়া করে ইন্টারনেটের সাথে সংযোগ করুন।",
      "feedbackTitle": "আমরা আপনার মতামত জানতে আগ্রহী!",
      "feedbackLabel": "আপনার মতামত",
      "feedbackHint": "দয়া করে আপনার মতামত লিখুন",
      "feedbackSubmit": "সাবমিট",
      "feedbackSuccess": "আপনার মতামতের জন্য ধন্যবাদ!",

      "aboutbody":
          "Hishab Rakhi একটি স্মার্ট এবং আধুনিক মানি ম্যানেজমেন্ট অ্যাপ, যা বিশেষভাবে "
          "বাংলাদেশি ব্যবহারকারীদের জন্য তৈরি। এই অ্যাপের মাধ্যমে আপনি দৈনিক খরচ ট্র্যাক করতে পারবেন, "
          "আয় যোগ করতে পারবেন, বাজেট প্ল্যান করতে পারবেন, বিস্তারিত রিপোর্ট দেখতে পারবেন, "
          "রিমাইন্ডার সেট করতে পারবেন এবং AI-এর সাহায্যে আপনার সেভিংস অভ্যাস আরও উন্নত করতে পারবেন।\n\n"
          "Hishab Rakhi তৈরি করা হয়েছে সহজ ব্যবহার, নিরাপত্তা এবং নির্ভুলতার উপর গুরুত্ব দিয়ে, "
          "যাতে আপনি ঝামেলাহীনভাবে আপনার ব্যক্তিগত অর্থ ব্যবস্থাপনা করতে পারেন।\n\n"
          "এই অ্যাপটি তৈরি করেছেন তাওসিফ হোসেন এবং প্রযুক্তিগত সহায়তা দিয়েছে "
          "Fluttbiz IT Solutions।",
      "version:": "ভার্সন: 1.0.0",
      "dev": "ডেভেলপার: তাওসিফ হোসেন",
      "companyName": "প্রতিষ্ঠান:Fluttbiz IT Solutions",
      "q1": "Hishab Rakhi কীভাবে কাজ করে?",
      "a1":
          "আপনি খুব সহজেই খরচ, আয়, বাজেট যোগ করতে পারবেন এবং বিস্তারিত রিপোর্ট দেখতে পারবেন।",

      "q2": "আমার ডেটা কি নিরাপদ?",
      "a2":
          "হ্যাঁ, আপনার ডেটা নিরাপদভাবে সংরক্ষিত হয় এবং কারও সাথে শেয়ার করা হয় না।",

      "q3": "Hishab Rakhi কি ফ্রি?",
      "a3": "হ্যাঁ, Hishab Rakhi ফ্রি, তবে কিছু প্রো ফিচারও রয়েছে।",

      "q5": "আমি কি আয় ও খরচ দুটোই ট্র্যাক করতে পারবো?",
      "a5": "হ্যাঁ, আপনি আয়, খরচ এবং রিপোর্ট সম্পূর্ণভাবে ট্র্যাক করতে পারবেন।",

      "q6": "Hishab Rakhi কি বাংলা সাপোর্ট করে?",
      "a6": "হ্যাঁ, অ্যাপটি পুরোপুরি বাংলা সাপোর্ট করে।",

      // Pricing View
      'number_verified_title': 'আপনার নাম্বার যাচাই হয়েছে 🎉',
      'subscribe_instruction': 'এখন আপনার পছন্দের প্ল্যানটি সাবস্ক্রাইব করুন',
      'purchase_now_button': 'ক্রয় করুন',
      'subscription_success_msg': 'সাবস্ক্রিপশন সফল হয়েছে!',
      'go_premium': 'প্রো-তে আপগ্রেড করুন',
      'unlock_all_features':
          'সব ফিচার আনলক করুন এবং আপনার অভিজ্ঞতাকে নতুন মাত্রা দিন',
      'cancel_anytime': 'যেকোনো সময় বাতিল করা যাবে • নিরাপদ পেমেন্ট',
      'unlimited_ai_credits': 'আনলিমিটেড AI ক্রেডিট',
      'premium_support': 'প্রিমিয়াম সাপোর্ট',
      'data_backup': 'ডেটা ব্যাকআপ',
      'select_subscription': 'সাবস্ক্রিপশন নির্বাচন করুন',
      'choose_best_plan': 'আপনার জন্য সেরা প্ল্যানটি বেছে নিন',
      'daily_plan': 'দৈনিক প্ল্যান',
      'monthly_plan': 'মাসিক প্ল্যান',
      'per_day': 'প্রতি দিন',
      'per_month': 'প্রতি মাস',
      'all_premium_features': 'সব প্রিমিয়াম ফিচার',
      'renews_daily': 'প্রতিদিন রিনিউ হবে',
      'cancel_anytime_short': 'যেকোনো সময় বাতিল করুন',
      'save_34_percent': 'দৈনিকের চেয়ে ৬৭% সাশ্রয়',
      'best_value': 'সেরা অফার',
      'flexible': 'ফ্লেক্সিবল',
      'most_popular': 'জনপ্রিয়',
      'continue_with': 'চালিয়ে যান',
      'powered_by_bdapps': 'পাওয়ার্ড বাই bdapps • নিরাপদ পেমেন্ট',
      'all_plans_include': 'সব প্ল্যানে অন্তর্ভুক্ত',
      'ai_credits': 'AI ক্রেডিট',
      'advanced_reports': 'অ্যাডভান্সড রিপোর্ট',
      'unsubscribe': 'আনসাবস্ক্রাইব (প্রো)',
      'unsubscribe_confirmation':
          'আপনি কি নিশ্চিত যে আপনি আনসাবস্ক্রাইব করতে চান?',
      'unsubscribe_success': 'সফলভাবে আনসাবস্ক্রাইব করা হয়েছে',
      'buy_more_ai_credits_plan': 'AI ক্রেডিট',
      'not_subscribed_error': 'আপনি এই সার্ভিসে সাবস্ক্রাইব করেননি',
      'already_subscribed': 'এই নাম্বারটি ইতিমধ্যে সাবস্ক্রাইব করা আছে',

      "q7": "AI কীভাবে সাহায্য করে?",
      "a7":
          "AI বাংলা/ইংরেজি বুঝে স্বয়ংক্রিয়ভাবে ট্রান্স্যাকশন তৈরি করতে পারে।",

      "q8": "আমি কি ডেটা ব্যাকআপ রাখতে পারবো?",
      "a8":
          "হ্যাঁ, আপনি ক্লাউড ব্যাকআপ রাখতে পারবেন যাতে আপনার ডেটা নিরাপদ থাকে।",

      "q9": "অ্যাপটি কি রিমাইন্ডার পাঠায়?",
      "a9":
          "হ্যাঁ, আপনি বাজেট, রিপোর্ট এবং মানি টিপসের জন্য দৈনিক রিমাইন্ডার সেট করতে পারবেন।",

      "cancelBuy": "বাতিল",
      "buy": "কিনুন",

      // ------------------------------- Pro Feature -------------------------------
      'premium': 'প্রিমিয়াম',
      'premium_required': 'প্রিমিয়াম প্রয়োজন',
      'premium_required_message':
          'এই ফিচারটি ব্যবহার করতে প্রো-তে আপগ্রেড করুন।',
      'free_trial_ended': 'আপনার ফ্রি ট্রায়াল শেষ হয়েছে।',
      'buy_pro': 'প্রো কিনুন',
      'later': 'পরে',
      'trial_active': 'ট্রায়াল চালু আছে',
      'days_left': 'দিন বাকি',
      '20_days_trial': '২০ দিনের ফ্রি ট্রায়াল',
      'pro_active': 'প্রো চালু আছে',
      'lifetime': 'আজীবন',
      "more_ai": "AI ক্রেডিট রিচার্জ করুন",
      "endedai": "আপনার ফ্রি AI ক্রেডিট শেষ হয়ে গেছে।",
      "30days": "৩০ দিনের জন্য আনলিমিটেড AI ক্রেডিট",
      'ai_assistant_title': 'AI মানি অ্যাসিস্ট্যান্ট',
      'ai_assistant_subtitle':
          'আপনার লেনদেন লিখুন, আমি সেটাকে ঠিকভাবে সাজিয়ে দেবো',
      'try_examples': 'এগুলো ট্রাই করে দেখুন',
      'spent_50_groceries': 'আজকে মুদির দোকানে খরচ ৫০০ টাকা ',
      'lunch_25_today': 'খাবার খরচ ২৫০ টাকা এবং  কারেন্ট বিল ১৫০০',
      'fuel_40_yesterday': 'গতকাল ফুয়েল খরচ ১৮০ টাকা',
      'ai_tip': 'সবচেয়ে ভালো ফলাফলের জন্য পরিমাণ, ক্যাটাগরি ও তারিখ লিখুন',
      'analyzing_transaction': 'লেনদেন বিশ্লেষণ করা হচ্ছে',
      'please_wait': 'একটু অপেক্ষা করুন...',
      'processing': 'প্রসেস করা হচ্ছে...',
      'input_placeholder_detailed': 'উদাহরণ: "বিদ্যুৎ বিল ৩০০০"',

      "support": "সাপোর্ট",
      'preferences': 'পছন্দসমূহ',
      'manage_app_settings': 'আপনার পছন্দ অনুযায়ী অ্যাপ সেটিংস কাস্টমাইজ করুন',
      "daily_finance_tip": "দৈনিক ফাইন্যান্স টিপ",

      'no_internet_connection': 'ইন্টারনেট সংযোগ নেই',
      'connection_timeout': 'সংযোগ সময়সীমা শেষ',
      "something_went_wrong":
          "কিছু সমস্যা হয়েছে, দয়া করে পরে আবার চেষ্টা করুন।",
      'reportTitle': 'রিপোর্ট',
      'search': 'অনুসন্ধান করুন',
      'income': 'আয়',
      'pro_features': 'প্রো ফিচারস',
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
      "miscellaneous_expense": "অন্যান্য",
      "miscellaneous_income": "অন্যান্য আয়",
      "reset_confirmation_title": "অ্যাপ রিসেট করবেন?",
      "reset_confirmation_message":
          "আপনি কি রিসেট করতে চান? রিসেট করলে আপনার সব লেনদেন ও ডেটা মুছে যাবে।",
      'reset_delete_options': 'রিসেট/ডিলিট',
      'reset_delete_description':
          'আপনার অ্যাপ ডেটা এবং অ্যাকাউন্ট সেটিংস ম্যানেজ করুন।',
      'reset_app_data': 'অ্যাপ ডেটা রিসেট করুন',
      'reset_app_data_desc':
          'অ্যাকাউন্ট ডিলিট না করে শুধুমাত্র লোকাল ডেটা (লেনদেন, বাজেট ইত্যাদি) মুছে ফেলুন।',
      'delete_account': 'অ্যাকাউন্ট ডিলিট করুন',
      'delete_account_desc':
          'আপনার অ্যাকাউন্ট এবং সমস্ত ডেটা স্থায়ীভাবে মুছে ফেলুন।',
      'reset_app_data_confirmation':
          'আপনি কি নিশ্চিত যে আপনি অ্যাপ ডেটা রিসেট করতে চান? এটি সমস্ত লোকাল লেনদেন এবং বাজেট মুছে ফেলবে। এই কাজটি আর ফিরিয়ে আনা যাবে না।',
      'delete_account_confirmation':
          'আপনি কি নিশ্চিত যে আপনি আপনার অ্যাকাউন্ট ডিলিট করতে চান? এটি ক্লাউড এবং লোকাল স্টোরেজ থেকে আপনার অ্যাকাউন্ট এবং সমস্ত ডেটা স্থায়ীভাবে মুছে ফেলবে। এই কাজটি আর ফিরিয়ে আনা যাবে না।',
      'app_data_reset_success': 'অ্যাপ ডেটা সফলভাবে রিসেট করা হয়েছে।',
      'reset': 'রিসেট',
      'delete': 'ডিলিট',
      //-------------------------------Welcome View-------------------------------
      "welcomeViewTitle": "সহজে টাকার ব্যবস্থাপনা",
      "welcomeViewSubtitle":
          "খরচ গুছিয়ে রাখুন, সঞ্চয়ের পরিকল্পনা করুন আর নিশ্চিন্তে থাকুন।",
      "welcomeViewButtonOne": "শুরু করুন",
      "welcomeViewButtonTwo": "ডেমো দেখুন",
      "preview": "প্রিভিউ",

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
      'my_salary': 'বেতন ১২০০০ টাকা',

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
      "titleOptional": "শিরোনাম (ঐচ্ছিক)",
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
      "resetDescription":
          "রিসেট সফলভাবে সম্পন্ন হয়েছে। আপনার সমস্ত ডেটা সিস্টেম থেকে মুছে ফেলা হয়েছে।",

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
      "daily_budget_limit_title": "দৈনিক বাজেটের সীমা",
      "budget_exceeded_title": "বাজেট পার হয়ে গেছে!",
      "budget_exceeded_message": "আপনার বাজেট পার হয়ে গেছে",
      "review_transactions_title": "আপনার লেনদেন পর্যালোচনা করুন",
      "review_transactions_message":
          "আজকের লেনদেনগুলি পর্যালোচনা করতে একটু সময় নিন এবং নিশ্চিত করুন যে সবকিছু ট্র্যাক করা হয়েছে!",
      "include_in_total_income": "মোট আয়ের সাথে যুক্ত হবে",
      "budget_expired_title": "বাজেটের মেয়াদ শেষ",
      "label_days": "দিন",
      "label_expired": "মেয়াদোত্তীর্ণ",
      "label_days_left": "সময়সীমা",
      "label_status": "অবস্থা",
      "label_daily_limit": "দৈনিক লিমিট",
      "daily_spend_advice_one": "বাজেট ঠিক রাখতে আজ আপনি সর্বোচ্চ ৳",
      "daily_spend_advice_two": "খরচ করতে পারবেন।",
      "budget_exceeded_message_start": "আপনার ",
      "budget_exceeded_message_end": "-এর জন্য নির্ধারিত বাজেট শেষ হয়ে গেছে।",
      "budget_expired_message_start": "আপনার",
      "budget_expired_message_end": "বাজেটের সময়সীমা শেষ হয়েছে।",

      // ------------------------------- Balance Check Dialog -------------------------------
      'balance_check_title': 'ব্যালেন্স চেক করুন',
      'balance_check_message':
          'অনুগ্রহ করে নিশ্চিত করুন যে আপনার অ্যাকাউন্টে পর্যাপ্ত ব্যালেন্স আছে।',

      // ------------------------------- SMS Confirmation Dialog -------------------------------
      'subscription_initiated_title': 'সাবস্ক্রিপশন সফল হয়েছে',
      'subscription_initiated_desc':
          'সফলভাবে সাবস্ক্রাইব করা হয়েছে। অনুগ্রহ করে নিশ্চিতকরণ এসএমএসের জন্য অপেক্ষা করুন।',
      'okay': 'ঠিক আছে',
      'sms_confirmation_title': 'এসএমএস নিশ্চিতকরণ',
      'sms_confirmation_message':
          'আমরা এসএমএসের মাধ্যমে আপনার সাবস্ক্রিপশন নিশ্চিত করার সময় অনুগ্রহ করে অপেক্ষা করুন।',
      'seconds': 'সেকেন্ড',

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
      "about": "আমাদের সম্পর্কে",
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

      "notification_settings": "নোটিফিকেশন সেটিংস",
      "all_notifications": "সকল নোটিফিকেশন",
      "all_notifications_desc": "অ্যাপের সকল নোটিফিকেশন চালু বা বন্ধ করুন",
      "notification_types": "নোটিফিকেশনের ধরন",
      "daily_finance_tip_desc":
          "আপনার আর্থিক স্বাস্থ্যের উন্নতির জন্য প্রতিদিনের টিপস পান",
      "daily_transaction_review": "দৈনিক লেনদেন পর্যালোচনা",
      "daily_transaction_review_desc":
          "আপনার প্রতিদিনের লেনদেন পর্যালোচনা করার রিমাইন্ডার",
      "budget_alerts_desc": "বাজেট সীমা অতিক্রম করলে নোটিফিকেশন পান",
      "viewInsights": "বিস্তারিত দেখুন",
      "close": "বন্ধ",
      "budget_alerts": "বাজেট রিমাইন্ডার",

      "add_with_ai": "AI দিয়ে যোগ করুন",
      "smart_categorization": "স্মার্ট ক্যাটাগরি",
      "add_manually": "ম্যানুয়ালি যোগ করুন",
      "enter_details": "বিবরণ নিজে লিখুন",
      "spent_on_food": "খাবারের খরচ",
      "received_salary": "বেতন পেয়েছি ",
      "bought_groceries": "কেনাকাটা করেছি",
      "fuel_expense": "জ্বালানির খরচ",
      "ai_assistant": "AI সহায়ক",
      "process_with_ai": "AI দিয়ে প্রক্রিয়া করুন",
      "input_placeholder": "আপনার লেনদেন লিখুন",
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
      "speech_error": "স্পিচ এরর:",
      "speech_init_failed": "স্পিচ ইনিশিয়ালাইজেশন ব্যর্থ হয়েছে",
      "permission_required": "অনুমতি প্রয়োজন",

      "grant_permission_message":
          "দয়া করে 'অ্যালার্ম ও রিমাইন্ডার' অনুমতি প্রদান করুন।",
      "save_today_for_tomorrow":
          "ছোট ছোট সঞ্চয় করলে সময়ের সাথে সাথে বড় হয়ে যায়।",
      "skip_unnecessary_purchase": "যা দরকার নেই, তা না কিনলে টাকা বাঁচে!",
      "saving_is_a_habit":
          "সঞ্চয় একটি অভ্যাস, সংখ্যা নয়। ছোট থেকে শুরু করুন।",
      "daily_savings_goal":
          "দৈনিক সঞ্চয়ের লক্ষ্য নির্ধারণ করুন — এমনকি ১০ টাকাও গুরুত্বপূর্ণ।",
      "future_emergency_savings":
          "ভবিষ্যতের জরুরি অবস্থা আজকের সঞ্চয় দিয়ে সমাধান হয়।",
      "pay_yourself_first": "আয় হলে সবার আগে নিজের জন্য কিছু সঞ্চয় করুন।",
      "save_five_percent_challenge":
          "টাকা কোথায় গেল জানলেই, টাকা থাকা শুরু হয়।",
      "review_savings_goal":
          "আপনার সঞ্চয়ের লক্ষ্য পর্যালোচনা করুন — প্রয়োজনে এডজাস্ট করুন।",
      "track_spending_daily": "খরচ ট্র্যাক করলে সঞ্চয় সহজ হয়!",
      "budget_limit_check":
          "দেখে নিন আজ কত খরচ হয়েছে, বাজেটের মধ্যে আছে কি না।",
      "daily_budget_check": "দৈনিক বাজেট ট্র্যাক করলে টাকার চাপ দূরে থাকে।",
      "plan_todays_spending": "খরচ করার আগে আজকের খরচ পরিকল্পনা করুন।",
      "update_categories": "আজ হিসাব রাখলে, আগামীকাল চাপ কমে।",
      "delay_if_not_in_budget": "আপনার চাহিদা এবং ইচ্ছা অনুযায়ী খরচ করুন।",
      "budget_is_roadmap":
          "আপনার বাজেটই আপনার রোডম্যাপ — প্রতিদিন এটি অনুসরণ করুন হিসাব রাখি অ্যাপের সাহায্যে।",
      "review_last_week_expenses":
          "গত সপ্তাহের খরচ আবার দেখুন — কোনো ভুল ঠিক করার আছে?",
      "think_before_buying":
          "কেনার আগে দুবার ভাবুন — আপনার সত্যিই দরকার আছে কি?",
      "avoid_emotional_spending": "অপ্রয়োজনীয় খরচই ভবিষ্যতের সবচেয়ে বড় শত্রু।",
      "compare_prices": "প্রতিটি কেনার আগে দাম তুলনা করুন।",
      "shopping_list_reminder":
          "শপিং করার সময় একটি তালিকা নিয়ে যান — আবেগের বশে কেনা এড়িয়ে চলুন!",
      "track_all_income": "সব আয় ট্র্যাক করুন — বড় বা ছোট।",
      "invest_in_yourself": "নিজের উপর বিনিয়োগ করুন।",
      "extra_income_acceleration":
          "আপনি যে অতিরিক্ত টাকা আয় করেন তা আপনার লক্ষ্যগুলো দ্রুত অর্জনে সাহায্য করে!",
      "save_extra_income": "অতিরিক্ত আয়ের কমপক্ষে ২০% সঞ্চয় করুন।",
      "use_bonuses_wisely":
          "বোনাস বুদ্ধিমানের মতো ব্যবহার করুন — সঞ্চয় করুন বা বিনিয়োগ করুন, অপচয় করবেন না।",
      "daily_financial_habit":
          "আর্থিক সাফল্য একটি দৈনিক অভ্যাস — ধারাবাহিক থাকুন।",
      "avoid_tracking_delay":
          "দেরি করবেন না — ছোট ট্র্যাকিং দেরি বড় ভুলের কারণ হয়।",
      "review_monthly_goals":
          "আপনার মাসিক লক্ষ্য পর্যালোচনা করুন — আজ থেকেই অগ্রগতি শুরু হবে।",
      "consistency_is_superpower": "ধারাবাহিকতা আপনার সুপারপাওয়ার!",

      "appearance": "অ্যাপিয়ারেন্স",
      "warningTitleTransacton": "ওভারস্পেন্ডিং সতর্কবার্তা",
      "warningDescTransacton": "আপনার যোগ করা খরচ আয়ের চেয়ে বেশি হয়েছে।",

      'transaction_detected': 'লেনদেন শনাক্ত হয়েছে',
      'items_found': 'আইটেম পাওয়া গেছে',
      'try_different_input': 'আপনার লেনদেনটি অন্যভাবে লিখে দেখুন',
      'note': 'নোট',
      'today': 'আজ',
      'yesterday': 'গতকাল',
      'expense': 'খরচ',
      "given_taken": "দেনা-পাওনা",
      "transaction_type": "লেনদেনের ধরন",
      "features": "ফিচারসমূহ",
      "you_will_get": "পাবেন",
      "you_need_to_pay": "দিতে হবে",
      "given": "দেনা",
      "taken": "পাওনা",
      "no_contacts_yet": "এখনও কোনো কন্টাক্ট নেই",
      "add_person_to_track": "লেনদেন ট্র্যাক করতে নতুন ব্যক্তি যোগ করুন",
      "add_person": "ব্যক্তি যোগ করুন",
      "edit_person": "তথ্য পরিবর্তন",
      "delete_person": "মুছে ফেলুন",
      "person_name": "ব্যক্তির নাম",
      "phone_number": "ফোন নম্বর",
      "address": "ঠিকানা",
      "initial_amount": "শুরুর ব্যালেন্স",
      "net_balance": "মোট ব্যালেন্স",
      "transactions_history": "লেনদেনের ইতিহাস",
      "records": "রেকর্ড",
      "add_record": "রেকর্ড যোগ করুন",
      "given_taken_report": "দেনা-পাওনা রিপোর্ট",
      "share": "শেয়ার",
      "download": "ডাউনলোড",
      "given_taken_summary": "দেনা-পাওনা সারসংক্ষেপ",
      "get": "পাবেন",
      "pay": "দিবেন",
      "settle_up": "হিসাব মিটিয়ে নিন",
      "mark_as_settled": "পরিশোধিত হিসেবে চিহ্নিত করুন",
      "confirm_delete_person":
          "আপনি কি নিশ্চিত যে এই ব্যক্তি এবং তার সব লেনদেন মুছে ফেলতে চান?",
      "confirm_delete_transaction":
          "আপনি কি নিশ্চিত যে এই লেনদেনটি মুছে ফেলতে চান?",
      "delete_transaction": "লেনদেন মুছে ফেলুন",
      "amount_required": "টাকার পরিমাণ প্রয়োজন",
      "enter_valid_amount": "সঠিক পরিমাণ লিখুন",
      "name_required": "নাম প্রয়োজন",
      "enter_name": "একটি নাম লিখুন",
      "enter_phone_number": "ফোন নম্বর লিখুন (ঐচ্ছিক)",
      "enter_address": "ঠিকানা লিখুন (ঐচ্ছিক)",
      "enter_note": "নোট লিখুন (ঐচ্ছিক)",
      "transaction_added": "লেনদেন সফলভাবে যোগ করা হয়েছে",
      "transaction_updated": "লেনদেন সফলভাবে আপডেট করা হয়েছে",
      "transaction_deleted": "লেনদেন সফলভাবে মুছে ফেলা হয়েছে",
      "person_deleted": "ব্যক্তি সফলভাবে মুছে ফেলা হয়েছে",
      "person_added": "ব্যক্তি সফলভাবে যোগ করা হয়েছে",
      "person_updated": "ব্যক্তি সফলভাবে আপডেট করা হয়েছে",
      "success": "সফল",
      "settled_successfully": "সফলভাবে হিসাব মিটিয়ে ফেলা হয়েছে",
      "confirm_settle_up":
          "আপনি কি নিশ্চিত যে আপনি পুরো হিসাব মিটিয়ে ফেলতে চান?",
      "error": "ত্রুটি",
      "failed_to_load_transactions": "লেনদেন লোড করতে ব্যর্থ হয়েছে",
      "failed_to_save_contact": "যোগাযোগ সংরক্ষণ করতে ব্যর্থ হয়েছে",
      "failed_to_save_transaction": "লেনদেন সংরক্ষণ করতে ব্যর্থ হয়েছে",
      "failed_to_settle_up": "হিসাব মিটিয়ে ফেলতে ব্যর্থ হয়েছে",

      // ------------------------------- Auth & Settings New Keys -------------------------------
      'pro_user': 'প্রো ইউজার',
      'free_user': 'ফ্রি ইউজার',
      'guest_user': 'গেস্ট ইউজার',
      'no_email_linked': 'কোনো ইমেইল যুক্ত নেই',
      'pro_button': 'প্রো',
      'light_theme': 'লাইট',
      'dark_theme': 'ডার্ক',
      'system_theme': 'সিস্টেম',
      'english_lang': 'ইংরেজি',
      'bangla_lang': 'বাংলা',
      'logout_confirmation': 'আপনি কি নিশ্চিত যে আপনি লগআউট করতে চান?',
      'welcome_back': 'স্বাগতম!',
      'sign_in_continue': 'চালিয়ে যেতে সাইন ইন করুন',
      'enter_email_error': 'দয়া করে আপনার ইমেইল দিন',
      'valid_email_error': 'দয়া করে একটি সঠিক ইমেইল দিন',
      'enter_password_error': 'দয়া করে আপনার পাসওয়ার্ড দিন',
      'password_length_error': 'পাসওয়ার্ড অন্তত ৬ অক্ষরের হতে হবে',
      'sign_in_google': 'গুগল দিয়ে সাইন ইন করুন',
      'no_account': "কোনো অ্যাকাউন্ট নেই? ",
      'sign_up_button': 'সাইন আপ',
      'sign_up_started': 'শুরু করতে সাইন আপ করুন',
      'enter_name_error': 'দয়া করে আপনার নাম দিন',
      'sign_up_google': 'গুগল দিয়ে সাইন আপ করুন',
      'already_have_account': 'ইতিমধ্যে একটি অ্যাকাউন্ট আছে? ',
      'reset_password_desc': 'পাসওয়ার্ড রিসেট লিংক পেতে আপনার ইমেইল দিন',
      'logged_in_success': 'লগইন সফল হয়েছে',
      'registered_success': 'রেজিস্ট্রেশন সফল হয়েছে',
      'password_reset_sent':
          'আপনার ইমেইলে পাসওয়ার্ড রিসেট লিংক পাঠানো হয়েছে। ইনবক্স বা স্প্যাম চেক করুন।',
      'google_login_success': 'গুগল দিয়ে লগইন সফল হয়েছে',
      'logged_out_success': 'লগআউট সফল হয়েছে',
      'account_deleted_title': 'অ্যাকাউন্ট ডিলিট করা হয়েছে',
      'account_deleted_msg':
          'আপনার অ্যাকাউন্ট এবং ডেটা স্থায়ীভাবে মুছে ফেলা হয়েছে।',
      'security_check_title': 'নিরাপত্তা যাচাই',
      'relogin_delete_msg': 'অ্যাকাউন্ট ডিলিট করতে দয়া করে আবার লগইন করুন।',
      'error_title': 'ত্রুটি',
      'unknown_error': 'একটি অজানা ত্রুটি ঘটেছে',
      'user_not_found': 'এই ইমেইলের জন্য কোনো ব্যবহারকারী পাওয়া যায়নি।',
      'wrong_password': 'ভুল পাসওয়ার্ড দেওয়া হয়েছে।',
      'email_in_use': 'এই ইমেইল দিয়ে ইতিমধ্যে একটি অ্যাকাউন্ট আছে।',
      'weak_password': 'পাসওয়ার্ডটি খুব দুর্বল।',
      'operation_not_allowed':
          'এই কাজটি অনুমোদিত নয়। দয়া করে সাপোর্টে যোগাযোগ করুন।',
      'network_error': 'নেটওয়ার্ক ত্রুটি। দয়া করে আপনার সংযোগ পরীক্ষা করুন।',
      'too_many_requests': 'খুব বেশি অনুরোধ করা হয়েছে। পরে আবার চেষ্টা করুন।',
      'invalid_credential': 'ভুল ইমেইল বা পাসওয়ার্ড।',
      'invalid_credential_session': 'ভুল তথ্য বা সেশনের মেয়াদ শেষ হয়েছে।',
      'auth_failed': 'অথেন্টিকেশন ব্যর্থ হয়েছে।',
      'google_sign_in_failed': 'গুগল সাইন-ইন ব্যর্থ হয়েছে: ',
      'plan_expired': 'প্ল্যানের মেয়াদ শেষ',

      // ------------------------------- Pricing View -------------------------------
      'check_out': 'চেক আউট',
      'manage_plan': 'প্ল্যান ম্যানেজ করুন',
      'choose_pricing_plan': 'আপনার প্রাইসিং প্ল্যান বেছে নিন',
      'set_reminder': 'রিমাইন্ডার সেট করুন',
      'monthly_weekly_reports': 'মাসিক/সাপ্তাহিক রিপোর্ট',
      'reports': 'রিপোর্ট',
      'set_budget': 'বাজেট সেট করুন',
      'no_ads': 'কোনো বিজ্ঞাপন নেই',
      'starter_plan': 'স্টার্টার প্ল্যান',
      'smart_plan': 'স্মার্ট প্ল্যান',
      'pro_plan': 'প্রো প্ল্যান',
      'ultimate_plan': 'আলটিমেট প্ল্যান',
      '900_credits': '৯০০ AI ক্রেডিট',
      '2700_credits': '২৭০০ AI ক্রেডিট',
      '2700_credits_pro':
          '২৭০০ AI ক্রেডিট', // Assuming same as smart based on prototype visual, though usually pro is more
      '5500_credits_pro': '৫৫০০ AI ক্রেডিট',
      '11000_credits': '১১০০০ AI ক্রেডিট',
      '27000_credits': '২৭০০০ AI ক্রেডিট',
      'monthly': 'মাসিক',
      'credits_left': 'ক্রেডিট বাকি',
      'no_credits': 'কোনো ক্রেডিট নেই',
      'buy_now': 'এখন কিনুন',
      '500_credits_for_30tk': '৬০ ক্রেডিট ৳৩০ তে',
      'purchase_credits_title': 'AI ক্রেডিট কিনুন',
      'purchase_credits_desc': 'মাত্র ৳৩০ এ ৬০ AI ক্রেডিট পান',
      'purchase_plan_msg':
          'এআই বৈশিষ্ট্যগুলি ব্যবহার চালিয়ে যেতে দয়া করে একটি পরিকল্পনা কিনুন।',
      'or_continue_with': 'অথবা চালিয়ে যান',
      'enter_email': 'আপনার ইমেইল দিন',
      'enter_password': 'আপনার পাসওয়ার্ড দিন',
      'whatsapp_error':
          'হোয়াটসঅ্যাপ খোলা যাচ্ছে না। অনুগ্রহ করে আবার চেষ্টা করুন।',
      'feedback_footer':
          'আমাদের অ্যাপ উন্নত করতে আমরা আপনার মতামতকে গুরুত্ব দিই।',
      '3_months': '৩ মাস',
      '6_months': '৬ মাস',
      '1_year': '১ বছর',
      'choose_plan': 'প্ল্যান বেছে নিন',
      'payment_success': 'পেমেন্ট সফল হয়েছে',
      'payment_success_message':
          'আপনার প্ল্যানটি সফলভাবে চালু হয়েছে। ধন্যবাদ!',

      // ------------------------------- OTP Views -------------------------------
      'registration': 'রেজিস্ট্রেশন',
      'mobile_verification': 'মোবাইল নম্বর যাচাইকরণ',
      'enter_phone_number_desc':
          'আপনার ফোন নম্বরটি নিবন্ধনের জন্য অনুগ্রহ করে প্রদান করুন',
      'enter_phone_hint': 'রবি/এয়ারটেল নম্বর লিখুন...',
      'please_enter_number': 'অনুগ্রহ করে নম্বর লিখুন',
      'number_must_be_11_digits': 'নম্বরটি অবশ্যই ১১ সংখ্যার হতে হবে',
      'enter_valid_bd_number': 'সঠিক বাংলাদেশি নম্বর লিখুন (০১...)',
      'send_code': 'কোড পাঠান',
      'otp_will_be_sent':
          'আপনার নম্বর যাচাইয়ের জন্য একটি ওটিপি কোড পাঠানো হবে।',
      'account_activation': 'অ্যাকাউন্ট সক্রিয়করণ',
      'enter_otp_desc': 'অ্যাকাউন্ট সক্রিয় করতে ওটিপি কোডটি প্রদান করুন',
      'enter_otp_hint': 'ওটিপি লিখুন...',
      'please_enter_otp': 'অনুগ্রহ করে ওটিপি লিখুন',
      'otp_must_be_6_digits': 'ওটিপি অবশ্যই ৬ সংখ্যার হতে হবে',
      'verify_number': 'নম্বর যাচাই করুন',
      'retry_otp_desc': 'ওটিপি না পেলে কয়েক সেকেন্ড পর পুনরায় চেষ্টা করুন।',
      'failed_to_fetch_data': 'কোনো তথ্য পাওয়া যায়নি',
      'no_content_in_response': 'কোনো ডেটা পাওয়া যায়নি',
      'failed_to_parse_response': 'প্রতিক্রিয়া বিশ্লেষণ করতে ব্যর্থ',
      'ai_request_failed': 'এআই রিকোয়েস্ট ফেইল',

      // App Lock Translations
      'unlock_your_app': 'আপনার অ্যাপ আনলক করুন',
      'use_biometric_or_pin': 'আপনার বায়োমেট্রিক বা পিন ব্যবহার করুন',
      'authenticating': 'যাচাই করা হচ্ছে...',
      'authenticate_to_unlock': 'হিসাব রাখি আনলক করতে যাচাই করুন',
      'device_check_failed': 'ডিভাইস চেক ব্যর্থ হয়েছে',
      'biometric_check_failed': 'বায়োমেট্রিক চেক ব্যর্থ হয়েছে',
      'authentication_failed': 'যাচাইকরণ ব্যর্থ',
      'biometric_hardware_not_available':
          'এই ডিভাইসে বায়োমেট্রিক হার্ডওয়্যার উপলব্ধ নয়',
      'no_biometric_enrolled':
          'ডিভাইস সেটিংসে কোন ফিঙ্গারপ্রিন্ট / ফেস নিবন্ধিত নয়',
      'locked_out': 'অনেক চেষ্টার পর লক হয়েছে। পরে আবার চেষ্টা করুন',
      'permanently_locked_out':
          'বায়োমেট্রিক লক হয়েছে। ডিভাইস পিন ব্যবহার করে আনলক করুন',
      'passcode_not_set': 'এই ডিভাইসে স্ক্রিন লক সেট করা নেই',
      'app_lock': 'অ্যাপ লক',
      'app_lock_enabled': 'অ্যাপ লক সক্রিয়',
      'enable_app_lock': 'অ্যাপ লক সক্রিয় করুন',
      'disable_app_lock': 'অ্যাপ লক নিষ্ক্রিয় করুন',
      'app_lock_enabled_description':
          'আপনার আর্থিক তথ্য ডিভাইস নিরাপত্তা দ্বারা সুরক্ষিত।',
      'app_lock_disabled_description':
          'ফিঙ্গারপ্রিন্ট, ফেস আইডি বা পিন ব্যবহার করে আপনার আর্থিক তথ্য সুরক্ষিত করুন।',
      'please_enter_pin': 'অনুগ্রহ করে পিন লিখুন',
      'incorrect_pin': 'ভুল পিন। আবার চেষ্টা করুন।',
      'no_pin_set': 'এই অ্যাপের জন্য কোনো পিন সেট করা নেই',
      'failed_to_set_pin': 'পিন সেট করতে ব্যর্থ',
      'failed_to_clear_pin': 'পিন মুছতে ব্যর্থ',
      'failed_to_set_biometric': 'বায়োমেট্রিক পছন্দ সেট করতে ব্যর্থ',
      'enter_app_pin': 'আপনার অ্যাপ পিন প্রবেश করুন',
      'enter_pin_hint': '০০০০',
      'unlock': 'আনলক করুন',
      'biometric_not_available': 'এই ডিভাইসে বায়োমেট্রিক উপলব্ধ নেই',
      'set_app_pin': 'অ্যাপ পিন সেট করুন',
      'create_secure_pin': 'আপনার অ্যাপ রক্ষা করতে একটি নিরাপদ পিন তৈরি করুন',
      'enter_pin': 'পিন লিখুন',
      'confirm_pin': 'পিন নিশ্চিত করুন',
      'set_pin': 'পিন সেট করুন',
      'pin_must_be_4_digits': 'পিন কমপক্ষে ৪ অঙ্কের হতে হবে',
      'pins_do_not_match': 'পিনগুলি মেলে না',
      'app_lock_enabled_success': 'অ্যাপ লক সফলভাবে সক্রিয় করা হয়েছে!',
      'failed_to_enable_app_lock': 'অ্যাপ লক সক্রিয় করতে ব্যর্থ',

      // Savings Feature
      'savingsGoals': 'সঞ্চয়',
      'noSavingsGoalsYet': 'এখনও কোনো সঞ্চয় লক্ষ্য নেই',
      'createYourFirstGoal': 'আজই সঞ্চয় শুরু করুন আপনার প্রথম লক্ষ্য তৈরি করে',
      'createGoal': 'লক্ষ্য তৈরি করুন',
      'saved': 'সঞ্চিত',
      'target': 'লক্ষ্য',

      'goalCompleted': 'লক্ষ্য সম্পন্ন',
      'goalsCompleted': 'লক্ষ্য সম্পন্ন',
      'totalSaved': 'মোট সঞ্চিত',
      'deleteGoal': 'লক্ষ্য মুছুন',
      'confirmDeleteGoal': 'আপনি কি এই লক্ষ্যটি মুছতে চান?',
      'goalDeleted': 'লক্ষ্য সফলভাবে মুছা হয়েছে',

      // Phase 5: Create/Edit Goal
      'editGoal': 'লক্ষ্য সম্পাদনা করুন',
      'goalName': 'লক্ষ্যের নাম',
      'enterGoalName': 'যেমন, জরুরি তহবিল, ছুটির দিন',
      'goalNameRequired': 'লক্ষ্যের নাম প্রয়োজন',
      'goalNameTooShort': 'লক্ষ্যের নাম কমপক্ষে ২ অক্ষরের হতে হবে',
      'targetAmount': 'লক্ষ্য পরিমাণ',
      'enterAmount': 'লক্ষ্য পরিমাণ লিখুন',
      'invalidAmount': 'অনুগ্রহ করে একটি বৈধ পরিমাণ লিখুন',
      'amountMustBePositive': 'পরিমাণ ০ এর চেয়ে বেশি হতে হবে',

      'goalSummary': 'লক্ষ্যের সারসংক্ষেপ',
      'notSet': 'সেট করা হয়নি',
      'update': 'আপডেট করুন',
      'create': 'তৈরি করুন',
      'goalCreated': 'লক্ষ্য সফলভাবে তৈরি করা হয়েছে!',
      'goalUpdated': 'লক্ষ্য সফলভাবে আপডেট করা হয়েছে!',

      // Phase 6: Goal Details
      'progress': 'অগ্রগতি',
      'completed': 'সম্পন্ন',
      'inProgress': 'চলমান',
      'addOrRemoveAmount': 'পরিমাণ যোগ বা অপসারণ করুন',
      'goalInfo': 'লক্ষ্য তথ্য',
      'createdAt': 'তৈরি করা হয়েছে',
      'recentTransactions': 'সাম্প্রতিক লেনদেন',

      'viewAll': 'সব দেখুন',
      'added': 'যোগ করা হয়েছে',
      'removed': 'অপসারণ করা হয়েছে',

      // Phase 7: Add/Remove Amount
      'add': 'যোগ করুন',
      'remove': 'অপসারণ করুন',

      'enterNote': 'নোট যোগ করুন (ঐচ্ছিক)',
      'transactionSummary': 'লেনদেনের সারসংক্ষেপ',
      'type': 'ধরন',
      'adding': 'যোগ করা হচ্ছে',
      'removing': 'অপসারণ করা হচ্ছে',
      'newBalance': 'নতুন ব্যালেন্স',
      'transactionAdded': 'লেনদেন সফলভাবে যোগ করা হয়েছে!',
      'cannotRemoveMoreThanSaved':
          'বর্তমান ব্যালেন্সের চেয়ে বেশি অপসারণ করতে পারবেন না',

      // Phase 8: Transactions List
      'allTransactions': 'সমস্ত লেনদেন',
      'confirmDelete': 'মুছে ফেলার নিশ্চিতকরণ',
      'deleteTransactionWarning': 'আপনি কি এই লেনদেনটি মুছে ফেলতে নিশ্চিত?',
      'transactionDeleted': 'লেনদেন সফলভাবে মুছে ফেলা হয়েছে',
      'editTransactionTBD': 'লেনদেন সম্পাদন বৈশিষ্ট্য শীঘ্রই আসছে',

      // Phase 9: Edit/Delete Transaction
      'editTransaction': 'লেনদেন সম্পাদন করুন',
      'transactionUpdated': 'লেনদেন সফলভাবে আপডেট করা হয়েছে',

      // OPTIONAL: Enhanced Features
      'dailySavingNeeded': 'প্রতিদিন সঞ্চয় প্রয়োজন',
      'milestone': 'মাইলফলক',
      'milestone25': '২৫% মাইলফলক',
      'milestone50': '৫০% মাইলফলক',
      'milestone75': '৭৫% মাইলফলক',
      'milestoneComplete': 'লক্ষ্য সম্পন্ন',
      'commonNotes': 'সাধারণ নোট',
      'addMoney': 'টাকা যোগ করুন',
      'started': 'শুরু হয়েছে',
      'keepGoing': 'চালিয়ে যান!',
      'milestoneAchieved': 'মাইলফলক অর্জিত! 🎉',
      'milestoneReached_one': 'আপনি আপনার লক্ষ্যের',
      'milestoneReached_other': 'এ পৌঁছেছেন',
      'moneyAdded': 'টাকা যোগ করা হয়েছে',
      'moneyRemoved': 'টাকা তোলা হয়েছে',
      'viewMore': 'আরও দেখুন',
      'commonTags': 'সাধারণ ট্যাগ',
      'deleteTransaction': 'লেনদেন মুছুন',
      'optional': 'ঐচ্ছিক',
      'recentActivity': 'সাম্প্রতিক লেনদেন',
      'more': 'আরও',
      'edit_record': 'সম্পাদন করুন',

      // ------------------------------- Notes Feature -------------------------------
      'no_notes_yet': 'এখনও কোনো নোট নেই',
      'create_first_note': 'প্রথম নোট তৈরি করতে + ট্যাপ করুন',
      'delete_note_title': 'নোট মুছুন',
      'delete_note_message': 'আপনি কি নিশ্চিত যে আপনি এই নোটটি মুছে ফেলতে চান?',
      'note_deleted': 'নোট মুছে ফেলা হয়েছে',
      'add_note': 'নোট যোগ করুন',
      'edit_note': 'নোট সম্পাদনা করুন',
      'write_your_note_here': 'আপনার নোট এখানে লিখুন...',
      'discard_changes': 'পরিবর্তন বাতিল করবেন?',
      'discard_note_message':
          'আপনার কিছু পরিবর্তন সেভ করা হয়নি। আপনি কি নিশ্চিত যে আপনি সেগুলি বাতিল করতে চান?',
      'discard': 'বাতিল',
      'note_content_empty': 'নোটের বিষয়বস্তু ফাঁকা রাখা যাবে না',
      'note_updated': 'নোট সফলভাবে আপডেট করা হয়েছে',
      'note_added': 'নোট সফলভাবে যোগ করা হয়েছে',
      'failed_to_save_note': 'নোট সংরক্ষণ করতে ব্যর্থ হয়েছে',
    },
  };
}
