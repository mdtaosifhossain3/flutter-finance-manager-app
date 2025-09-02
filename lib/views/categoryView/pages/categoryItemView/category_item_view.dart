import 'package:finance_manager_app/config/myColors/my_colors.dart';
import 'package:finance_manager_app/globalWidgets/balance_expense_card_widget.dart';
import 'package:finance_manager_app/globalWidgets/progress_bar_widget.dart';
import 'package:finance_manager_app/models/expense_model.dart';
import 'package:finance_manager_app/providers/category_item_provider.dart';
import 'package:finance_manager_app/providers/expense_provider.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:finance_manager_app/globalWidgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../addExpenseView/add_expense_view.dart';

class CategoryItemView extends StatelessWidget {
  //To Show it in Header
  final String categoryName;

  const CategoryItemView({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    // Get the full expense list from the provider
    List<Expense> expenseL = context.watch<AddExpenseProvider>().expenseList;

    // Filter by category
    List<Expense> filteredData = expenseL
        .where((item) => item.categoryName == categoryName)
        .toList();

    // Filter by selected month if applicable
    filteredData = filteredData.where((expense) {
      final expDate = DateTime.parse(expense.date);
      return expDate.year ==
              context.watch<CategoryItemProvider>().selectedMonth.year &&
          expDate.month ==
              context.watch<CategoryItemProvider>().selectedMonth.month;
    }).toList();

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
                  HeaderWidget(categoryName: categoryName),
                  const SizedBox(height: 30),
                  BalanceExpenseCardWidget(),
                  const SizedBox(height: 20),
                  ProgressBarWidget(),
                ],
              ),
            ),

            // Expenses List Section
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    // Fixed Month Header with Calendar Button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Text(
                            DateFormat.yMMMM().format(
                              context
                                  .watch<CategoryItemProvider>()
                                  .selectedMonth,
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: MyColors.cyprus,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () async {
                              // Read the provider value BEFORE the await
                              final selectedMonth = context
                                  .read<CategoryItemProvider>()
                                  .selectedMonth;

                              final DateTime? pickedMonth =
                                  await showMonthPicker(
                                    context: context,
                                    initialDate: selectedMonth,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );

                              if (pickedMonth != null && context.mounted) {
                                context
                                    .read<CategoryItemProvider>()
                                    .setSelectedMonth(pickedMonth);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: MyColors.carbbeanGreen,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Expenses List
                    Expanded(
                      child: filteredData.isEmpty
                          ? const Center(
                              child: Text(
                                'No expenses found for this category.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: MyColors.cyprus,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(20),
                              itemCount: filteredData.length,
                              itemBuilder: (context, index) {
                                return _buildExpenseItem(filteredData[index]);
                              },
                            ),
                    ),

                    // Add Expense Button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddExpenseScreen(
                                  categoryName: categoryName,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.carbbeanGreen,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Add Expenses',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseItem(Expense expense) {
    IconData getCategoryIcon(String categoryName) {
      final Map<String, IconData> categoryIcons = {
        'Food': Icons.restaurant,
        'Transport': Icons.directions_car,
        'Medicine': Icons.medical_services,
        'Groceries': Icons.shopping_cart,
        'Rent': Icons.house,
        'Gifts': Icons.card_giftcard,
        'Savings': Icons.savings,
        'Entertainment': Icons.movie,
        // Add more mappings as needed
      };

      return categoryIcons[categoryName] ?? Icons.attach_money;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: MyColors.lightGreen,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: MyColors.lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              getCategoryIcon(expense.categoryName),
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: MyColors.cyprus,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${expense.time} • ${HelperFunctions.formatDateToMonthDay(DateTime.parse(expense.date))}',
                  style: TextStyle(
                    fontSize: 12,
                    color: MyColors.cyprus.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '-৳${expense.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: MyColors.vividRed,
            ),
          ),
        ],
      ),
    );
  }
}
