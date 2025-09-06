import 'package:finance_manager_app/config/myColors/my_colors.dart';
import 'package:finance_manager_app/globalWidgets/balance_expense_card_widget.dart';
import 'package:finance_manager_app/globalWidgets/progress_bar_widget.dart';
import 'package:finance_manager_app/providers/expense_provider.dart';
import 'package:finance_manager_app/views/categoryView/pages/add_expense_view.dart';
import 'package:finance_manager_app/views/categoryView/pages/add_income_view.dart';
import 'package:finance_manager_app/views/categoryView/pages/categoryItemView/category_item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CategorySelectionView extends StatelessWidget {
  const CategorySelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.carbbeanGreen,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // App Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // IconButton(
                      //   onPressed: () => Navigator.pop(context),
                      //   icon: const Icon(
                      //     Icons.arrow_back,
                      //     color: Colors.white,
                      //     size: 24,
                      //   ),
                      // ),
                      const Text(
                        'Add Transaction',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Balance Cards
                  BalanceExpenseCardWidget(),
                  const SizedBox(height: 20),

                  ProgressBarWidget(),
                ],
              ),
            ),

            // Categories Section
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Add Income Button
                      Container(
                        width: double.infinity,
                        height: 60,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to Add Income View
                            Get.to(AddIncomeView());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.carbbeanGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: MyColors.whiteWithAlpha20,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.add_circle_outline,
                                  color: MyColors.whiteColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Add Income',
                                style: TextStyle(
                                  color: MyColors.whiteColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Add Expense Button
                      Container(
                        width: double.infinity,
                        height: 60,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to Add Expense View
                            Get.to(AddExpenseView());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.whiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: const BorderSide(
                                color: MyColors.carbbeanGreen,
                                width: 2,
                              ),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: MyColors.lightGreen,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.remove_circle_outline,
                                  color: MyColors.carbbeanGreen,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Add Expense',
                                style: TextStyle(
                                  color: MyColors.carbbeanGreen,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: MyColors.cyprus,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCategory(BuildContext context, String categoryName, icon) {
    context.read<AddExpenseProvider>().setCategoryIcon(icon);
    // Navigate to category detail page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryItemView(categoryName: categoryName),
      ),
    );
  }
}
