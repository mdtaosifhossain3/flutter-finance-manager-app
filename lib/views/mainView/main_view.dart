import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/views/budgetView/budget_view.dart';
import 'package:finance_manager_app/views/homeView/home_view.dart';
import 'package:finance_manager_app/views/reportView/report_view.dart';
import 'package:finance_manager_app/views/settingView/setting_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentPage = 0;

  static const int _tabCount = 4;
  static const Duration _animationDuration = Duration(milliseconds: 500);
  static const double _iconSize = 28;
  static const double _tabHeight = 70;
  static const double _tabWidth = 50;

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

  void _onFabPressed() {
    _changePage(2);
    _tabController.animateTo(2);
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
       // borderRadius: BorderRadius.circular(500),
        width: double.infinity,
        duration: _animationDuration,
        curve: Curves.decelerate,
        showIcon: true,
        barColor: Theme.of(context).dividerColor,
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
          children: const [
            HomeView(),
            ReportView(),
            BudgetView(),
            SettingsPage(),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            _buildTabBar(),
            _buildFloatingActionButton(context),
          ],
        ),
      ),
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

  Widget _buildTabBar() {
    return TabBar(
      dividerColor: Colors.transparent,
      indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
      controller: _tabController,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: Colors.transparent, width: 0),
      ),
      tabs: [
        _buildTabItem(Icons.home, 0),
        _buildTabItem(Icons.analytics, 1),
        _buildTabItem(Icons.wallet, 3),
        _buildTabItem(Icons.settings, 4),
      ],
    );
  }

  Widget _buildTabItem(IconData icon, int pageIndex) {
    final isActive = _currentPage == pageIndex;
    final color = isActive ? AppColors.primaryBlue : AppColors.textMuted;

    return SizedBox(
      height: _tabHeight,
      width: _tabWidth,
      child: Center(
        child: Icon(
          icon,
          color: color,
          size: _iconSize,
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Positioned(
      top: -25,

      child: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: AppColors.textPrimary,
        elevation: 8,
        onPressed: _onFabPressed,
        child: const Icon(Icons.add, size: _iconSize),
      ),
    );
  }
}