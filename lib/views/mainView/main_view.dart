import 'package:finance_manager_app/views/analysisView/analysis_view.dart';
import 'package:finance_manager_app/views/categoryView/category_view.dart';
import 'package:finance_manager_app/views/homeView/home_view.dart';
import 'package:finance_manager_app/views/UserprofileView/profile_view.dart';
import 'package:finance_manager_app/views/transactionView/transaction_view.dart';
import 'package:flutter/material.dart';
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
    AnalysisScreen(),
    TransactionView(),
    CategoryView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.analytics),
            title: Text("Analysis"),
            selectedColor: Colors.pink,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: Icon(Icons.search),
            title: Text("Search"),
            selectedColor: Colors.orange,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: Icon(Icons.swap_horiz),
            title: Text("Categories"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }

}
