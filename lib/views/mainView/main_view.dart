import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/providers/theme_provider.dart';
import 'package:finance_manager_app/views/categoryView/category_view.dart';
import 'package:finance_manager_app/views/homeView/home_view.dart';
import 'package:finance_manager_app/views/UserprofileView/profile_view.dart';
import 'package:finance_manager_app/views/reportView/report_view.dart';
import 'package:finance_manager_app/views/transactionView/transaction_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  List screens = [
    HomeView(),
    ReportView(),
    TransactionView(),
    CategoryView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
        IconButton(onPressed: (){
          context.read<ThemeProvider>().toggleTheme();
        }, icon: Icon( context.watch<ThemeProvider>().isDark ? Icons.dark_mode : Icons.light_mode)),
          IconButton(onPressed: (){}, icon: Icon(Icons.notifications))
      ]
      ,),
      body: screens[_selectedIndex],

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: AppColors.darkCardBackground,
        color: AppColors.primaryBlue,
        height: 70,
        index: _selectedIndex,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.analytics, size: 30),
          Icon(Icons.add, size: 30),
          Icon(Icons.category, size: 30),
          Icon(Icons.person, size: 30),
        ],
        onTap: (index) {
          //Handle button tap
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
