import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/providers/reportProvider/report_provider.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MonthlyBudgetChartWidget extends StatefulWidget {
  const MonthlyBudgetChartWidget({super.key});

  @override
  State<MonthlyBudgetChartWidget> createState() =>
      _MonthlyBudgetChartWidgetState();
}

class _MonthlyBudgetChartWidgetState extends State<MonthlyBudgetChartWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReportProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'monthlyBudget'.tr,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width * .82,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    maxX: provider.montlydata.isEmpty
                        ? 0
                        : (provider.montlydata.length - 1).toDouble(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 45,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '৳ ${HelperFunctions.recievedIntAndconvertToBanglaDigits(value.toInt())}',
                              style: Theme.of(context).textTheme.labelSmall,
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 ||
                                index >= provider.montlydata.length) {
                              return const SizedBox.shrink();
                            }

                            final month =
                                provider.montlydata[index]['months'] ?? '';

                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 8, // Similar spacing to BarChart
                              child: Text(
                                HelperFunctions.getLocalizedMonth(month),
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12, // Match bar chart text size
                                ),
                              ),
                            );
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
                    lineBarsData: [
                      // 💰 Income Line
                      LineChartBarData(
                        spots: List.generate(provider.montlydata.length, (
                          index,
                        ) {
                          final income =
                              provider.montlydata[index]['income']
                                  ?.toDouble() ??
                              0.0;
                          return FlSpot(index.toDouble(), income);
                        }),
                        isCurved: true,
                        color: AppColors.primaryBlue,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryBlue.withOpacity(0.3),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),

                      // 💸 Expense Line
                      LineChartBarData(
                        spots: List.generate(provider.montlydata.length, (
                          index,
                        ) {
                          final expense =
                              provider.montlydata[index]['expenses']
                                  ?.toDouble() ??
                              0.0;
                          return FlSpot(index.toDouble(), expense);
                        }),
                        isCurved: true,
                        color: AppColors.error,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.error.withOpacity(0.3),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Theme.of(context).colorScheme.surface,
                        tooltipRoundedRadius: 12,
                      ),
                    ),
                    maxY: provider.getMaxY(),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  _buildLegendItem('budget'.tr, AppColors.primaryBlue),
                  SizedBox(width: 20),
                  _buildLegendItem('spent'.tr, AppColors.error),
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
        SizedBox(width: 6),
        Text(label, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
      ],
    );
  }
}
