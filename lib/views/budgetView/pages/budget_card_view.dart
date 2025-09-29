import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/views/budgetView/pages/add_budget_view.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

// class  extends StatefulWidget {
//   const ({super.key});
//
//   @override
//   State<> createState() => _State();
// }
//
// class _State extends State<> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }


class BudgetCardView extends StatefulWidget {
  const BudgetCardView({super.key});

  @override
  State<BudgetCardView> createState() => _BudgetCardViewState();
}

class _BudgetCardViewState extends State<BudgetCardView>  {
  String selectedPeriod = 'Month';
  double totalBudget = 5000.0;
  double totalSpent = 3200.0;

  List<ExpenseItem> expenses = [
    ExpenseItem('Groceries', 800.0, Colors.green, 1000.0),
    ExpenseItem('Transportation', 300.0, Colors.blue, 500.0),
    ExpenseItem('Entertainment', 450.0, Colors.orange, 400.0),
    ExpenseItem('Utilities', 650.0, Colors.red, 700.0),
    ExpenseItem('Dining Out', 320.0, Colors.purple, 300.0),
    ExpenseItem('Shopping', 680.0, Colors.teal, 600.0),
  ];

  double get remaining => totalBudget - totalSpent;
  double get progressPercentage => (totalSpent / totalBudget).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "Budget Overview"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width * 0.04,vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Filter Buttons


            // Budget Summary Card
            _buildBudgetSummaryCard(),
            SizedBox(height: 24),

            // Progress Bar
            _buildProgressBar(),
            SizedBox(height: 24),

            // Chart Section
            _buildChartSection(),
            SizedBox(height: 24),

            // Expenses List
            _buildExpensesList(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () => Get.to(AddBudgetView()),
      //   backgroundColor: AppColors.primaryBlue,
      //   foregroundColor: AppColors.textPrimary,
      //   icon: Icon(Icons.add),
      //   label: Text('Add Expense'),
      // ),
    );
  }


  Widget _buildBudgetSummaryCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor,Theme.of(context).colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.blue.withOpacity(0.3),
        //     blurRadius: 10,
        //     offset: Offset(0, 4),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Budget',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBudgetMetric('Allocated', totalBudget, Colors.white),
              _buildBudgetMetric('Spent', totalSpent, Colors.red[300]!),
              _buildBudgetMetric('Remaining', remaining, Colors.green[300]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetMetric(String label, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '\$${amount.toStringAsFixed(0)}',
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Budget Progress',
              style: Theme.of(context).textTheme.labelLarge
            ),
            Text(
              '${(progressPercentage * 100).toInt()}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: progressPercentage > 0.8 ? AppColors.error: AppColors.primaryBlue,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progressPercentage,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: progressPercentage > 0.8
                      ? [Colors.red[400]!, Colors.red[600]!]
                      : [Colors.blue[400]!, Colors.blue[600]!],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartSection() {
    return Container(
      height: 280,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.1),
        //     blurRadius: 10,
        //     offset: Offset(0, 2),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spending Breakdown',
            style: Theme.of(context).textTheme.titleLarge
          ),
          SizedBox(height: 16),
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 60,
                sections: expenses.map((expense) {
                  return PieChartSectionData(
                    color: expense.color,
                    value: expense.spent,
                    title: '${((expense.spent / totalSpent) * 100).toInt()}%',
                    radius: 45,
                    titleStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesList() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: Theme.of(context).textTheme.titleLarge
          ),
          SizedBox(height: 16),
          ...expenses.map((expense) => _buildExpenseItem(expense)),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(ExpenseItem expense) {
    double progress = (expense.spent / expense.budget).clamp(0.0, 1.0);
    bool isOverBudget = expense.spent > expense.budget;

    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: expense.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    expense.name,
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
                ],
              ),
              Text(
                '\$${expense.spent.toInt()} / \$${expense.budget.toInt()}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isOverBudget ? AppColors.error : AppColors.textMuted,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.textMuted,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress > 1.0 ? 1.0 : progress,
              child: Container(
                decoration: BoxDecoration(
                  color: isOverBudget ? AppColors.error : expense.color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class ExpenseItem {
  final String name;
  double spent;
  final Color color;
  final double budget;

  ExpenseItem(this.name, this.spent, this.color, this.budget);
}