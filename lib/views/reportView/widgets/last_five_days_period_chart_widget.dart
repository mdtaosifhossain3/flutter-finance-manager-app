import 'package:finance_manager_app/models/period_data_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/myColors/app_colors.dart';
import '../../../providers/theme_provider.dart';

class LastFiveDaysPeriodChartWidget extends StatelessWidget {
 List<PeriodData> periodData;
  LastFiveDaysPeriodChartWidget({super.key, required this.periodData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.watch<ThemeProvider>().isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last 6 periods',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 2500,
                barTouchData: BarTouchData(enabled: false),
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
                        if (value.toInt() < periodData.length) {
                          return Text(
                            periodData[value.toInt()].period,
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
                barGroups: periodData.asMap().entries.map((entry) {
                  final data = entry.value;
                  Color barColor = AppColors.secondaryBlue; // within
                  double barValue = data.within;

                  if (data.overspending > 0) {
                    barColor =  AppColors.warning;
                    barValue = data.overspending;
                  } else if (data.risk > 0) {
                    barColor = AppColors.error;
                    barValue = data.risk;
                  }

                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: barValue,
                        color: barColor,
                        width: 20,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
                gridData: FlGridData(show: false),
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildLegendItem('Within', AppColors.secondaryBlue),
              SizedBox(width: 15),
              _buildLegendItem('Risk', AppColors.error),
              SizedBox(width: 15),
              _buildLegendItem('Overspending', AppColors.warning),
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
          style: TextStyle(color:  AppColors.textMuted, fontSize: 12),
        ),
      ],
    );
  }
}
