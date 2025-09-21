import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/models/budget_data_model.dart';
import 'package:finance_manager_app/providers/theme_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthlyBudgetChartWidget extends StatelessWidget {
List<BudgetData>  monthlyData;
   MonthlyBudgetChartWidget({super.key, required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:context.watch<ThemeProvider>().isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Budget',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '৳ ${(value.toInt())}',
                          style: Theme.of(context).textTheme.labelSmall,
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < monthlyData.length) {
                          return Text(
                            monthlyData[value.toInt()].month,
                            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                          );
                        }
                        return Text('');
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Budget line (green)
                  LineChartBarData(
                    spots: monthlyData.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value.budget);
                    }).toList(),
                    isCurved: true,
                    color:AppColors.primaryBlue,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                  // Spent line (orange/red)
                  LineChartBarData(
                    spots: monthlyData.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value.spent);
                    }).toList(),
                    isCurved: true,
                    color: AppColors.primaryPurple,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: AppColors.darkSecondaryBackground,
                    tooltipRoundedRadius: 12, // 👈 round corners
                    // getTooltipItems: (touchedSpots) {
                    //   return touchedSpots.map((barSpot) {
                    //     return LineTooltipItem(
                    //       '${barSpot.y}', // your value
                    //       TextStyle(
                    //         color: Colors.white, // 👈 text color inside tooltip
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 10,
                    //       ),
                    //     );
                    //   }).toList();
                    // },
                  ),
                ),
                minY: 0,
                maxY: 2500,
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildLegendItem('Budget', AppColors.primaryBlue),
              SizedBox(width: 20),
              _buildLegendItem('Spent', AppColors.primaryPurple),
            ],
          ),
        ],
      ),
    );
  }
Widget _buildLegendItem(String label, Color color) {
  return Row(
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      SizedBox(width: 6),
      Text(
        label,
        style: TextStyle(color: AppColors.textMuted, fontSize: 12),
      ),
    ],
  );
}
}
