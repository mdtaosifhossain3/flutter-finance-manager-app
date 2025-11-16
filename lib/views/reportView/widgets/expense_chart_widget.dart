import 'package:finance_manager_app/providers/reportProvider/report_provider.dart';
import 'package:finance_manager_app/views/reportView/pages/expenses_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../config/myColors/app_colors.dart';

class ExpenseChartWidget extends StatefulWidget {
  const ExpenseChartWidget({super.key});

  @override
  State<ExpenseChartWidget> createState() => _ExpenseChartWidgetState();
}

class _ExpenseChartWidgetState extends State<ExpenseChartWidget> {
  @override
  Widget build(BuildContext context) {
    double total = context.watch<ReportProvider>().filterCategories.fold(
      0,
      (sum, category) => sum + category["amount"],
    );

    return GestureDetector(
      onTap: () {
        // Handle tap event if needed
        Get.to(() => ExpensesView());
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'expensesTitle'.tr,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 150,
                    child: PieChart(
                      PieChartData(
                        sections: context
                            .watch<ReportProvider>()
                            .filterCategories
                            .map((category) {
                              double percentage =
                                  (category["amount"] / total) * 100;
                              return PieChartSectionData(
                                color: Color(category["color"]),
                                value: percentage,
                                title: '${percentage.toStringAsFixed(0)}%',
                                radius: 60,
                                titleStyle: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            })
                            .toList(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...context
                          .watch<ReportProvider>()
                          .filterCategories
                          .take(5) // 👈 only first 5
                          .map((category) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Color(category["color"]),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${category['categoryName']}".tr,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelMedium,
                                  ),
                                ],
                              ),
                            );
                          }),
                      if (context
                              .watch<ReportProvider>()
                              .filterCategories
                              .length >
                          5)
                        Text(
                          "seeAllButton".tr,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
