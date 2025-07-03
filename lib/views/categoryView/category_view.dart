import 'package:finance_manager_app/views/categoryView/categoryItem/category_item_view.dart';
import 'package:flutter/material.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  // Color constants
  static const Color honeyDew = Color(0xffF1FFF3);
  static const Color lightGreen = Color(0xffDFF7E2);
  static const Color carbbeanGreen = Color(0xff00D09E);
  static const Color cyprus = Color(0xff0E3E3E);
  static const Color fencGreen = Color(0xff052224);
  static const Color voidB = Color(0xff031314);
  static const Color lightBlue = Color(0xff6DB6FE);
  static const Color vividBlue = Color(0xff3299FF);
  static const Color oceanBlue = Color(0xff0068FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: carbbeanGreen,
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
                  Row(
                    children: [
                      Expanded(
                        child: _buildBalanceCard(
                          'Total Balance',
                          '\$7,783.00',
                          Icons.account_balance_wallet_outlined,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildBalanceCard(
                          'Total Expense',
                          '\$1,187.40',
                          Icons.trending_up,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Progress Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '30%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            '\$20,000.00',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: 0.3,
                        backgroundColor: Colors.white.withValues(alpha: 0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                        minHeight: 6,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '30% of Your Expenses, Looks Good.',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
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
                        lightBlue,
                        () => _navigateToCategory(context, 'Food'),
                      ),
                      _buildCategoryItem(
                        context,
                        'Transport',
                        Icons.directions_bus,
                        vividBlue,
                        () => _navigateToCategory(context, 'Transport'),
                      ),
                      _buildCategoryItem(
                        context,
                        'Medicine',
                        Icons.medical_services,
                        oceanBlue,
                        () => _navigateToCategory(context, 'Medicine'),
                      ),
                      _buildCategoryItem(
                        context,
                        'Groceries',
                        Icons.shopping_bag,
                        lightBlue,
                        () => _navigateToCategory(context, 'Groceries'),
                      ),
                      _buildCategoryItem(
                        context,
                        'Rent',
                        Icons.handshake,
                        vividBlue,
                        () => _navigateToCategory(context, 'Rent'),
                      ),
                      _buildCategoryItem(
                        context,
                        'Gifts',
                        Icons.card_giftcard,
                        oceanBlue,
                        () => _navigateToCategory(context, 'Gifts'),
                      ),
                      _buildCategoryItem(
                        context,
                        'Savings',
                        Icons.savings,
                        lightBlue,
                        () => _navigateToCategory(context, 'Savings'),
                      ),
                      _buildCategoryItem(
                        context,
                        'Entertainment',
                        Icons.movie,
                        vividBlue,
                        () => _navigateToCategory(context, 'Entertainment'),
                      ),
                      _buildCategoryItem(
                        context,
                        'More',
                        Icons.add,
                        oceanBlue,
                        () => _navigateToCategory(context, 'More'),
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

  Widget _buildBalanceCard(String title, String amount, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 5),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
                color: cyprus,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCategory(BuildContext context, String categoryName) {
    // Navigate to category detail page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryItemView(categoryName: categoryName),
      ),
    );
  }
}

// Example Category Detail Screen
class CategoryDetailScreen extends StatelessWidget {
  final String categoryName;

  const CategoryDetailScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName Details'),
        backgroundColor: const Color(0xff00D09E),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category, size: 80, color: const Color(0xff00D09E)),
            const SizedBox(height: 20),
            Text(
              'Welcome to $categoryName',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'This is the $categoryName category page.',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
