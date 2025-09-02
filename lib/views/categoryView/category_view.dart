import 'package:finance_manager_app/config/myColors/my_colors.dart';
import 'package:finance_manager_app/globalWidgets/balance_expense_card_widget.dart';
import 'package:finance_manager_app/globalWidgets/progress_bar_widget.dart';
import 'package:finance_manager_app/views/categoryView/pages/categoryItemView/category_item_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/expense_provider.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

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
                        'Categories',
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

                  // Progress Bar
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         const Text(
                  //           '30%',
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 14,
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         ),
                  //         const Text(
                  //           '\$20,000.00',
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 14,
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     const SizedBox(height: 8),
                  //     LinearProgressIndicator(
                  //       value: 0.3,
                  //       backgroundColor: Colors.white.withValues(alpha: 0.3),
                  //       valueColor: const AlwaysStoppedAnimation<Color>(
                  //         Colors.white,
                  //       ),
                  //       minHeight: 6,
                  //     ),
                  //     const SizedBox(height: 8),
                  //     const Text(
                  //       '30% of Your Expenses, Looks Good.',
                  //       style: TextStyle(color: Colors.white, fontSize: 12),
                  //     ),
                  //   ],
                  // ),
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
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [

                      _buildCategoryItem(
                        context,
                        'Food',
                        Icons.restaurant,
                        MyColors.lightBlue,
                        () => _navigateToCategory(context, 'Food',Icons.restaurant),
                      ),
                      _buildCategoryItem(
                        context,
                        'Transport',
                        Icons.directions_bus,
                        MyColors.vividBlue,
                        () => _navigateToCategory(context, 'Transport', Icons.directions_bus),
                      ),
                      _buildCategoryItem(
                        context,
                        'Medicine',
                        Icons.medical_services,
                        MyColors.oceanBlue,
                        () => _navigateToCategory(context, 'Medicine', Icons.medical_services),
                      ),
                      _buildCategoryItem(
                        context,
                        'Groceries',
                        Icons.shopping_bag,
                        MyColors.lightBlue,
                        () => _navigateToCategory(context, 'Groceries',Icons.shopping_bag),
                      ),
                      _buildCategoryItem(
                        context,
                        'Rent',
                        Icons.handshake,
                        MyColors.vividBlue,
                        () => _navigateToCategory(context, 'Rent',  Icons.handshake),
                      ),
                      _buildCategoryItem(
                        context,
                        'Gifts',
                        Icons.card_giftcard,
                        MyColors.oceanBlue,
                        () => _navigateToCategory(context, 'Gifts',  Icons.card_giftcard),
                      ),
                      _buildCategoryItem(
                        context,
                        'Savings',
                        Icons.savings,
                        MyColors.lightBlue,
                        () => _navigateToCategory(context, 'Savings', Icons.savings),
                      ),
                      _buildCategoryItem(
                        context,
                        'Entertainment',
                        Icons.movie,
                        MyColors.vividBlue,
                        () => _navigateToCategory(context, 'Entertainment',Icons.movie),
                      ),
                      _buildCategoryItem(
                        context,
                        'More',
                        Icons.add,
                        MyColors.oceanBlue,
                        () => _navigateToCategory(context, 'More',Icons.add),
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

  void _navigateToCategory(BuildContext context, String categoryName,icon) {
    context.read<AddExpenseProvider>().setCategoryIcon(icon);
    // Navigate to category detail page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryItemView(categoryName: categoryName,),
      ),
    );
  }
}
