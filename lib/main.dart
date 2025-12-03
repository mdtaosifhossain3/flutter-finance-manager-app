import 'package:finance_manager_app/config/db/local/category_db/add_transaction_db_helper.dart';
import 'package:finance_manager_app/config/routes/routes.dart';
import 'package:finance_manager_app/config/theme/app_theme.dart';
import 'package:finance_manager_app/config/translator/app_translator.dart';
import 'package:finance_manager_app/providers/aiProvider/ai_provider.dart';
import 'package:finance_manager_app/providers/budget/budget_provider.dart';
import 'package:finance_manager_app/providers/category/category_item_provider.dart';
import 'package:finance_manager_app/providers/category/category_provider.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/providers/homeProvider/home_provider.dart';
import 'package:finance_manager_app/providers/languageProvider/language_translator_provider.dart';
import 'package:finance_manager_app/providers/reportProvider/report_provider.dart';
import 'package:finance_manager_app/providers/reminderProvider/reminder_provider.dart';
import 'package:finance_manager_app/providers/speechProvider/speech_provider.dart';
import 'package:finance_manager_app/providers/theme_provider.dart';

import 'package:finance_manager_app/views/splashView/splash_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

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
          create: (context) => HomeViewProvider(
            transactionProvider: context.read<AddExpenseProvider>(),
          ),
          update: (context, txProvider, previous) {
            previous!.transactionProvider = txProvider; // <- update dependency
            return previous; // <- return the SAME instance
          },
        ),
        ChangeNotifierProxyProvider<AddExpenseProvider, CategoryItemProvider>(
          create: (context) => CategoryItemProvider(
            transactionProvider: context.read<AddExpenseProvider>(),
          ),

          update: (context, txProvider, previous) =>
              CategoryItemProvider(transactionProvider: txProvider),
        ),

        ChangeNotifierProxyProvider<AddExpenseProvider, ReportProvider>(
          create: (context) => ReportProvider(
            transactionProvider: context.read<AddExpenseProvider>(),
          ),
          update: (context, txProvider, previous) {
            previous!.transactionProvider = txProvider; // <- update dependency
            return previous; // <- return the SAME instance
          },
        ),

        // ChangeNotifierProxyProvider<AddExpenseProvider, ReportProvider>(
        //   create: (context) {
        //     final txProvider = context.read<AddExpenseProvider>();
        //     final reportProvider = ReportProvider(
        //       transactionProvider: txProvider,
        //     );

        //     Timer? debounceTimer;

        //     // 🔁 Listen to AddExpenseProvider changes
        //     txProvider.addListener(() {
        //       // Cancel any running timer
        //       debounceTimer?.cancel();

        //       // Start a new timer
        //       debounceTimer = Timer(const Duration(milliseconds: 400), () {
        //         reportProvider.filterCategoryFunction();
        //         reportProvider.getMonthlyTotals();
        //         reportProvider.periodDatafunction();
        //       });
        //     });

        //     return reportProvider;
        //   },
        //   update: (_, txProvider, reportProvider) {
        //     reportProvider!.transactionProvider = txProvider;
        //     return reportProvider;
        //   },
        // ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
        ChangeNotifierProxyProvider<AddExpenseProvider, BudgetProvider>(
          create: (context) => BudgetProvider(
            transactionProvider: context.read<AddExpenseProvider>(),
          ),
          update: (_, txProvider, budgetProvider) {
            // Re-create or update?
            // Since BudgetProvider needs to listen, we might need to update the reference
            // But BudgetProvider constructor sets up the listener.
            // If we just update a field, we need to handle listener attachment/detachment.
            // Simpler to just pass it in constructor if possible, but update is called on rebuilds.
            // Let's use the update to ensure we have the latest provider.
            // Actually, for simplicity and stability, let's just create it with the provider.
            // But ProxyProvider requires update.
            if (budgetProvider == null) {
              return BudgetProvider(transactionProvider: txProvider);
            }
            // If we already have one, we might not need to do anything if the instance is the same
            // But if txProvider changes (unlikely for top level), we might need to update.
            // Let's just return the existing one, assuming AddExpenseProvider instance is stable.
            return budgetProvider;
          },
        ),
        ChangeNotifierProvider(create: (_) => AiProvider()),
        ChangeNotifierProvider(create: (_) => SpeechProvider()),
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
    return GetMaterialApp(
      title: 'Finance Manager',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: context
          .watch<ThemeProvider>()
          .themeMode, // system / light / dark
      getPages: Routes.views,
      translations: AppTranslations(),
      locale: context.watch<LanguageTranslatorProvider>().locale,
      fallbackLocale: const Locale('en', 'US'),
      home: SplashView(),
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
      },
    );
  }
}
