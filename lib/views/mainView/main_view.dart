
import "package:curved_navigation_bar/curved_navigation_bar.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../providers/theme_provider.dart";
import "../UserprofileView/profile_view.dart";
import "../categoryView/category_view.dart";
import "../homeView/home_view.dart";
import "../reportView/report_view.dart";
import "../transactionView/transaction_view.dart";
class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MainView> {
  int _page = 0;

  // ✅ Pages for each tab
  List screens = [
    HomeView(),
    ReportView(),
    TransactionView(),
    CategoryView(),
    ProfileView(),
  ];

  // ✅ Bottom nav items (icon + text)
  final items = <Widget>[
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.home, color: Colors.deepPurple),
        Text("Home", style: TextStyle(color: Colors.deepPurple, fontSize: 12)),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.analytics, color: Colors.deepPurple),
        Text("Search", style: TextStyle(color: Colors.deepPurple, fontSize: 12)),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.transfer_within_a_station, color: Colors.deepPurple),
        Text("Likes", style: TextStyle(color: Colors.deepPurple, fontSize: 12)),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.category ,color: Colors.deepPurple),
        Text("Profile", style: TextStyle(color: Colors.deepPurple, fontSize: 12)),

  ],
  ),
  Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
  Icon(Icons.person ,color: Colors.deepPurple),
  Text("Profile", style: TextStyle(color: Colors.deepPurple, fontSize: 12)),
  ]
  )
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(


      // ✅ This swaps screens
      body: screens[_page],

      bottomNavigationBar: CurvedNavigationBar(
        height: 70,
        index: _page,
        items: items,
        color: Colors.grey,
        backgroundColor: Colors.transparent,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _page = index; // ✅ Changes screen
          });
        },
      ),
    );
  }
}