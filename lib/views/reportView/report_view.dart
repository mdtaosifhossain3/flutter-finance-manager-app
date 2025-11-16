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
              // _buildSpentIndicator(),
              _buildSummaryCard(),
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

  Widget _buildSummaryCard() {
    final reportProvider = context.watch<ReportProvider>();
    final totals = reportProvider.getCurrentMonthTotals();
    int expense = totals["expense"] ?? 0;
    int income = totals["income"] ?? 0;

    int remaining = (income == 0 || expense == 0) ? 0 : income - expense;
    final String rm = remaining < 0 ? 'over'.tr : 'remaining'.tr;
    final Color rmc = remaining < 0 ? AppColors.error : AppColors.success;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        // gradient: LinearGradient(
        //   colors: [
        //     Theme.of(context).primaryColor,
        //     Theme.of(context).colorScheme.secondary,
        //   ],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).cardColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'balance_summary'.tr,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBudgetMetric('total'.tr, income, AppColors.primaryBlue),
              _buildBudgetMetric('spent'.tr, expense, AppColors.warning),
              _buildBudgetMetric(rm, remaining, rmc),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetMetric(String label, int amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        SizedBox(height: 4),
        Text(
          '${amount < 0 ? '-' : ''}৳${HelperFunctions.convertToBanglaDigits(amount.abs().toString())}',
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Widget _buildSpentIndicator() {
  //   final reportProvider = context.watch<ReportProvider>();
  //   final totals = reportProvider.getCurrentMonthTotals();
  //   int expense = totals["expense"] ?? 0;
  //   int income = totals["income"] ?? 0;

  //   double percentage = 0;
  //   if (income > 0 && expense > 0) {
  //     percentage = (expense / income) * 100;
  //   }

  //   return Container(
  //     padding: EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).cardColor,
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               '${"spent".tr}: ৳${HelperFunctions.convertToBanglaDigits(expense.toString())} / ৳${HelperFunctions.convertToBanglaDigits(income.toString())}',
  //               style: Theme.of(context).textTheme.titleMedium,
  //             ),
  //             Text(
  //               '${HelperFunctions.convertToBanglaDigits(percentage.round().toString())}%',
  //               style: Theme.of(context).textTheme.titleLarge?.copyWith(
  //                 color: percentage > 90
  //                     ? AppColors.error
  //                     : percentage > 75
  //                     ? AppColors.warning
  //                     : AppColors.primaryBlue,
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 12),
  //         LinearProgressIndicator(
  //           value: percentage,
  //           backgroundColor: AppColors.darkSecondaryBackground,
  //           valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
  //           minHeight: 8,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
