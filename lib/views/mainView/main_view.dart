import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/views/aiVIew/add_with_ai.dart';
import 'package:finance_manager_app/views/budgetView/budget_view.dart';
import 'package:finance_manager_app/views/categoryView/category_view.dart';
import 'package:finance_manager_app/views/givenTakenView/given_taken_view.dart';
import 'package:finance_manager_app/views/homeView/home_view.dart';
import 'package:finance_manager_app/views/moreView/more_view.dart';
import 'package:finance_manager_app/views/reportView/report_view.dart';
import 'package:finance_manager_app/providers/proProvider/pro_provider.dart';
import 'package:flutter/gestures.dart';
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
  late TabController _tabController;
  int _currentPage = 0;

  static const int _tabCount = 5;

  final List<IconData> _iconItems = [
    Icons.home,
    Icons.analytics,
    Icons.wallet,
    Icons.handshake_outlined,
    Icons.more_horiz,
  ];

  List<String> _labels(BuildContext context) {
    return ['home'.tr, 'report'.tr, 'budget'.tr, 'given_taken'.tr, 'more'.tr];
  }

  final List<Widget> _pages = const [
    HomeView(),
    ReportView(),
    BudgetView(),
    GivenTakenView(),
    MoreView(),
    // SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
    _tabController.animation?.addListener(_onTabAnimationChange);

    // Ensure Pro status is up to date (e.g. after login)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProProvider>(context, listen: false).initializeProStatus();
    });
  }

  void _onTabAnimationChange() {
    if (_tabController.indexIsChanging) return;
    final value = _tabController.animation!.value.round();
    if (value != _currentPage && mounted) {
      _changePage(value);
    }
  }

  void _changePage(int newPage) {
    // Protect Report (1), Budget (2), Reminder (3)
    if (newPage == 1 || newPage == 2 || newPage == 3) {
      final hasAccess = Provider.of<ProProvider>(
        context,
        listen: false,
      ).checkAccess();
      if (!hasAccess) {
        // Revert tab controller if it was a tap on the tab bar
        if (_tabController.index != _currentPage) {
          _tabController.animateTo(_currentPage);
        }
        return;
      }
    }
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
                  onTap: () async {
                    Navigator.pop(context);
                    final hasAccess = Provider.of<ProProvider>(
                      context,
                      listen: false,
                    ).checkAccess();
                    if (hasAccess) {
                      Get.to(() => const AddWithAiScreen());
                    }

                    // int count = await ProTapService.incrementTap();

                    // if (count >= 2) {
                    //   // Show Go Pro screen / modal
                    //   Get.defaultDialog(
                    //     title: "",
                    //     backgroundColor: Colors.white,
                    //     radius: 20,
                    //     barrierDismissible: false,
                    //     contentPadding: const EdgeInsets.all(0),

                    //     content: Column(
                    //       children: [
                    //         // Title
                    //         Text(
                    //           "more_ai".tr,
                    //           style: TextStyle(
                    //             fontSize: 24,
                    //             fontWeight: FontWeight.bold,
                    //             color: Colors.black,
                    //           ),
                    //           textAlign: TextAlign.center,
                    //         ),

                    //         const SizedBox(height: 6),

                    //         // Description
                    //         Padding(
                    //           padding: const EdgeInsets.symmetric(
                    //             horizontal: 24,
                    //           ),
                    //           child: Text(
                    //             "endedai".tr,
                    //             style: TextStyle(
                    //               fontSize: 14,
                    //               color: Colors.grey[600],
                    //               height: 1.5,
                    //             ),
                    //             textAlign: TextAlign.center,
                    //           ),
                    //         ),

                    //         const SizedBox(height: 20),

                    //         // Amount Box
                    //         Container(
                    //           margin: const EdgeInsets.symmetric(
                    //             horizontal: 24,
                    //           ),
                    //           padding: const EdgeInsets.symmetric(
                    //             vertical: 24,
                    //             horizontal: 20,
                    //           ),
                    //           decoration: BoxDecoration(
                    //             gradient: const LinearGradient(
                    //               begin: Alignment.topLeft,
                    //               end: Alignment.bottomRight,
                    //               colors: [
                    //                 Color(0xFF2563EB),
                    //                 Color(0xFF1E40AF),
                    //               ],
                    //             ),
                    //             borderRadius: BorderRadius.circular(16),
                    //             boxShadow: [
                    //               BoxShadow(
                    //                 color: const Color(
                    //                   0xFF2563EB,
                    //                 ).withValues(alpha: 0.3),
                    //                 blurRadius: 16,
                    //                 offset: const Offset(0, 8),
                    //               ),
                    //             ],
                    //           ),
                    //           child: Column(
                    //             children: [
                    //               Row(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.baseline,
                    //                 textBaseline: TextBaseline.alphabetic,
                    //                 children: [
                    //                   Text(
                    //                     HelperFunctions.convertToBanglaDigits(
                    //                       "30",
                    //                     ),
                    //                     style: TextStyle(
                    //                       fontSize: 56,
                    //                       fontWeight: FontWeight.bold,
                    //                       color: Colors.white,
                    //                     ),
                    //                   ),
                    //                   const SizedBox(width: 6),
                    //                   const Text(
                    //                     "৳",
                    //                     style: TextStyle(
                    //                       fontSize: 40,
                    //                       fontWeight: FontWeight.bold,
                    //                       color: Color(0xFFBFDBFE),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //               const SizedBox(height: 8),
                    //               Text(
                    //                 "30days".tr,
                    //                 style: TextStyle(
                    //                   fontSize: 13,
                    //                   fontWeight: FontWeight.w500,
                    //                   color: Colors.white,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),

                    //         const SizedBox(height: 20),

                    //         // Buttons
                    //         Padding(
                    //           padding: const EdgeInsets.symmetric(
                    //             horizontal: 24,
                    //           ),
                    //           child: Row(
                    //             children: [
                    //               // Cancel Button
                    //               Expanded(
                    //                 child: Container(
                    //                   height: 52,
                    //                   decoration: BoxDecoration(
                    //                     color: Colors.grey[100],
                    //                     borderRadius: BorderRadius.circular(12),
                    //                     border: Border.all(
                    //                       color: Colors.grey[300]!,
                    //                       width: 1.5,
                    //                     ),
                    //                   ),
                    //                   child: Material(
                    //                     color: Colors.transparent,
                    //                     child: InkWell(
                    //                       onTap: () => Get.back(),
                    //                       borderRadius: BorderRadius.circular(
                    //                         12,
                    //                       ),
                    //                       child: Center(
                    //                         child: Text(
                    //                           "cancelBuy".tr,
                    //                           style: TextStyle(
                    //                             color: Colors.grey[700],
                    //                             fontSize: 16,
                    //                             fontWeight: FontWeight.w600,
                    //                             letterSpacing: 0.3,
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),

                    //               const SizedBox(width: 12),

                    //               // Buy Now Button
                    //               Expanded(
                    //                 child: Container(
                    //                   height: 52,
                    //                   decoration: BoxDecoration(
                    //                     gradient: const LinearGradient(
                    //                       colors: [
                    //                         Color(0xFF2563EB),
                    //                         Color(0xFF1E40AF),
                    //                       ],
                    //                     ),
                    //                     borderRadius: BorderRadius.circular(12),
                    //                     boxShadow: [
                    //                       BoxShadow(
                    //                         color: const Color(
                    //                           0xFF2563EB,
                    //                         ).withValues(alpha: 0.3),
                    //                         blurRadius: 12,
                    //                         offset: const Offset(0, 6),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                   child: Material(
                    //                     color: Colors.transparent,
                    //                     child: InkWell(
                    //                       onTap: () {
                    //                         Get.back();
                    //                         // Navigate to payment
                    //                         // Get.to(() => const PaymentScreen());
                    //                       },
                    //                       borderRadius: BorderRadius.circular(
                    //                         12,
                    //                       ),
                    //                       child: Center(
                    //                         child: Text(
                    //                           "buy".tr,
                    //                           style: TextStyle(
                    //                             color: Colors.white,
                    //                             fontSize: 16,
                    //                             fontWeight: FontWeight.w600,
                    //                             letterSpacing: 0.3,
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),

                    //         const SizedBox(height: 24),
                    //       ],
                    //     ),
                    //   );
                    // } else {
                    //   // Normal Free Action
                    //   if (kDebugMode) {
                    //     print("Free use: $count/3");
                    //   }
                    // }
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
    final labels = _labels(context);

    return Scaffold(
      extendBody: true,
      body: TabBarView(
        controller: _tabController,
        dragStartBehavior: DragStartBehavior.down,
        physics: const BouncingScrollPhysics(),
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentPage,
        onTap: (index) {
          // Protect Report (1), Budget (2), Reminder (3)
          if (index == 1 || index == 2 || index == 3) {
            final hasAccess = Provider.of<ProProvider>(
              context,
              listen: false,
            ).checkAccess();
            if (!hasAccess) return;
          }

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
            label: labels[index],
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
