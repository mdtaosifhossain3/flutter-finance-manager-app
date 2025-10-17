import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:finance_manager_app/views/reportView/widgets/expense_chart_widget.dart';
import 'package:finance_manager_app/views/reportView/widgets/last_six_days_period_chart_widget.dart';
import 'package:finance_manager_app/views/reportView/widgets/monthly_budget_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../providers/reportProvider/report_provider.dart';

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  @override
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reportProvider = context.read<ReportProvider>();
    reportProvider.getMonthlyTotals();
    reportProvider.periodDatafunction();
    reportProvider.filterCategoryFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "reportTitle".tr),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04,
            vertical: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSpentIndicator(),
              SizedBox(height: 24),
              ExpenseChartWidget(),
              SizedBox(height: 24),
              MonthlyBudgetChartWidget(),
              SizedBox(height: 24),
              LastFiveDaysPeriodChartWidget(),
            SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpentIndicator() {
    final reportProvider = context.watch<ReportProvider>();
    final totals = reportProvider.getCurrentMonthTotals();
    int expense = totals["expense"] ?? 0;
    int income = totals["income"] ?? 0;

    double percentage = 0;
    if (income > 0 && expense > 0) {
      percentage = (expense / income) * 100;
    }

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
                '${"spent".tr}: ৳${HelperFunctions.convertToBanglaDigits(expense.toString())} / ৳${HelperFunctions.convertToBanglaDigits(income.toString())}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '${HelperFunctions.convertToBanglaDigits(percentage.round().toString())}%',
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
            value: percentage,
            backgroundColor: AppColors.darkSecondaryBackground,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}
