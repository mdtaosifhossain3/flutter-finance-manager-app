import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/category/category_provider.dart';
import 'package:finance_manager_app/providers/theme_provider.dart';
import 'package:finance_manager_app/views/categoryView/pages/category_item_view.dart';
import 'package:finance_manager_app/views/categoryView/pages/custom_add_category_view.dart';
import 'package:finance_manager_app/views/categoryView/pages/transaction_form_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../config/enums/enums.dart';

enum Period { day, week, month }

class CategoryView extends StatefulWidget {
  @override
  _CategorySelectionPageState createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategoryView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  Period selectedPeriod = Period.day;
  final List<Transaction> allTransactions = [
    Transaction(title: 'Groceries', amount: 50.0, date: DateTime.now()),
    Transaction(
      title: 'Coffee',
      amount: 4.5,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      title: 'Lunch',
      amount: 12.0,
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    // Add more sample transactions as needed
  ];

  List<Transaction> get filteredTransactions {
    DateTime now = DateTime.now();
    if (selectedPeriod == Period.day) {
      return allTransactions
          .where(
            (tx) =>
                tx.date.year == now.year &&
                tx.date.month == now.month &&
                tx.date.day == now.day,
          )
          .toList();
    } else if (selectedPeriod == Period.week) {
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
      return allTransactions
          .where(
            (tx) =>
                tx.date.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
                tx.date.isBefore(endOfWeek.add(Duration(days: 1))),
          )
          .toList();
    } else {
      return allTransactions
          .where((tx) => tx.date.year == now.year && tx.date.month == now.month)
          .toList();
    }
  }

  // Expense categories
  final List<CategoryData> expenseCategories = [
    // Health & Fitness
    CategoryData(
      'DoctorDoctor',
      Icons.local_hospital,
      Color(0xFFFF6B6B),
      'Health & Fitness',
    ),
    CategoryData(
      'Medicine Doctor',
      Icons.medication,
      Color(0xFF4ECDC4),
      'Health & Fitness',
    ),
    CategoryData(
      'Exercise Doctor',
      Icons.fitness_center,
      Color(0xFF45B7D1),
      'Health & Fitness',
    ),
    CategoryData(
      'Exercise Doctor',
      Icons.fitness_center,
      Color(0xFF45B7D1),
      'Health & Fitness',
    ),

    // Food & Shopping
    CategoryData(
      'Cycling',
      Icons.directions_bike,
      Color(0xFF96CEB4),
      'Food & Shopping',
    ),
    CategoryData('Swimming', Icons.pool, Color(0xFFFFCE56), 'Food & Shopping'),
    CategoryData(
      'Grocery',
      Icons.shopping_cart,
      Color(0xFF4ECDC4),
      'Food & Shopping',
    ),
    CategoryData(
      'Tea & Coffee',
      Icons.local_cafe,
      Color(0xFF6C5CE7),
      'Food & Shopping',
    ),
    CategoryData(
      'Drugs',
      Icons.local_pharmacy,
      Color(0xFFFF7675),
      'Food & Shopping',
    ),
    CategoryData(
      'Restaurants',
      Icons.restaurant,
      Color(0xFFFFB142),
      'Food & Shopping',
    ),

    // Bills & Utilities
    CategoryData(
      'Phone Bill',
      Icons.phone,
      Color(0xFFFF6B9D),
      'Bills & Utilities',
    ),
    CategoryData(
      'Water Bill',
      Icons.water_drop,
      Color(0xFF4ECDC4),
      'Bills & Utilities',
    ),
    CategoryData('WiFi', Icons.wifi, Color(0xFF6C5CE7), 'Bills & Utilities'),

    // Transportation
    CategoryData(
      'Fuel',
      Icons.local_gas_station,
      Color(0xFFFF9F43),
      'Transportation',
    ),
    CategoryData(
      'Parking',
      Icons.local_parking,
      Color(0xFF74B9FF),
      'Transportation',
    ),
    CategoryData(
      'Public Transport',
      Icons.directions_bus,
      Color(0xFF00B894),
      'Transportation',
    ),

    // Entertainment
    CategoryData('Movies', Icons.movie, Color(0xFF6C5CE7), 'Entertainment'),
    CategoryData('Games', Icons.games, Color(0xFFFF7675), 'Entertainment'),
    CategoryData('Music', Icons.music_note, Color(0xFF00CEC9), 'Entertainment'),

    // Shopping
    CategoryData('Clothes', Icons.checkroom, Color(0xFFFFB142), 'Shopping'),
    CategoryData('Electronics', Icons.devices, Color(0xFF74B9FF), 'Shopping'),
    CategoryData('Books', Icons.book, Color(0xFF81ECEC), 'Shopping'),
  ];

  // Income categories
  final List<CategoryData> incomeCategories = [
    // Primary Income
    CategoryData('Salary', Icons.work, Color(0xFF00B894), 'Primary Income'),
    CategoryData(
      'Business',
      Icons.business,
      Color(0xFF6C5CE7),
      'Primary Income',
    ),
    CategoryData(
      'Freelance',
      Icons.laptop,
      Color(0xFF74B9FF),
      'Primary Income',
    ),

    // Investments
    CategoryData('Stocks', Icons.trending_up, Color(0xFF00CEC9), 'Investments'),
    CategoryData(
      'Dividends',
      Icons.account_balance,
      Color(0xFF81ECEC),
      'Investments',
    ),
    CategoryData(
      'Crypto',
      Icons.currency_bitcoin,
      Color(0xFFFFB142),
      'Investments',
    ),

    // Other Income
    CategoryData('Rental', Icons.home, Color(0xFF55A3FF), 'Other Income'),
    CategoryData(
      'Gifts',
      Icons.card_giftcard,
      Color(0xFFFF6B9D),
      'Other Income',
    ),
    CategoryData('Bonus', Icons.star, Color(0xFFFFCE56), 'Other Income'),
    CategoryData('Refund', Icons.refresh, Color(0xFF96CEB4), 'Other Income'),

    // Side Income
    CategoryData('Part-time', Icons.schedule, Color(0xFFFF9F43), 'Side Income'),
    CategoryData('Commission', Icons.percent, Color(0xFF4ECDC4), 'Side Income'),
    CategoryData(
      'Consulting',
      Icons.psychology,
      Color(0xFFFF7675),
      'Side Income',
    ),
  ];

  List<CategoryData> get currentCategories =>
      context.watch<CategoryProvider>().selectedType == TransactionType.expense ? expenseCategories : incomeCategories;

  Map<String, List<CategoryData>> get groupedCategories {
    Map<String, List<CategoryData>> grouped = {};
    for (var category in currentCategories) {
      if (!grouped.containsKey(category.group)) {
        grouped[category.group] = [];
      }
      grouped[category.group]!.add(category);
    }
    return grouped;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Categories', actions: [

        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTabButtons(),
            weekmonthday(),
            Expanded(child: _buildCategoryGrid()),
            //_buildAddButton(),
            SizedBox(height: 60),
          ],
        ),
      ),
      floatingActionButton: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 110.0,
          ), // keeps safe from nav bar
          child: SizedBox(
            child: FloatingActionButton.extended(
              onPressed: () {
                Get.to(CreateCategoryPage());
              },
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.add, size: 22, color: AppColors.textPrimary),
              label: FittedBox(
                // ensures text scales down if needed
                child: Text(
                  'Add Category',
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildTabButtons() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: 10,
      ),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<CategoryProvider>().changeSelectedType(TransactionType.expense);

              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: context.watch<CategoryProvider>().selectedType == TransactionType.expense
                      ? AppColors.primaryBlue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: context.watch<CategoryProvider>().selectedType == TransactionType.expense
                      ? [
                          BoxShadow(
                            color: AppColors.primaryBlue.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  'Expense',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.watch<CategoryProvider>().selectedType == TransactionType.expense
                        ? Colors.white
                        : Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<CategoryProvider>().changeSelectedType(TransactionType.income);

              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: context.watch<CategoryProvider>().selectedType == TransactionType.income
                      ? Colors.blue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: context.watch<CategoryProvider>().selectedType == TransactionType.income
                      ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  'Income',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.watch<CategoryProvider>().selectedType == TransactionType.income
                        ? Colors.white
                        : Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: SingleChildScrollView(
        key: ValueKey(context.watch<CategoryProvider>().selectedType),
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: groupedCategories.entries.map((entry) {
            return _buildCategorySection(entry.key, entry.value);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    String sectionTitle,
    List<CategoryData> categories,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,

        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.05),
        //     blurRadius: 8,
        //     offset: Offset(0, 2),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              sectionTitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              childAspectRatio: 1,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return _buildCategoryItem(categories[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(CategoryData category) {
    return GestureDetector(
      onTap: () {
        // Handle category selection
        print('Selected: ${category.name}');
        Get.to(
          () => CategoryTransactionView(
            categoryName:category.name,
            categoryIcon: category.icon,
            categoryColor:  category.color,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: category.color.withOpacity(0.15),
              ),
              child: Icon(category.icon, color: category.color, size: 24),
            ),
            SizedBox(height: 8),
            Text(
              category.name.length > 8
                  ? '${category.name.substring(0, 8)}...'
                  : category.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildPeriodButton(String label, Period period) {
    final isSelected = selectedPeriod == period;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? Theme.of(context).primaryColor
              : Colors.grey[300],
          foregroundColor: isSelected ? Colors.white : Colors.black,
        ),
        onPressed: () {
          setState(() {
            selectedPeriod = period;
          });
        },
        child: Text(label),
      ),
    );
  }

  Widget weekmonthday() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPeriodButton('Day', Period.day),
            _buildPeriodButton('Week', Period.week),
            _buildPeriodButton('Month', Period.month),
          ],
        ),
        // Expanded(
        //   child: ListView.builder(
        //     itemCount: filteredTransactions.length,
        //     itemBuilder: (context, index) {
        //       final tx = filteredTransactions[index];
        //       return Card(
        //         margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        //         child: ListTile(
        //           title: Text(
        //             tx.title,
        //             style: Theme.of(context).textTheme.titleMedium,
        //           ),
        //           subtitle: Text(
        //             _formatDate(tx.date),
        //             style: Theme.of(context).textTheme.bodySmall,
        //           ),
        //           trailing: Text(
        //             '\$${tx.amount.toStringAsFixed(2)}',
        //             style: Theme.of(context).textTheme.titleMedium!.copyWith(
        //               color: Theme.of(context).colorScheme.primary,
        //             ),
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}

class Transaction {
  final String title;
  final double amount;
  final DateTime date;

  Transaction({required this.title, required this.amount, required this.date});
}

class CategoryData {
  final String name;
  final IconData icon;
  final Color color;
  final String group;

  CategoryData(this.name, this.icon, this.color, this.group);
}
