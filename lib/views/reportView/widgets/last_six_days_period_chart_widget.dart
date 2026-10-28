import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../config/myColors/app_colors.dart';
import '../../../providers/reportProvider/report_provider.dart';

class LastFiveDaysPeriodChartWidget extends StatefulWidget {
  const LastFiveDaysPeriodChartWidget({super.key});

  @override
  State<LastFiveDaysPeriodChartWidget> createState() =>
      _LastFiveDaysPeriodChartWidgetState();
}

class _LastFiveDaysPeriodChartWidgetState
    extends State<LastFiveDaysPeriodChartWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReportProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '6periods'.tr,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: provider.getMaxYof6DayPeriod(),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: (provider.getMaxYof6DayPeriod() / 5) == 0
                              ? 100
                              : (provider.getMaxYof6DayPeriod() / 5),
                          reservedSize: 50,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '৳ ${HelperFunctions.formatCompactNumber(value)}',
                              style: Theme.of(context).textTheme.labelSmall,
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < provider.periodData.length) {
                              return Text(
                                HelperFunctions.getLocalizedMonth(
                                  provider.periodData[value.toInt()]["month"],
                                ),
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
                    barGroups: provider.periodData.asMap().entries.map((entry) {
                      final data = entry.value;
                      Color barColor = AppColors.secondaryBlue;
                      double barValue = data["within"];

                      if (data["overspending"] > 0) {
                        barColor = AppColors.error;
                        barValue = data["overspending"];
                      } else if (data["risk"] > 0) {
                        barColor = AppColors.warning;
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
                  _buildLegendItem('within'.tr, AppColors.secondaryBlue),
                  const SizedBox(width: 15),
                  _buildLegendItem('risk'.tr, AppColors.warning),
                  const SizedBox(width: 15),
                  _buildLegendItem('overspending'.tr, AppColors.error),
                ],
              ),
            ],
          ),
        );
      },
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
