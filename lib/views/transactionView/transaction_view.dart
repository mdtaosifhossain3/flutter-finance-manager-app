import 'package:flutter/material.dart';

// Color constants
class AppColors {
  static const Color honeyDew = Color(0xffF1FFF3);
  static const Color lightGreen = Color(0xffDFF7E2);
  static const Color carbbeanGreen = Color(0xff00D09E);
  static const Color cyprus = Color(0xff0E3E3E);
  static const Color fencGreen = Color(0xff052224);
  static const Color voidB = Color(0xff031314);
  static const Color lightBlue = Color(0xff6DB6FE);
  static const Color vividBlue = Color(0xff3299FF);
  static const Color oceanBlue = Color(0xff0068FF);
}

// Transaction Screen
class TransactionView extends StatefulWidget {
  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  bool isIncomeSelected = false; // false = All, true = Income, null = Expense
  bool isExpenseSelected = false;

  // Sample transaction data
  final List<TransactionItem> allTransactions = [
    // Income transactions
    TransactionItem(
      title: 'Salary',
      time: '18:27',
      date: 'April 30',
      amount: 4000.00,
      type: 'Monthly',
      category: 'Income',
      month: 'April',
      isIncome: true,
      icon: Icons.work,
      color: AppColors.vividBlue,
    ),
    TransactionItem(
      title: 'Others',
      time: '17:00',
      date: 'April 24',
      amount: 120.00,
      type: 'Payment',
      category: 'Income',
      month: 'April',
      isIncome: true,
      icon: Icons.payments,
      color: AppColors.lightBlue,
    ),
    TransactionItem(
      title: 'Salary',
      time: '18:30',
      date: 'March 31',
      amount: 4000.00,
      type: 'Monthly',
      category: 'Income',
      month: 'March',
      isIncome: true,
      icon: Icons.work,
      color: AppColors.vividBlue,
    ),
    TransactionItem(
      title: 'Others',
      time: '8:30',
      date: 'April 12',
      amount: 340.00,
      type: 'Upwork',
      category: 'Income',
      month: 'April',
      isIncome: true,
      icon: Icons.computer,
      color: AppColors.lightBlue,
    ),
    TransactionItem(
      title: 'Others',
      time: '19:30',
      date: 'March 11',
      amount: 340.00,
      type: 'Upwork',
      category: 'Income',
      month: 'February',
      isIncome: true,
      icon: Icons.computer,
      color: AppColors.lightBlue,
    ),

    // Expense transactions
    TransactionItem(
      title: 'Groceries',
      time: '17:00',
      date: 'April 24',
      amount: 100.00,
      type: 'Pantry',
      category: 'Groceries',
      month: 'April',
      isIncome: false,
      icon: Icons.shopping_bag,
      color: AppColors.lightBlue,
    ),
    TransactionItem(
      title: 'Rent',
      time: '8:30',
      date: 'April 15',
      amount: 674.40,
      type: 'Rent',
      category: 'Rent',
      month: 'April',
      isIncome: false,
      icon: Icons.home,
      color: AppColors.vividBlue,
    ),
    TransactionItem(
      title: 'Transport',
      time: '7:30',
      date: 'April 08',
      amount: 4.13,
      type: 'Fuel',
      category: 'Transport',
      month: 'April',
      isIncome: false,
      icon: Icons.local_gas_station,
      color: AppColors.oceanBlue,
    ),
    TransactionItem(
      title: 'Food',
      time: '18:30',
      date: 'March 31',
      amount: 70.40,
      type: 'Dinner',
      category: 'Food',
      month: 'March',
      isIncome: false,
      icon: Icons.restaurant,
      color: AppColors.lightBlue,
    ),
    TransactionItem(
      title: 'Rent',
      time: '8:30',
      date: 'March 31',
      amount: 674.40,
      type: 'Rent',
      category: 'Rent',
      month: 'March',
      isIncome: false,
      icon: Icons.home,
      color: AppColors.vividBlue,
    ),
  ];

  List<TransactionItem> getFilteredTransactions() {
    if (isIncomeSelected && !isExpenseSelected) {
      return allTransactions.where((t) => t.isIncome).toList();
    } else if (isExpenseSelected && !isIncomeSelected) {
      return allTransactions.where((t) => !t.isIncome).toList();
    }
    return allTransactions;
  }

  double getTotalIncome() {
    return allTransactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double getTotalExpense() {
    return allTransactions
        .where((t) => !t.isIncome)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = getFilteredTransactions();

    return Scaffold(
      backgroundColor: AppColors.carbbeanGreen,
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
                      const Text(
                        'Transaction',
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

                  // Total Balance Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Total Balance',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.cyprus,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$7,783.00',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.cyprus,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Income/Expense Toggle Buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isIncomeSelected = !isIncomeSelected;
                              if (isIncomeSelected) isExpenseSelected = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: isIncomeSelected
                                  ? AppColors.vividBlue
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.trending_up,
                                      color: isIncomeSelected
                                          ? Colors.white
                                          : AppColors.vividBlue,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Income',
                                      style: TextStyle(
                                        color: isIncomeSelected
                                            ? Colors.white
                                            : AppColors.cyprus,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${getTotalIncome().toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: isIncomeSelected
                                        ? Colors.white
                                        : AppColors.cyprus,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpenseSelected = !isExpenseSelected;
                              if (isExpenseSelected) isIncomeSelected = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: isExpenseSelected
                                  ? AppColors.vividBlue
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.trending_down,
                                      color: isExpenseSelected
                                          ? Colors.white
                                          : AppColors.vividBlue,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Expense',
                                      style: TextStyle(
                                        color: isExpenseSelected
                                            ? Colors.white
                                            : AppColors.cyprus,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${getTotalExpense().toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: isExpenseSelected
                                        ? Colors.white
                                        : AppColors.cyprus,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Transactions List Section
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: _buildTransactionsList(filteredTransactions),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTransactionsList(List<TransactionItem> transactions) {
    Map<String, List<TransactionItem>> groupedTransactions = {};

    for (var transaction in transactions) {
      if (!groupedTransactions.containsKey(transaction.month)) {
        groupedTransactions[transaction.month] = [];
      }
      groupedTransactions[transaction.month]!.add(transaction);
    }

    List<Widget> widgets = [];

    groupedTransactions.forEach((month, transactionList) {
      // Add month header
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 15),
          child: Row(
            children: [
              Text(
                month,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.cyprus,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.carbbeanGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      );

      // Add transaction items
      for (var transaction in transactionList) {
        widgets.add(_buildTransactionItem(transaction));
      }
    });

    return widgets;
  }

  Widget _buildTransactionItem(TransactionItem transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.lightGreen,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: transaction.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(transaction.icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.cyprus,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${transaction.time} • ${transaction.date}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.cyprus.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.isIncome
                    ? '+\$${transaction.amount.toStringAsFixed(2)}'
                    : '-\$${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: transaction.isIncome ? Colors.green : AppColors.cyprus,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                transaction.type,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.cyprus.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Transaction Item Model
class TransactionItem {
  final String title;
  final String time;
  final String date;
  final double amount;
  final String type;
  final String category;
  final String month;
  final bool isIncome;
  final IconData icon;
  final Color color;

  TransactionItem({
    required this.title,
    required this.time,
    required this.date,
    required this.amount,
    required this.type,
    required this.category,
    required this.month,
    required this.isIncome,
    required this.icon,
    required this.color,
  });
}
