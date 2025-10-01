import 'package:finance_manager_app/config/routes/routes.dart';
import 'package:finance_manager_app/config/theme/app_theme.dart';
import 'package:finance_manager_app/config/translator/app_translator.dart';
import 'package:finance_manager_app/providers/budget/budget_provider.dart';
import 'package:finance_manager_app/providers/category/category_item_provider.dart';
import 'package:finance_manager_app/providers/category/category_provider.dart';
import 'package:finance_manager_app/providers/category/expense_provider.dart';
import 'package:finance_manager_app/providers/home_provider.dart';
import 'package:finance_manager_app/providers/language_translator_provider.dart';
import 'package:finance_manager_app/providers/report_provider.dart';
import 'package:finance_manager_app/providers/theme_provider.dart';
import 'package:finance_manager_app/views/splashView/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageTranslatorProvider()),
        ChangeNotifierProvider(create: (_) => AddExpenseProvider()..getAllExpenses()),
        ChangeNotifierProvider(create: (_) => CategoryItemProvider()),
        ChangeNotifierProxyProvider<AddExpenseProvider, HomeViewProvider>(
          create: (context) => HomeViewProvider(transactionProvider: context.read<AddExpenseProvider>()),
          update: (context, txProvider, previous) => HomeViewProvider(transactionProvider: txProvider),
        ),  ChangeNotifierProxyProvider<AddExpenseProvider, ReportProvider>(
          create: (context) => ReportProvider(transactionProvider: context.read<AddExpenseProvider>()),
          update: (context, txProvider, previous) => ReportProvider(transactionProvider: txProvider),
        ),         ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()..loadBudgets()),
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
    );
  }
}
