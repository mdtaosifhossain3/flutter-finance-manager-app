import 'package:finance_manager_app/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/myColors/my_colors.dart';
import '../../../models/expense_model.dart';
import '../../../providers/category_item_provider.dart';
import '../../../providers/expense_provider.dart';
import '../../../utils/helper_functions.dart';

class TransactionListWidget extends StatelessWidget {
  const TransactionListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<Expense> expenseList = context.watch<AddExpenseProvider>().expenseList;
    DateTime selectedMonth = context
        .watch<CategoryItemProvider>()
        .selectedMonth;

    List<Expense> filteredData = expenseList.where((expense) {
      final expDate = DateTime.parse(expense.date);

      if (context.watch<HomeViewProvider>().selectedPeriod == "Daily") {
        // show only today's expenses
        final now = DateTime.now();
        return expDate.year == now.year &&
            expDate.month == now.month &&
            expDate.day == now.day;
      } else if (context.watch<HomeViewProvider>().selectedPeriod == "Weekly") {
        // show only this week's expenses
        final now = DateTime.now();
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));

        return expDate.isAfter(
              startOfWeek.subtract(const Duration(seconds: 1)),
            ) &&
            expDate.isBefore(endOfWeek.add(const Duration(days: 1)));
      } else {
        // Monthly (your existing logic)
        return expDate.year == selectedMonth.year &&
            expDate.month == selectedMonth.month;
      }
    }).toList();

    return Expanded(
      child: ListView.builder(
        itemCount: filteredData.length,
        itemBuilder: (context, index) {
          final expense = filteredData[index];
          return _buildTransactionItem(
            expense.title,
            expense.date,
            expense.time,
            expense.categoryName,
            '৳${expense.amount.toStringAsFixed(2)}',
            expense.icon,
          );
        },
      ),
    );
  }

  Widget _buildTransactionItem(
    String title,
    String date,
    String time,
    String category,
    String amount,
    String icon,
  ) {
    IconData getCategoryIcon() {
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

      return categoryIcons[category] ?? Icons.attach_money;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
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
            child: Icon(getCategoryIcon(), color: Colors.white, size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$time • ${HelperFunctions.formatDateToMonthDay(DateTime.parse(date))}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              Text(
                category,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
