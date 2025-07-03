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

// Category View Screen (Food Category)
class CategoryItemView extends StatefulWidget {
  final String categoryName;

  const CategoryItemView({super.key, required this.categoryName});

  @override
  State<CategoryItemView> createState() => _CategoryItemViewState();
}

class _CategoryItemViewState extends State<CategoryItemView> {
  List<ExpenseItem> expenses = [
    ExpenseItem(
      title: 'Dinner',
      time: '18:27',
      date: 'April 30',
      amount: 26.00,
      month: 'April',
    ),
    ExpenseItem(
      title: 'Delivery Pizza',
      time: '15:00',
      date: 'April 24',
      amount: 18.35,
      month: 'April',
    ),
    ExpenseItem(
      title: 'Lunch',
      time: '12:30',
      date: 'April 15',
      amount: 15.40,
      month: 'April',
    ),
    ExpenseItem(
      title: 'Brunch',
      time: '9:30',
      date: 'April 08',
      amount: 12.13,
      month: 'April',
    ),
    ExpenseItem(
      title: 'Dinner',
      time: '20:00',
      date: 'March 31',
      amount: 27.20,
      month: 'March',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      Text(
                        widget.categoryName,
                        style: const TextStyle(
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
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(20),
                        children: _buildExpensesList(),
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
                                  categoryName: widget.categoryName,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.carbbeanGreen,
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

  List<Widget> _buildExpensesList() {
    Map<String, List<ExpenseItem>> groupedExpenses = {};

    for (var expense in expenses) {
      if (!groupedExpenses.containsKey(expense.month)) {
        groupedExpenses[expense.month] = [];
      }
      groupedExpenses[expense.month]!.add(expense);
    }

    List<Widget> widgets = [];

    groupedExpenses.forEach((month, expenseList) {
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

      // Add expense items
      for (var expense in expenseList) {
        widgets.add(_buildExpenseItem(expense));
      }
    });

    return widgets;
  }

  Widget _buildExpenseItem(ExpenseItem expense) {
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
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.restaurant, color: Colors.white, size: 24),
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
                    color: AppColors.cyprus,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${expense.time} • ${expense.date}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.cyprus.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '-\$${expense.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.cyprus,
            ),
          ),
        ],
      ),
    );
  }
}

// Add Expense Screen
class AddExpenseScreen extends StatefulWidget {
  final String categoryName;

  const AddExpenseScreen({super.key, required this.categoryName});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String selectedDate = 'April 30, 2024';
  String selectedCategory = '';

  List<String> categories = [
    'Food',
    'Transport',
    'Medicine',
    'Groceries',
    'Rent',
    'Gifts',
    'Savings',
    'Entertainment',
  ];

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.categoryName;
    _amountController.text = '\$26.00';
    _titleController.text = 'Dinner';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.carbbeanGreen,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const Text(
                    'Add Expenses',
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
            ),

            // Form Section
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date Field
                      const Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.cyprus,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDate,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.cyprus,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.carbbeanGreen,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Category Field
                      const Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.cyprus,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedCategory,
                            hint: const Text('Select the category'),
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: categories.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCategory = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Amount Field
                      const Text(
                        'Amount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.cyprus,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '\$0.00',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Expense Title Field
                      const Text(
                        'Expense Title',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.cyprus,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter title',
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Message Field
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _messageController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Message',
                            hintStyle: TextStyle(
                              color: AppColors.carbbeanGreen,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle save expense
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Expense saved successfully!'),
                                backgroundColor: AppColors.carbbeanGreen,
                              ),
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.carbbeanGreen,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
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

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}

// Expense Item Model
class ExpenseItem {
  final String title;
  final String time;
  final String date;
  final double amount;
  final String month;

  ExpenseItem({
    required this.title,
    required this.time,
    required this.date,
    required this.amount,
    required this.month,
  });
}
