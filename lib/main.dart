import 'package:finance_manager_app/config/routes/routes.dart';
import 'package:finance_manager_app/providers/category_item_provider.dart';
import 'package:finance_manager_app/providers/expense_provider.dart';
import 'package:finance_manager_app/providers/home_provider.dart';
import 'package:finance_manager_app/providers/theme_provider.dart';
import 'package:finance_manager_app/views/splashView/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AddExpenseProvider()),
        ChangeNotifierProvider(create: (_) => CategoryItemProvider()),
        ChangeNotifierProvider(create: (_) => HomeViewProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GetMaterialApp(
      title: 'Finance Manager',
      debugShowCheckedModeBanner: false,

      theme: themeProvider.theme,
      getPages: Routes.views,
      home: SplashView(),
    );
  }
}
