import 'package:finance_manager_app/views/analysisView/analysis_view.dart';
import 'package:finance_manager_app/views/categoryView/category_view.dart';
import 'package:finance_manager_app/views/homeView/home_view.dart';
import 'package:finance_manager_app/views/profileView/profile_view.dart';
import 'package:finance_manager_app/views/transactionView/transaction_view.dart';
import 'package:flutter/material.dart';

import '../../config/myColors/my_colors.dart';

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
      bottomNavigationBar: _buildBottomNavigationBar(),);
  }
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: MyColors.carbbeanGreen,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            activeIcon: Icon(Icons.swap_horiz),
            label: 'Transfer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
