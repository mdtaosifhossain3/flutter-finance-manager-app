import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/models/expense_data_model.dart';
import 'package:finance_manager_app/providers/report_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../globalWidgets/card_widget.dart';
import '../../../providers/home_provider.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});
  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    context.read<ReportProvider>().filterCategoryFunction();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "Expenses"),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildPeriodTabs(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
              child: Column(
                children: [
                 _buildDonutChart(),

                  SizedBox(height: 24),
                  Consumer<HomeViewProvider>(
                    builder: (context, provider, child) {
                      final filteredTxns = provider.filteredTransactions;

                      return filteredTxns.isEmpty
                          ? const Text("No transactions yet")
                          : Column(
                        children: filteredTxns
                            .map((tx) => CardWidget(transaction: tx))
                            .toList(),
                      );
                    },
                  )
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
              hintText: 'Super AI search',
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textMuted),
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
    final periods = ['Daily', 'Weekly', 'Monthly',];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
      child: Row(
        children: periods.map((period) {
          final isSelected = context.watch<ReportProvider>().selectedPeriod == period;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                //  selectedPeriod = period;
                  context.read<ReportProvider>().setSelectedMonth(period);
                  if(period =="Daily"){
                    print("d");
                    context.read<HomeViewProvider>().setDWM("d");
                  } else if(period =="Weekly"){
                    print("dw");
                    context.read<HomeViewProvider>().setDWM("w");
                  } else{
                    print("dwm");
                    context.read<HomeViewProvider>().setDWM("m");

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
      builder: (context,provider,child) {
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
                    sections:provider.filterCategories.map((category) {
                      double percentage = (category["amount"] / total) * 100;
                      return PieChartSectionData(
                        color: Color(category["color"]),
                        value: percentage,
                        title: '${percentage.toStringAsFixed(0)}%',
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
      }
    );
  }


  Widget _buildChartLegend() {
    return Consumer<HomeViewProvider>(
      builder: (context,provider,child) {
        final filteredTxns = provider.filterTransactions(provider.dwm);

        return Align(
          alignment: Alignment.centerLeft, // 👈 push whole wrap to right
          child: Wrap(
            alignment: WrapAlignment.start,   // 👈 items start from right
            spacing: 16,
            runSpacing: 8,
            children: [

            ...filteredTxns.map((expense) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.withValues(alpha:0.1),
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
                        expense.categoryName,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      }
    );


  }


}
