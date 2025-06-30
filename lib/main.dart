import 'package:finance_manager_app/config/routes/routes.dart';
import 'package:finance_manager_app/config/theme/my_theme.dart';
import 'package:finance_manager_app/views/analysisView/analysis_view.dart';
import 'package:finance_manager_app/views/analysisView/calenderView/calender_view.dart';
import 'package:finance_manager_app/views/analysisView/searchView/search_view.dart';
import 'package:finance_manager_app/views/homeView/home_view.dart';
import 'package:finance_manager_app/views/mainView/main_view.dart';
import 'package:finance_manager_app/views/splashView/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Finance Manager',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,

      getPages: Routes.views,
      home: MainView(),
    );
  }
}
