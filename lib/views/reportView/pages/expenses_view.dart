import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/reportProvider/report_provider.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../globalWidgets/card_widget.dart';
import '../../../providers/homeProvider/home_provider.dart';

class ExpensesView extends StatefulWidget {
  const ExpensesView({super.key});
  @override
  State<ExpensesView> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesView> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ReportProvider>().filterCategoryFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: "expensesTitle".tr,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildPeriodTabs(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
              ),
              child: Column(
                children: [
                  _buildDonutChart(),

                  SizedBox(height: 24),
                  Consumer<HomeViewProvider>(
                    builder: (context, provider, child) {
                      final filteredTxns =
                          provider.filteredTransactionsForReport;

                      return filteredTxns.isEmpty
                          ? Text("noTransactions".tr)
                          : Column(
                              children: filteredTxns
                                  .map((tx) => CardWidget(transaction: tx))
                                  .toList(),
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Consumer<HomeViewProvider>(
      builder: (context, provider, child) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04,
            vertical: 16,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: searchController,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: 'search'.tr,
              hintStyle: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
              prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onChanged: (value) {
              provider.setSearchQuery(value);
            },
          ),
        );
      },
    );
  }

  Widget _buildPeriodTabs() {
    final periods = ['periodDay'.tr, 'periodWeek'.tr, 'periodMonth'.tr];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
      ),
      child: Row(
        children: periods.map((period) {
          final isSelected =
              context.watch<ReportProvider>().selectedPeriod == period;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                //  selectedPeriod = period;
                context.read<ReportProvider>().setSelectedMonth(period);
                if (period == "periodDay".tr) {
                  context.read<HomeViewProvider>().setDWM("periodDay".tr);
                } else if (period == "periodWeek".tr) {
                  context.read<HomeViewProvider>().setDWM("periodWeek".tr);
                } else {
                  context.read<HomeViewProvider>().setDWM("periodMonth".tr);
                }
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
                  style: isSelected
                      ? Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.secondaryBlue,
                          fontWeight: FontWeight.w600,
                        )
                      : Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMuted,
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
    return Consumer<ReportProvider>(
      builder: (context, provider, child) {
        double total = provider.filterCategories.fold(
          0,
          (sum, category) => sum + category["amount"],
        );
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
                child: PieChart(
                  PieChartData(
                    sections: provider.filterCategories.map((category) {
                      double percentage = (category["amount"] / total) * 100;
                      final a = HelperFunctions.convertToBanglaDigits(
                        percentage.toStringAsFixed(0),
                      );
                      return PieChartSectionData(
                        color: Color(category["color"]),
                        value: percentage,
                        title: '$a%',
                        radius: 60,
                        titleStyle: TextStyle(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w400,
                        ),
                      );
                    }).toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: 20,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildChartLegend(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChartLegend() {
    return Consumer<HomeViewProvider>(
      builder: (context, provider, child) {
        final filteredTxns = provider.filterTransactions(provider.dwm);

        return Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 16,
            runSpacing: 8,
            children: [
              ...filteredTxns.map((expense) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.withValues(alpha: 0.1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Color(expense.iconBgColor),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        expense.categoryKey.tr,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
