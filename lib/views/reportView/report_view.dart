import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/views/reportView/widgets/expense_chart_widget.dart';
import 'package:finance_manager_app/views/reportView/widgets/last_five_days_period_chart_widget.dart';
import 'package:finance_manager_app/views/reportView/widgets/monthly_budget_chart_widget.dart';
import 'package:flutter/material.dart';

import '../../models/budget_data_model.dart';
import '../../models/expense_category_model.dart';
import '../../models/period_data_model.dart';

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  // Sample data - replace with your actual data source
  final double totalBudget = 5000;
  final double spentAmount = 3050;

  // Monthly budget vs spent data
  final List<BudgetData> monthlyData = [
    BudgetData('Jan', 1800, 1500),
    BudgetData('Feb', 2000, 1800),
    BudgetData('Mar', 1600, 2200),
    BudgetData('Apr', 1900, 1400),
    BudgetData('May', 2100, 1600),
    BudgetData('June', 1700, 1900),
    BudgetData('July', 2000, 1800),
    BudgetData('Aug', 2000, 1800),
    BudgetData('Sep', 2000, 1800),
    BudgetData('Oct', 2000, 1800),
    BudgetData('Nov ', 2000, 1800),
    BudgetData('Dec', 2000, 1800),
  ];

  // Last 6 periods data
  final List<PeriodData> periodData = [
    PeriodData('Jan', 1800, 1500, 0), // within, risk, overspending
    PeriodData('Feb', 0, 0, 2300), // overspending
    PeriodData('Mar', 0, 1900, 0), // risk
    PeriodData('Apr', 1700, 0, 0), // within
    PeriodData('May', 1600, 0, 0), // within
    PeriodData('June', 1800, 0, 0), // within
  ];

  // Expenses breakdown
  final List<ExpenseCategoryModel> expenseCategories = [
    ExpenseCategoryModel('Shopping', 1200, AppColors.error),
    ExpenseCategoryModel('Food', 800, AppColors.border),
    ExpenseCategoryModel('Groceries', 600, AppColors.warning),
    ExpenseCategoryModel('Transport', 350, AppColors.primaryBlue),
    ExpenseCategoryModel('Entertainment', 100, AppColors.success),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Financial Report',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 20),
              _buildSpentIndicator(),
              SizedBox(height: 24),
              ExpenseChartWidget(expenseCategories: expenseCategories),
              SizedBox(height: 24),
              MonthlyBudgetChartWidget(monthlyData: monthlyData),
              SizedBox(height: 24),
              LastFiveDaysPeriodChartWidget(periodData: periodData),
              SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpentIndicator() {
    double percentage = (spentAmount / totalBudget) * 100;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spent: ৳${spentAmount.toStringAsFixed(0)} / ৳${totalBudget.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: percentage > 90
                      ? AppColors.error
                      : percentage > 75
                      ? AppColors.warning
                      : AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          LinearProgressIndicator(
            value: spentAmount / totalBudget,
            backgroundColor: AppColors.darkSecondaryBackground,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}
