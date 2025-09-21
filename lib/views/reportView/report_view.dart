import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/views/reportView/widgets/expense_chart_widget.dart';
import 'package:finance_manager_app/views/reportView/widgets/last_five_days_period_chart_widget.dart';
import 'package:finance_manager_app/views/reportView/widgets/monthly_budget_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/budget_data_model.dart';
import '../../models/expense_category_model.dart';
import '../../models/period_data_model.dart';
import '../../providers/theme_provider.dart';


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

              _buildSpentIndicator(),
              SizedBox(height: 24),
              ExpenseChartWidget(expenseCategories:expenseCategories ,),
              SizedBox(height: 24),
              MonthlyBudgetChartWidget(monthlyData:monthlyData),
              SizedBox(height: 24),
              LastFiveDaysPeriodChartWidget(periodData:periodData),
              SizedBox(height: 120),
        
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wednesday',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                  '17 September',
                  textAlign: TextAlign.center,
                  style:Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  context.read<ThemeProvider>().toggleTheme();
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:context.read<ThemeProvider>().isDark ? AppColors.darkSecondaryBackground : AppColors.lightCardBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    context.read<ThemeProvider>().isDark ? Icons.dark_mode : Icons.light_mode,
                    color:context.read<ThemeProvider>().isDark ?  AppColors.textPrimary :AppColors.primaryBlue,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.read<ThemeProvider>().isDark ? AppColors.darkSecondaryBackground : AppColors.lightCardBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: context.read<ThemeProvider>().isDark ?  AppColors.textPrimary :AppColors.primaryBlue,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildSpentIndicator() {
    double percentage = (spentAmount / totalBudget) * 100;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.watch<ThemeProvider>().isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spent: \$${spentAmount.toStringAsFixed(0)} / \$${totalBudget.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style:Theme.of(context).textTheme.labelMedium,
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




