import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/models/tempm/budgetModel/budget_model.dart';
import 'package:finance_manager_app/providers/budget/budget_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../models/tempm/budgetModel/budget_category_model.dart';

class BudgetCardView extends StatefulWidget {
  final BudgetModel budget;
  final List<BudgetCategoryModel> categories;
  final int remaining;
  final int totalSpent;
  final double percentage;
  const BudgetCardView({
    super.key,
    required this.budget,
    required this.categories,
    required this.remaining,
    required this.totalSpent,
    required this.percentage,
  });

  @override
  State<BudgetCardView> createState() => _BudgetCardViewState();
}

class _BudgetCardViewState extends State<BudgetCardView> {
  String selectedPeriod = 'Month';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: "Budget Overview",
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.03,
            ),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: AppColors.error,
                padding: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 1,
              ),
              onPressed: () {
                context.read<BudgetProvider>().deleteBudget(widget.budget.id!);
                Get.back();
              },
              icon: const Icon(Icons.delete),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Budget Summary Card
            _buildBudgetSummaryCard(),
            SizedBox(height: 24),

            // Progress Bar
            _buildProgressBar(),
            SizedBox(height: 24),

            // Chart Section
            //   _buildChartSection(),
            SizedBox(height: 24),

            // Expenses List
            _buildExpensesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetSummaryCard() {
    return Consumer<BudgetProvider>(
      builder: (context, provider, child) {
        final categories = provider.categoriesByBudget[widget.budget.id];

        final int totalSpent = categories!.fold(
          0,
          (sum, cat) => sum + (cat.spent),
        );

        final int remaining = widget.budget.totalAmount - totalSpent;

        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary,
              ],
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
                  _buildBudgetMetric(
                    'Allocated',
                    widget.budget.totalAmount,
                    Colors.white,
                  ),
                  _buildBudgetMetric('Spent', totalSpent, Colors.red[300]!),
                  _buildBudgetMetric(
                    'Remaining',
                    remaining,
                    Colors.green[300]!,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBudgetMetric(String label, int amount, Color color) {
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
          '৳${amount.toStringAsFixed(0)}',
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
    return Consumer<BudgetProvider>(
      builder: (context, provider, child) {
        final categories = provider.categoriesByBudget[widget.budget.id];
        final int totalSpent = categories!.fold(
          0,
          (sum, cat) => sum + (cat.spent),
        );
        final double percentage = (totalSpent / widget.budget.totalAmount)
            .clamp(0.0, 1.0);

        double progressPercentage = (totalSpent / widget.budget.totalAmount)
            .clamp(0.0, 1.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Budget Progress',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  '${(percentage * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: progressPercentage > 0.8
                        ? AppColors.error
                        : AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
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
      },
    );
  }

  // Widget _buildChartSection() {
  //   return Container(
  //     height: 280,
  //     padding: EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).cardColor,
  //       borderRadius: BorderRadius.circular(16),
  //       // boxShadow: [
  //       //   BoxShadow(
  //       //     color: Colors.grey.withOpacity(0.1),
  //       //     blurRadius: 10,
  //       //     offset: Offset(0, 2),
  //       //   ),
  //       // ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Spending Breakdown',
  //           style: Theme.of(context).textTheme.titleLarge
  //         ),
  //         SizedBox(height: 16),
  //         Expanded(
  //           child: PieChart(
  //             PieChartData(
  //               sectionsSpace: 2,
  //               centerSpaceRadius: 60,
  //               sections: expenses.map((expense) {
  //                 return PieChartSectionData(
  //                   color: expense.color,
  //                   value: expense.spent,
  //                   title: '${((expense.spent / totalSpent) * 100).toInt()}%',
  //                   radius: 45,
  //                   titleStyle: TextStyle(
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.bold,
  //                     color: AppColors.textPrimary,
  //                   ),
  //                 );
  //               }).toList(),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildExpensesList() {
    return Consumer<BudgetProvider>(
      builder: (context, provider, child) {
        final categories = provider.categoriesByBudget[widget.budget.id];
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Categories', style: Theme.of(context).textTheme.titleLarge),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: AppColors.primaryBlue
                      ,
                      padding: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 1,
                    ),
                    onPressed: () {

                    },
                    icon: const Icon(Icons.add,size: 20,),
                  ),                          ],
              ),
              SizedBox(height: 16),
              //...expenses.map((expense) => _buildExpenseItem(expense)),
              if (categories == null && categories!.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("No categories yet"),
                  ),
                )
              else
                ...categories.map((expense) => _buildExpenseItem(expense)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExpenseItem(BudgetCategoryModel expense) {
    final spentPercent = expense.allocatedAmount == 0
        ? 0.0
        : expense.spent / expense.allocatedAmount;
    return GestureDetector(
      onTap: () {
        print("hi");
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Container(
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
                          color: Colors.teal,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        expense.categoryName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () async {
                      await context.read<BudgetProvider>().deleteCategory(
                        expense.id!,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Category deleted")),
                      );
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Progress Bar (spent / allocated)
              LinearProgressIndicator(
                value: spentPercent.clamp(0.0, 1.0),
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  spentPercent >= 1
                      ? Colors.redAccent
                      : Colors.greenAccent.shade700,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "৳${expense.spent} / ৳${expense.allocatedAmount}",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Row(
                    children: [
                      // Decrease
                      IconButton(
                        onPressed: () async {
                          if (expense.spent > 0) {
                            await context
                                .read<BudgetProvider>()
                                .subtractFromCategorySpent(
                                  expense.id!,
                                  5, // you can customize this step
                                );
                          }
                        },
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.orangeAccent,
                        ),
                      ),

                      // Increase
                      IconButton(
                        onPressed: () async {
                          await context
                              .read<BudgetProvider>()
                              .addToCategorySpent(
                                expense.id!,
                                10, // same step value
                              );
                        },
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
