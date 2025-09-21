import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/models/expense_data_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  String selectedPeriod = 'Daily';
  final TextEditingController searchController = TextEditingController();

  // Sample data - replace with your actual data source
  final Map<String, List<ExpenseData>> expensesData = {
    'Daily': [
      ExpenseData(
        'Groceries',
        67.00,
        15,
        true,
        Icons.shopping_basket,
        Colors.green,
      ),
      ExpenseData('Shopping', 158.00, 8, false, Icons.shopping_bag, Colors.red),
      ExpenseData('Food', 125.00, 2, false, Icons.restaurant, Colors.orange),
      ExpenseData('Health', 28.00, 1, false, Icons.local_hospital, Colors.blue),
      ExpenseData('Travel', 685.00, 12, true, Icons.flight, Colors.purple),
      ExpenseData('Taxi', 45.00, 3, false, Icons.local_taxi, Colors.blue[300]!),
    ],
    'Weekly': [
      ExpenseData(
        'Groceries',
        280.00,
        12,
        true,
        Icons.shopping_basket,
        Colors.green,
      ),
      ExpenseData('Shopping', 450.00, 5, false, Icons.shopping_bag, Colors.red),
      ExpenseData('Food', 320.00, 8, true, Icons.restaurant, Colors.orange),
      ExpenseData(
        'Health',
        120.00,
        15,
        true,
        Icons.local_hospital,
        Colors.blue,
      ),
      ExpenseData('Travel', 1200.00, 20, true, Icons.flight, Colors.purple),
      ExpenseData('Taxi', 180.00, 6, true, Icons.local_taxi, Colors.blue[300]!),
    ],
    'Monthly': [
      ExpenseData(
        'Groceries',
        1200.00,
        8,
        true,
        Icons.shopping_basket,
        Colors.green,
      ),
      ExpenseData(
        'Shopping',
        1800.00,
        3,
        false,
        Icons.shopping_bag,
        Colors.red,
      ),
      ExpenseData('Food', 950.00, 12, true, Icons.restaurant, Colors.orange),
      ExpenseData(
        'Health',
        480.00,
        25,
        true,
        Icons.local_hospital,
        Colors.blue,
      ),
      ExpenseData('Travel', 2400.00, 18, true, Icons.flight, Colors.purple),
      ExpenseData(
        'Taxi',
        650.00,
        10,
        true,
        Icons.local_taxi,
        Colors.blue[300]!,
      ),
    ],
    'Yearly': [
      ExpenseData(
        'Groceries',
        14400.00,
        5,
        true,
        Icons.shopping_basket,
        Colors.green,
      ),
      ExpenseData(
        'Shopping',
        21600.00,
        2,
        false,
        Icons.shopping_bag,
        Colors.red,
      ),
      ExpenseData('Food', 11400.00, 8, true, Icons.restaurant, Colors.orange),
      ExpenseData(
        'Health',
        5760.00,
        15,
        true,
        Icons.local_hospital,
        Colors.blue,
      ),
      ExpenseData('Travel', 28800.00, 12, true, Icons.flight, Colors.purple),
      ExpenseData(
        'Taxi',
        7800.00,
        6,
        true,
        Icons.local_taxi,
        Colors.blue[300]!,
      ),
    ],
  };

  List<ExpenseData> get currentExpenses => expensesData[selectedPeriod] ?? [];
  double get totalAmount =>
      currentExpenses.fold(0.0, (sum, expense) => sum + expense.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).iconTheme.color),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Expenses',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildPeriodTabs(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDonutChart(),
                  SizedBox(height: 24),
                  _buildExpensesList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: searchController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Super AI search',
          hintStyle: TextStyle(color: AppColors.textMuted),
          prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16),
        ),
        onChanged: (value) {
          // Implement search functionality here
          setState(() {});
        },
      ),
    );
  }

  Widget _buildPeriodTabs() {
    final periods = ['Daily', 'Weekly', 'Monthly', 'Yearly'];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: periods.map((period) {
          final isSelected = selectedPeriod == period;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedPeriod = period;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? AppColors.primaryBlue
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.secondaryBlue
                        : AppColors.textMuted,
                    fontSize: 16,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDonutChart() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: _buildPieChartSections(),
                    sectionsSpace: 3,
                    centerSpaceRadius: 60,
                    startDegreeOffset: -90,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '\$${totalAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall
                    ),
                    Text(
                      'Total',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          _buildChartLegend(),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return currentExpenses.map((expense) {
      final percentage = (expense.amount / totalAmount) * 100;
      return PieChartSectionData(
        color: expense.color,
        value: percentage,
        title: '',
        radius: 25,
      );
    }).toList();
  }

  Widget _buildChartLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: currentExpenses.map((expense) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: expense.color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 6),
            Text(
              expense.category,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildExpensesList() {
    List<ExpenseData> filteredExpenses = currentExpenses;

    // Apply search filter
    if (searchController.text.isNotEmpty) {
      filteredExpenses = currentExpenses
          .where(
            (expense) => expense.category.toLowerCase().contains(
              searchController.text.toLowerCase(),
            ),
          )
          .toList();
    }

    return Column(
      children: filteredExpenses
          .map((expense) => _buildExpenseCard(expense))
          .toList(),
    );
  }

  Widget _buildExpenseCard(ExpenseData expense) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: expense.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(expense.icon, color: expense.color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              expense.category,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${expense.amount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${expense.percentage}%',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: expense.isIncreasing
                          ? AppColors.error
                          : AppColors.success,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    expense.isIncreasing
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: expense.isIncreasing ? Colors.red : Colors.green,
                    size: 12,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
