import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/views/aiVIew/add_with_ai.dart';
import 'package:finance_manager_app/views/budgetView/budget_view.dart';
import 'package:finance_manager_app/views/categoryView/category_view.dart';
import 'package:finance_manager_app/views/homeView/home_view.dart';
import 'package:finance_manager_app/views/reminderView/reminder_view.dart';
import 'package:finance_manager_app/views/reportView/report_view.dart';
import 'package:finance_manager_app/views/settingView/setting_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentPage = 0;

  static const int _tabCount = 5;

  final List<IconData> _iconItems = [
    Icons.home,
    Icons.analytics,
    Icons.wallet,
    Icons.schedule,
    Icons.settings,
  ];

  final List<String> _labels = [
    'home'.tr,
    'report'.tr,
    'budget'.tr,
    'reminder'.tr,
    'settings'.tr,
  ];

  final List<Widget> _pages = const [
    HomeView(),
    ReportView(),

    BudgetView(),
    ReminderView(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
    _tabController.animation?.addListener(_onTabAnimationChange);
  }

  void _onTabAnimationChange() {
    final value = _tabController.animation!.value.round();
    if (value != _currentPage && mounted) {
      _changePage(value);
    }
  }

  void _changePage(int newPage) {
    setState(() => _currentPage = newPage);
  }

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 24,
              horizontal: MediaQuery.of(context).size.width * 0.04,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                _buildAddOption(
                  icon: Icons.auto_awesome_rounded,
                  title: 'add_with_ai'.tr,
                  subtitle: 'smart_categorization'.tr,
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const AddWithAiScreen());
                  },
                ),
                const SizedBox(height: 12),
                _buildAddOption(
                  icon: Icons.edit_rounded,
                  title: 'add_manually'.tr,
                  subtitle: 'enter_details'.tr,
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const CategoryView());
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primaryBlue, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.textMuted,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: TabBarView(
        controller: _tabController,
        dragStartBehavior: DragStartBehavior.down,
        physics: const BouncingScrollPhysics(),
        children: _pages,
      ),

      // ✅ Bottom navigation goes here
      // bottomNavigationBar: AnimatedBottomNavigationBar.builder(
      //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //   elevation: 0,
      //   itemCount: _iconItems.length,
      //   activeIndex: _currentPage,
      //   // gapLocation: GapLocation.end,
      //   notchSmoothness: NotchSmoothness.softEdge,
      //   leftCornerRadius: 0,
      //   rightCornerRadius: 0,
      //   splashColor: AppColors.purpleGradientEnd,
      //   onTap: (index) {
      //     _changePage(index);
      //     _tabController.animateTo(index);
      //   },
      //   tabBuilder: (int index, bool isActive) {
      //     final color = isActive ? AppColors.primaryBlue : AppColors.textMuted;
      //     return Column(
      //       mainAxisSize: MainAxisSize.min,
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Icon(_iconItems[index], size: 24, color: color),
      //         const SizedBox(height: 4),
      //         Text(
      //           _labels[index],
      //           style: TextStyle(
      //             color: color,
      //             fontSize: 10,
      //             fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
      //           ),
      //         ),
      //       ],
      //     );
      //   },
      // ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentPage,
        onTap: (index) {
          _changePage(index);
          _tabController.animateTo(index);
        },
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.textMuted,
        elevation: 8,
        items: List.generate(_iconItems.length, (index) {
          return BottomNavigationBarItem(
            icon: Icon(_iconItems[index]),
            label: _labels[index],
          );
        }),
      ),
      // ✅ FAB stays here
      floatingActionButton: _currentPage == 2 || _currentPage == 3
          ? null
          : Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white, size: 26),
                onPressed: _showAddOptions,
              ),
            ),
      //  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
