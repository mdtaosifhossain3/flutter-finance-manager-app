import 'package:finance_manager_app/models/expense_category_model.dart';
import 'package:finance_manager_app/views/reportView/pages/expenses_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../config/myColors/app_colors.dart';
import '../../../providers/theme_provider.dart';

class ExpenseChartWidget extends StatelessWidget {
  List<ExpenseCategoryModel> expenseCategories;
  ExpenseChartWidget({super.key, required this.expenseCategories});

  @override
  Widget build(BuildContext context) {
    double total = expenseCategories.fold(
      0,
      (sum, category) => sum + category.amount,
    );

    return GestureDetector(
      onTap: () {
        // Handle tap event if needed
        Get.to(() => ExpensesScreen());
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
            Text('Expenses', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 150,
                    child: PieChart(
                      PieChartData(
                        sections: expenseCategories.map((category) {
                          double percentage = (category.amount / total) * 100;
                          return PieChartSectionData(
                            color: category.color,
                            value: percentage,
                            title: '${percentage.toStringAsFixed(0)}%',
                            radius: 60,
                            titleStyle: TextStyle(
                              fontSize: 12,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }).toList(),
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
                    children: expenseCategories.map((category) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: category.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              category.name,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
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
