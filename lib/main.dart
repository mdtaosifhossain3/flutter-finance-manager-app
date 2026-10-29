import 'package:finance_manager_app/config/db/local/category_db/add_transaction_db_helper.dart';
import 'package:finance_manager_app/config/routes/routes.dart';
import 'package:finance_manager_app/config/theme/app_theme.dart';
import 'package:finance_manager_app/config/translator/app_translator.dart';
import 'package:finance_manager_app/providers/aiProvider/ai_provider.dart';
import 'package:finance_manager_app/providers/bazarProvider/bazar_provider.dart';
import 'package:finance_manager_app/providers/recurringProvider/recurring_provider.dart';
import 'package:finance_manager_app/providers/walletProvider/wallet_provider.dart';
import 'package:finance_manager_app/providers/notification_provider.dart';

import 'package:finance_manager_app/providers/budget/budget_provider.dart';
import 'package:finance_manager_app/providers/category/category_item_provider.dart';
import 'package:finance_manager_app/providers/category/category_provider.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/providers/homeProvider/home_provider.dart';
import 'package:finance_manager_app/providers/languageProvider/language_translator_provider.dart';
import 'package:finance_manager_app/providers/notesProvider/notes_provider.dart';
import 'package:finance_manager_app/providers/reportProvider/report_provider.dart';
import 'package:finance_manager_app/providers/reminderProvider/reminder_provider.dart';
import 'package:finance_manager_app/providers/savingsProvider/savings_provider.dart';
import 'package:finance_manager_app/providers/speechProvider/speech_provider.dart';
import 'package:finance_manager_app/providers/theme_provider.dart';
import 'package:finance_manager_app/providers/givenTakenProvider/given_taken_provider.dart';
import 'package:finance_manager_app/services/analytics/analytics_service.dart';
import 'package:finance_manager_app/services/bkash/bkash_deep_link_handler.dart';
import 'package:finance_manager_app/views/splashView/splash_view.dart';

import 'package:flutter/material.dart';

import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await AnalyticsService.instance.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageTranslatorProvider()),
        ChangeNotifierProvider(
          create: (_) => AddExpenseProvider(
            addTransactionDbHelper: AddTransactionDbHelper.getInstance,
          ),
        ),

        ChangeNotifierProxyProvider<AddExpenseProvider, HomeViewProvider>(
          lazy: true,
          create: (context) => HomeViewProvider(
            transactionProvider: context.read<AddExpenseProvider>(),
          ),
          update: (context, txProvider, previous) {
            previous!.transactionProvider = txProvider; // <- update dependency
            return previous; // <- return the SAME instance
          },
        ),
        ChangeNotifierProxyProvider<AddExpenseProvider, CategoryItemProvider>(
          lazy: true,
          create: (context) => CategoryItemProvider(
            transactionProvider: context.read<AddExpenseProvider>(),
          ),

          update: (context, txProvider, previous) =>
              CategoryItemProvider(transactionProvider: txProvider),
        ),

        ChangeNotifierProxyProvider<AddExpenseProvider, ReportProvider>(
          lazy: true,
          create: (context) => ReportProvider(
            transactionProvider: context.read<AddExpenseProvider>(),
          ),
          update: (context, txProvider, previous) {
            previous!.transactionProvider = txProvider; // <- update dependency
            return previous; // <- return the SAME instance
          },
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
        ChangeNotifierProvider(create: (_) => SavingsProvider()),

        ChangeNotifierProxyProvider<AddExpenseProvider, BudgetProvider>(
          lazy: true,
          create: (context) => BudgetProvider(
            transactionProvider: context.read<AddExpenseProvider>(),
          ),
          update: (_, txProvider, budgetProvider) {
            if (budgetProvider == null) {
              return BudgetProvider(transactionProvider: txProvider);
            }

            return budgetProvider;
          },
        ),
        ChangeNotifierProvider(create: (_) => AiProvider()),
        ChangeNotifierProvider(create: (_) => SpeechProvider()),
        ChangeNotifierProvider(create: (_) => GivenTakenProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
        ChangeNotifierProvider(create: (_) => BazarProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => RecurringProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageTranslatorProvider, ThemeProvider>(
      builder: (context, provider, themeProvider, child) {
        return GetMaterialApp(
          title: 'Finance Manager',
          debugShowCheckedModeBanner: false,
          theme: AppThemes.getTheme(
            Brightness.light,
            provider.locale.languageCode,
          ),
          darkTheme: AppThemes.getTheme(
            Brightness.dark,
            provider.locale.languageCode,
          ),
          themeMode: themeProvider.themeMode, // system / light / dark
          getPages: Routes.views,
          translations: AppTranslations(),
          locale: provider.locale,
          fallbackLocale: const Locale('en', 'US'),
          home: _AppHome(),
        );
      },
    );
  }
}

/// Wrapper home widget that initialises deep link handling once
/// a valid [BuildContext] is available after the first frame.
class _AppHome extends StatefulWidget {
  const _AppHome();

  @override
  State<_AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<_AppHome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BkashDeepLinkHandler.instance.initialize(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashView();
  }
}
