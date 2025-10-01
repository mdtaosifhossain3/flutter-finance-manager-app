import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/models/budget_data_model.dart';
import 'package:finance_manager_app/providers/report_provider.dart';
import 'package:finance_manager_app/providers/theme_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:provider/provider.dart';

class MonthlyBudgetChartWidget extends StatefulWidget {
 final List<BudgetData> monthlyData;
 const MonthlyBudgetChartWidget({super.key, required this.monthlyData});

  @override
  State<MonthlyBudgetChartWidget> createState() => _MonthlyBudgetChartWidgetState();
}

class _MonthlyBudgetChartWidgetState extends State<MonthlyBudgetChartWidget> {
  @override

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
                        if (value.toInt() < context.read<ReportProvider>().montlydata.length) {
                          return Text(
                            context.watch<ReportProvider>().montlydata[value.toInt()]["months"],
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          );
                        }
                        return Text('');
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Budget line (green)
                  LineChartBarData(
                    spots: context.watch<ReportProvider>().montlydata.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), (entry.value["income"] as double));
                    }).toList(),
                    isCurved: true,
                    color: AppColors.primaryBlue,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                  // Spent line (orange/red)
                  LineChartBarData(
                    spots: context.watch<ReportProvider>().montlydata.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), (entry.value["expenses"] as double));
                    }).toList(),
                    isCurved: true,
                    color: AppColors.error,
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
                maxY:  context.watch<ReportProvider>().getMaxY(),
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildLegendItem('Budget', AppColors.primaryBlue),
              SizedBox(width: 20),
              _buildLegendItem('Spent', AppColors.error),
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
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6),
        Text(label, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
      ],
    );
  }
}
