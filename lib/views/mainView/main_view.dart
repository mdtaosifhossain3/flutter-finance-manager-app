import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/views/aiVIew/add_with_ai.dart';
import 'package:finance_manager_app/views/budgetView/budget_view.dart';
import 'package:finance_manager_app/views/categoryView/category_view.dart';
import 'package:finance_manager_app/views/homeView/home_view.dart';
import 'package:finance_manager_app/views/reportView/report_view.dart';
import 'package:finance_manager_app/views/settingView/setting_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
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

  static const int _tabCount = 4;
  static const Duration _animationDuration = Duration(milliseconds: 500);

  final List<IconData> _iconItems = [
    Icons.home,
    Icons.analytics,
    Icons.wallet,
    Icons.settings,
  ];

  final List<String> _labels = [
    'home'.tr,
    'report'.tr,
    'budget'.tr,
    'settings'.tr,
  ];

  final List<Widget> _pages = const [
    HomeView(),
    ReportView(),
    BudgetView(),
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
                  title: 'Add with AI',
                  subtitle: 'Smart categorization',
                  onTap: () {
                    Navigator.pop(context);
                    //  Get.snackbar("Message", "This Feature will come soon");
                    Get.to(() => AddWithAiScreen());
                  },
                ),
                const SizedBox(height: 12),
                _buildAddOption(
                  icon: Icons.edit_rounded,
                  title: 'Add Manually',
                  subtitle: 'Enter details yourself',
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => CategoryView());
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
      body: BottomBar(
        clip: Clip.none,
        fit: StackFit.expand,
        icon: _buildBarIcon,
        width: double.infinity,
        duration: _animationDuration,
        curve: Curves.decelerate,
        showIcon: true,
        // barColor: Theme.of(context).dividerColor,
        start: 2,
        end: 0,
        offset: 0,
        barAlignment: Alignment.bottomCenter,
        iconHeight: 40,
        iconWidth: 40,
        reverse: false,
        hideOnScroll: true,
        scrollOpposite: false,
        respectSafeArea: true,
        onBottomBarHidden: () {},
        onBottomBarShown: () {},
        body: (context, controller) => TabBarView(
          controller: _tabController,
          dragStartBehavior: DragStartBehavior.down,
          physics: const BouncingScrollPhysics(),
          children: _pages,
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [_getTabs(), _buildFloatingActionButton(context)],
        ),
      ),
    );
  }

  Widget _getTabs() {
    return AnimatedBottomNavigationBar.builder(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      itemCount: _iconItems.length,
      activeIndex: _currentPage,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 0,
      rightCornerRadius: 0,
      splashColor: AppColors.purpleGradientEnd,
      onTap: (index) {
        _changePage(index);
        _tabController.animateTo(index);
      },
      tabBuilder: (int index, bool isActive) {
        final color = isActive ? AppColors.primaryBlue : AppColors.textMuted;
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_iconItems[index], size: 24, color: color),
            const SizedBox(height: 4),
            Text(
              _labels[index],
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBarIcon(double width, double height) {
    return Center(
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: null,
        icon: Icon(
          Icons.arrow_upward_rounded,
          color: AppColors.textMuted,
          size: width,
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Positioned(
      top: -28,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Theme.of(context).primaryColor,
          shape: const CircleBorder(),
          elevation: 0,
          child: InkWell(
            onTap: _showAddOptions,
            customBorder: const CircleBorder(),
            child: const Center(
              child: Icon(Icons.add, size: 28, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
