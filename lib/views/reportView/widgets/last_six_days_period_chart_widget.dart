import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/myColors/app_colors.dart';
import '../../../providers/report_provider.dart';

class LastFiveDaysPeriodChartWidget extends StatefulWidget {
  const LastFiveDaysPeriodChartWidget({super.key});

  @override
  State<LastFiveDaysPeriodChartWidget> createState() => _LastFiveDaysPeriodChartWidgetState();
}

class _LastFiveDaysPeriodChartWidgetState extends State<LastFiveDaysPeriodChartWidget> {

  @override
  Widget build(BuildContext context) {
    final periodData = context.watch<ReportProvider>().periodData;
  print(periodData);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Last 6 periods',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: context.watch<ReportProvider>().getMaxYof6DayPeriod(),
                barTouchData: BarTouchData(enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Theme.of(context).colorScheme.surface,)),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '৳ ${value.toInt()}',
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
                            periodData[value.toInt()]["month"],
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: periodData.asMap().entries.map((entry) {
                  final data = entry.value;
                  Color barColor = AppColors.secondaryBlue;
                  double  barValue = data["within"];

                  if (data["overspending"] > 0) {
                    barColor = AppColors.warning;
                    barValue = data["overspending"];
                  } else if (data["risk"] > 0) {
                    barColor = AppColors.error;
                    barValue = data["risk"];
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
          const SizedBox(height: 16),
          Row(
            children: [
              _buildLegendItem('Within', AppColors.secondaryBlue),
              const SizedBox(width: 15),
              _buildLegendItem('Risk', AppColors.error),
              const SizedBox(width: 15),
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
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
      ],
    );
  }
}
