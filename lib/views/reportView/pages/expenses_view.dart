import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/reportProvider/report_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../globalWidgets/card_widget.dart';

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
                  Consumer<ReportProvider>(
                    builder: (context, provider, child) {
                      final filteredTxns = provider.filteredTransactions;

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
    return Consumer<ReportProvider>(
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
                context.read<ReportProvider>().setSelectedMonth(period);
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
                    sections: context
                        .watch<ReportProvider>()
                        .filterCategories
                        .asMap()
                        .entries
                        .map((entry) {
                          var category = entry.value;
                          double percentage =
                              (category["amount"] / total) * 100;

                          // Only show percentage if it's above 5%
                          bool showTitle = percentage >= 5;

                          return PieChartSectionData(
                            color: Color(category["color"]),
                            value: percentage,
                            title: showTitle
                                ? '${percentage.toStringAsFixed(1)}%'
                                : '',
                            radius: 65,
                            titleStyle: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            titlePositionPercentageOffset: 0.55,
                          );
                        })
                        .toList(),
                    sectionsSpace: 1,
                    centerSpaceRadius: 35,
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        // Optional: Add touch interaction here
                      },
                    ),
                  ),
                ),
              ),
              //   SizedBox(height: 20),
              //   _buildChartLegend(),
            ],
          ),
        );
      },
    );
  }
}
