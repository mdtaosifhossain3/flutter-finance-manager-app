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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key,}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentPage = 0;

  static const int _tabCount = 5;
  static const Duration _animationDuration = Duration(milliseconds: 500);
  static const double _iconSize = 24;
  static const double _tabHeight = 55;
  static const double _tabWidth = 40;
  static const double _fabSize = 25;
  static const double _indicatorWidth = 4;

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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              _buildAddOption(
                icon: Icons.auto_awesome,
                title: 'Add with AI',
                subtitle: 'Let AI help you categorize',
                onTap: () {
                  Navigator.pop(context);
                  _handleAddWithAI();
                },
              ),
              const SizedBox(height: 12),
              _buildAddOption(
                icon: Icons.edit,
                title: 'Add Manually',
                subtitle: 'Enter details yourself',
                onTap: () {
                  Navigator.pop(context);
                  _handleAddManually();
                },
              ),
              const SizedBox(height: 16),
            ],
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
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textMuted,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAddWithAI() {

    Get.to(AddWithAiScreen());

  }

  void _handleAddManually() {
    _changePage(2);
    _tabController.animateTo(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BottomBar(
          clip: Clip.none,
          fit: StackFit.expand,
          icon: _buildBarIcon,
          borderRadius: BorderRadius.circular(500),
          duration: _animationDuration,
          curve: Curves.decelerate,
          showIcon: true,
         width: MediaQuery.of(context).size.width * 0.9,
         barColor:Colors.transparent,
         barDecoration:   BoxDecoration(
           color: Theme.of(context).colorScheme.surface,
           borderRadius: BorderRadius.circular(500),
           border: Border.all(color: Theme.of(context).dividerColor),
           boxShadow: [
             BoxShadow(
               color:Theme.of(context).cardColor.withValues(alpha:0.3),
               blurRadius: 12,
               offset: const Offset(0, 6),
             ),
           ],
         ),

          start: 2,
          end: 0,
          offset: 10,
          barAlignment: Alignment.bottomCenter,
          iconHeight: 30,
          iconWidth: 30,
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
           CategoryView(),
              BudgetView(),
              SettingsPage(),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              _buildTabBar(),
              _buildFloatingActionButton(),
            ],
          ),
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
      padding: EdgeInsets.symmetric(horizontal: (_tabWidth - _iconSize) / 2),
      indicatorSize: TabBarIndicatorSize.tab,
      labelPadding: EdgeInsets.zero,
      dividerColor: Colors.transparent,
      indicatorPadding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
      controller: _tabController,
      overlayColor: WidgetStateProperty.all(Colors.transparent), // 👈 removes pressed overlay
      splashFactory: NoSplash.splashFactory,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: _indicatorWidth,
        ),
        insets: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      ),
      tabs: [
        _buildTabItem(Icons.home, 0),
        _buildTabItem(Icons.analytics, 1),
        SizedBox(width: _tabWidth),
       // _buildFloatingActionButton(),
        _buildTabItem(Icons.wallet, 3),
        _buildTabItem(Icons.settings, 4),
      ],
    );
  }

  Widget _buildTabItem(IconData icon, int pageIndex) {
    final isActive = _currentPage == pageIndex;
    final Color activeBg = AppColors.primaryBlue;
    final Color inactiveColor = AppColors.textMuted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 50,
      width: 50,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric( vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? activeBg : Colors.transparent,
    borderRadius: BorderRadius.circular(22)
      ),
      child: Icon(
        icon,
        color: isActive ? AppColors.textPrimary : inactiveColor,
        size: 27,
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Positioned(
     top: -25,
      child: GestureDetector(
        onTap: _showAddOptions,

        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(Icons.add,size: 32,color: AppColors.textPrimary,)
        ),
      ),
    );
  }
}