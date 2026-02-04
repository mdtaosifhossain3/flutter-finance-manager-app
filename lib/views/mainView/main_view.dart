import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/config/routes/routes_name.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:finance_manager_app/views/aiVIew/add_with_ai.dart';
import 'package:finance_manager_app/views/categoryView/category_view.dart';
import 'package:finance_manager_app/views/homeView/home_view.dart';
import 'package:finance_manager_app/views/moreView/more_view.dart';
import 'package:finance_manager_app/views/reportView/report_view.dart';
import 'package:finance_manager_app/providers/proProvider/pro_provider.dart';
import 'package:finance_manager_app/views/settingView/setting_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  late AnimationController _fabAnimationController;

  final List<Widget> _pages = const [
    HomeView(),
    ReportView(),
    SettingsPage(),
    MoreView(),
  ];

  List<_NavItem> _navItems(BuildContext context) {
    return [
      _NavItem(icon: FontAwesomeIcons.house, label: 'home'.tr),
      _NavItem(icon: FontAwesomeIcons.chartPie, label: 'report'.tr),
      _NavItem(icon: FontAwesomeIcons.gear, label: 'settings'.tr),
      _NavItem(icon: FontAwesomeIcons.crown, label: 'pro_button'.tr),
    ];
  }

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProProvider>(context, listen: false).initializeProStatus();
    });
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _changePage(int index) {
    setState(() => _currentPage = index);
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
                  onTap: () async {
                    Navigator.pop(context);
                    final hasAccess = Provider.of<ProProvider>(
                      context,
                      listen: false,
                    ).checkAccess();
                    if (hasAccess) {
                      Get.to(AddWithAiScreen());
                    }
                  },
                ),
                const SizedBox(height: 12),
                _buildAddOption(
                  icon: Icons.edit_rounded,
                  title: 'add_manually'.tr,
                  subtitle: 'enter_details'.tr,
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(CategoryView());
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

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    final isActive = _currentPage == index;

    return Expanded(
      child: InkWell(
        onTap: onTap ?? () => _changePage(index),
        splashColor: AppColors.primaryBlue.withValues(alpha: 0.1),
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(isActive ? 10 : 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primaryBlue.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FaIcon(
                  icon,
                  size: 22,
                  color: isActive ? AppColors.primaryBlue : AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive ? AppColors.primaryBlue : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProBottomSheet() {
    final theme = Theme.of(context);

    final hasAccess = Provider.of<ProProvider>(
      context,
      listen: false,
    ).checkAccess();
    if (hasAccess) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 24),
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.textMuted.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.06,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'pro_features'
                            .tr, // Make sure to add this key or use a suitable title
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 24),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 0.85,
                        children: [
                          _proItem(
                            icon: Icons.auto_awesome_rounded,
                            label: 'add_with_ai'.tr,
                            color: Colors.indigo,
                            onTap: () => Get.to(AddWithAiScreen()),
                          ),
                          _proItem(
                            icon: FontAwesomeIcons.handshake,
                            label: 'given_taken'.tr,
                            color: Colors.blue,
                            onTap: () => Get.toNamed(RoutesName.givenTakenView),
                          ),
                          _proItem(
                            icon: FontAwesomeIcons.wallet,
                            label: 'budget'.tr,
                            color: Colors.green,
                            onTap: () => Get.toNamed(RoutesName.budgetView),
                          ),
                          _proItem(
                            icon: FontAwesomeIcons.bell,
                            label: 'reminder'.tr,
                            color: Colors.orange,
                            onTap: () => Get.toNamed(RoutesName.reminderView),
                          ),
                          _proItem(
                            icon: FontAwesomeIcons.piggyBank,
                            label: 'savings'.tr,
                            color: Colors.purple,
                            onTap: () => Get.toNamed(RoutesName.savingsView),
                          ),
                          _proItem(
                            icon: FontAwesomeIcons.noteSticky,
                            label: 'note'.tr,
                            color: Colors.teal,
                            onTap: () => Get.toNamed(RoutesName.noteView),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      );
    }
  }

  Widget _proItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: isDark ? Colors.grey[300] : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final navItems = _navItems(context);

    return Scaffold(
      body: _pages[_currentPage],
      floatingActionButton: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.85).animate(
          CurvedAnimation(
            parent: _fabAnimationController,
            curve: Curves.easeInOut,
          ),
        ),

        child: FloatingActionButton(
          onPressed: _showAddOptions,
          backgroundColor: AppColors.primaryBlue,
          elevation: 4,
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomAppBar(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          notchMargin: 6,
          shape: const CircularNotchedRectangle(),
          color: Colors.transparent,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                index: 0,
                icon: navItems[0].icon,
                label: navItems[0].label,
              ),
              _buildNavItem(
                index: 1,
                icon: navItems[1].icon,
                label: navItems[1].label,
              ),
              const SizedBox(width: 60), // Space for FAB

              _buildNavItem(
                index: 3,
                icon: navItems[3].icon,
                label: navItems[3].label,
                onTap: _showProBottomSheet,
              ),
              _buildNavItem(
                index: 2,
                icon: navItems[2].icon,
                label: navItems[2].label,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  _NavItem({required this.icon, required this.label});
}
