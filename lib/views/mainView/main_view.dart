import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/views/budgetView/budget_view.dart';
import 'package:finance_manager_app/views/homeView/home_view.dart';
import 'package:finance_manager_app/views/reportView/report_view.dart';
import 'package:finance_manager_app/views/settingView/setting_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

import '../categoryView/category_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  late int currentPage;
  late TabController tabController;

  @override
  void initState() {
    currentPage = 0;
    tabController = TabController(length: 5, vsync: this);
    tabController.animation?.addListener(() {
      final value = tabController.animation!.value.round();
      if (value != currentPage && mounted) {
        changePage(value);
      }
    });
    super.initState();
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color unselectedColor = AppColors.textMuted;

    return Scaffold(
      body: BottomBar(
        clip: Clip.none,
        fit: StackFit.expand,
        icon: (width, height) => Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: null,
            icon: Icon(
              Icons.arrow_upward_rounded,
              color: unselectedColor,
              size: width,
            ),
          ),
        ),
        //borderRadius: BorderRadius.circular(500),
        duration: Duration(milliseconds: 500),
        curve: Curves.decelerate,
        showIcon: true,
        width: MediaQuery.of(context).size.width,
        barColor: Theme.of(context).scaffoldBackgroundColor,
        start: 2,
        end: 0,
        offset: 0,

        barAlignment: Alignment.bottomCenter,
        iconHeight: 40, // Increased from 30
        iconWidth: 40, // Increased from 30
        reverse: false,
        hideOnScroll: true,
        scrollOpposite: false,
        respectSafeArea: true,
        onBottomBarHidden: () {},
        onBottomBarShown: () {},
        body: (context, controller) => TabBarView(
          controller: tabController,
          dragStartBehavior: DragStartBehavior.down,
          physics: const BouncingScrollPhysics(),
          children: [
            HomeView(),
            ReportView(),
            CategoryView(),
            BudgetView(),
            SettingsPage(),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            TabBar(
              dividerColor: Colors.transparent,
              indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
              controller: tabController,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.transparent, width: 0),
              ),
              tabs: [
                SizedBox(
                  height: 70, // Increased from 55
                  width: 50, // Increased from 40
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          color: currentPage == 0
                              ? AppColors.primaryBlue
                              : unselectedColor,
                          size: 28, // Added explicit size
                        ),
                        Text(
                          "Home",
                          style: TextStyle(
                            color: currentPage == 0
                                ? AppColors.primaryBlue
                                : unselectedColor,
                            fontSize: 10, // Reduced font size for better fit
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 70, // Increased from 55
                  width: 50, // Increased from 40
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.analytics,
                          color: currentPage == 1
                              ? AppColors.primaryBlue
                              : unselectedColor,
                          size: 28, // Added explicit size
                        ),
                        Text(
                          "Report",
                          style: TextStyle(
                            color: currentPage == 1
                                ? AppColors.primaryBlue
                                : unselectedColor,
                            fontSize: 10, // Reduced font size for better fit
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 70, // Increased from 55
                  width: 50, // Increased from 40
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.transparent,
                      size: 28, // Added explicit size
                    ),
                  ),
                ),
                SizedBox(
                  height: 70, // Increased from 55
                  width: 50, // Increased from 40
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wallet,
                          color: currentPage == 3
                              ? AppColors.primaryBlue
                              : unselectedColor,
                          size: 28, // Added explicit size
                        ),
                        Text(
                          "Budget",
                          style: TextStyle(
                            color: currentPage == 3
                                ? AppColors.primaryBlue
                                : unselectedColor,
                            fontSize: 10, // Reduced font size for better fit
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 70, // Increased from 55
                  width: 50, // Increased from 40
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.settings,
                          color: currentPage == 4
                              ? AppColors.primaryBlue
                              : unselectedColor, // Fixed color consistency
                          size: 28, // Added explicit size
                        ),
                        Text(
                          "Profile",
                          style: TextStyle(
                            color: currentPage == 4
                                ? AppColors.primaryBlue
                                : unselectedColor,
                            fontSize: 10, // Reduced font size for better fit
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: -25, // Moved up slightly to accommodate larger bottom bar
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: AppColors.textPrimary,
                onPressed: () {
                  changePage(2);
                  tabController.animateTo(2);
                }, // Added explicit size for consistency
                elevation: 8,
                child: Icon(
                  Icons.add,
                  size: 28,
                ), // Added elevation for better visual separation
              ),
            ),
          ],
        ),
      ),
    );
  }
}
