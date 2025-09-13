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
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            selectedColor: Colors.purple,
          ),

          /// Report
          SalomonBottomBarItem(
            icon: Icon(Icons.analytics),
            title: Text("Report"),
            selectedColor: Colors.pink,
          ),

          /// Budget
          SalomonBottomBarItem(
            icon: Icon(Icons.search),
            title: Text("Budget"),
            selectedColor: Colors.orange,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: Icon(Icons.swap_horiz),
            title: Text("Categories"),
            selectedColor: Colors.teal,
          ),

          /// Add Transaction
          SalomonBottomBarItem(
            icon: Icon(Icons.swap_horiz),
            title: Text("Add Transaction"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}
