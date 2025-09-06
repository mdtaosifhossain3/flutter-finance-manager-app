import 'package:finance_manager_app/config/myColors/my_colors.dart';
import 'package:finance_manager_app/data/add_income_data.dart';
import 'package:finance_manager_app/globalWidgets/balance_expense_card_widget.dart';
import 'package:finance_manager_app/globalWidgets/progress_bar_widget.dart';
import 'package:finance_manager_app/views/categoryView/pages/categoryItemView/category_item_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/expense_provider.dart';

class AddIncomeView extends StatelessWidget {
  const AddIncomeView({super.key});

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
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: MyColors.whiteColor,
                          size: 24,
                        ),
                      ),
                      const Text(
                        'Categories',
                        style: TextStyle(
                          color: MyColors.whiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: MyColors.whiteWithAlpha20,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          color: MyColors.whiteColor,
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
                  color: MyColors.whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: GridView.builder(
                    itemCount: addIncomeData.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                    itemBuilder: (BuildContext context, int index) {
                      return _buildCategoryItem(
                        context,
                        addIncomeData[index],
                        Icons.category,
                        MyColors.carbbeanGreen,
                        () => _navigateToCategory(
                          context,
                          addIncomeData[index],
                          Icons.category,
                        ),
                      );
                    },
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
              child: Icon(icon, color: MyColors.whiteColor, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: MyColors.cyprus,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
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
