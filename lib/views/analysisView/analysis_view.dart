import 'package:finance_manager_app/config/myColors/my_colors.dart';
import 'package:finance_manager_app/config/routes/routes_name.dart';
import 'package:finance_manager_app/globalWidgets/balance_expense_card_widget.dart';
import 'package:finance_manager_app/globalWidgets/notification_widget.dart';
import 'package:finance_manager_app/globalWidgets/progress_bar_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  String selectedPeriod = 'Daily';

  final List<String> periods = ['Daily', 'Weekly', 'Monthly', 'Year'];

  // Sample data for the chart
  final List<double> weeklyData = [8, 3, 6, 4, 12, 2, 8];
  final List<String> weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.analysisBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Analysis',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: MyColors.honeyDew,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  NotificationWidget(),
                ],
              ),
            ),
            // Balance and Expense Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BalanceExpenseCardWidget(
                bgColor: MyColors.honeyDew,
                totalBTColor: MyColors.textPrimary,
                totalETColor: MyColors.errorColor,
                textColor: MyColors.textHint,
                iconColor: MyColors.textHint,
              ),
            ),
            SizedBox(height: 16),
            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ProgressBarWidget(),
            ),
            SizedBox(height: 8),
            // Status Message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: MyColors.honeyDew, size: 16),
                  SizedBox(width: 8),
                  Text(
                    '30% Of Your Expenses, Looks Good.',
                    style: TextStyle(color: MyColors.honeyDew, fontSize: 14),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            // Main Content Area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: MyColors.honeyDew,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),

                    // Period Selection
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: MyColors.surfaceBackground,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: periods.map((period) {
                          bool isSelected = selectedPeriod == period;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPeriod = period;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? MyColors.analysisChartGreen
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                period,
                                style: TextStyle(
                                  color: isSelected
                                      ? MyColors.honeyDew
                                      : Colors.grey[600],
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Chart Section
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: MyColors.analysisPeriodBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Income & Expenses',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      child: Icon(
                                        Icons.search,
                                        color: Color(0xFF00C896),
                                      ),

                                      onTap: () {
                                        Get.toNamed(RoutesName.searchView);
                                      },
                                    ),

                                    IconButton(
                                      icon: Icon(Icons.calendar_month),
                                      color: Color(0xFF00C896),
                                      onPressed: () {
                                        Get.toNamed(RoutesName.calenderView);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            SizedBox(height: 20),

                            // Chart
                            Expanded(
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: 15,
                                  barTouchData: BarTouchData(enabled: false),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            weekDays[value.toInt()],
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 5,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            '${value.toInt()}k',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 10,
                                            ),
                                          );
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
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    horizontalInterval: 5,
                                  ),
                                  barGroups: weeklyData.asMap().entries.map((
                                    entry,
                                  ) {
                                    return BarChartGroupData(
                                      x: entry.key,
                                      barRods: [
                                        BarChartRodData(
                                          toY: entry.value,
                                          color: Color(0xFF00C896),
                                          width: 20,
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Income and Expense Summary
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildSummaryCard(
                              'Income',
                              '৳ 4,120.00',
                              Color(0xFF00C896),
                              Icons.trending_up,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildSummaryCard(
                              'Expense',
                              '৳ 1,187.40',
                              Colors.blue,
                              Icons.trending_down,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // // Bottom Navigation
                    // Container(
                    //   padding: EdgeInsets.symmetric(vertical: 16),
                    //   decoration: BoxDecoration(
                    //     color: Color(0xFFF0F9F7),
                    //     borderRadius: BorderRadius.only(
                    //       topLeft: Radius.circular(20),
                    //       topRight: Radius.circular(20),
                    //     ),
                    //   ),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       _buildNavItem(Icons.home_outlined, false),
                    //       _buildNavItem(Icons.pie_chart, true),
                    //       _buildNavItem(Icons.swap_horiz, false),
                    //       _buildNavItem(Icons.layers_outlined, false),
                    //       _buildNavItem(Icons.person_outline, false),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String amount,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MyColors.honeyDew,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
