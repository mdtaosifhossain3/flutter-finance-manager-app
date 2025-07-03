import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  String selectedMonth = 'April';
  String selectedYear = '2023';
  bool showCategories = false;
  int selectedDate = 30;

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final List<String> years = ['2021', '2022', '2023', '2024', '2025'];

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
      backgroundColor: const Color(0xFF00C896),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      'Calendar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(Icons.notifications_outlined, color: Colors.white),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),

                    // Month and Year Selector
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => _showMonthPicker(),
                            child: Row(
                              children: [
                                Text(
                                  selectedMonth,
                                  style: TextStyle(
                                    color: Color(0xFF00C896),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color(0xFF00C896),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _showYearPicker(),
                            child: Row(
                              children: [
                                Text(
                                  selectedYear,
                                  style: TextStyle(
                                    color: Color(0xFF00C896),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color(0xFF00C896),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // Calendar Grid
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          // Week days header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: weekDays.map((day) {
                              return SizedBox(
                                width: 35,
                                child: Text(
                                  day,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF00C896),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          SizedBox(height: 16),

                          // Calendar dates
                          _buildCalendarGrid(),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // Toggle Buttons
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  showCategories = false;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: !showCategories
                                      ? Color(0xFF00C896)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Spends',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: !showCategories
                                        ? Colors.white
                                        : Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  showCategories = true;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: showCategories
                                      ? Color(0xFF00C896)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Categories',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: showCategories
                                        ? Colors.white
                                        : Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // Content Area
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: showCategories
                            ? _buildCategoriesView()
                            : _buildSpendsView(),
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return Column(
      children: [
        // First row: 1-7
        _buildCalendarRow([1, 2, 3, 4, 5, 6, 7]),
        SizedBox(height: 8),
        // Second row: 8-14
        _buildCalendarRow([8, 9, 10, 11, 12, 13, 14]),
        SizedBox(height: 8),
        // Third row: 15-21
        _buildCalendarRow([15, 16, 17, 18, 19, 20, 21]),
        SizedBox(height: 8),
        // Fourth row: 22-28
        _buildCalendarRow([22, 23, 24, 25, 26, 27, 28]),
        SizedBox(height: 8),
        // Fifth row: 29-31
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDateCell(29),
            _buildDateCell(30),
            _buildDateCell(31),
            ...List.generate(4, (index) => Container(width: 35)),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendarRow(List<int> dates) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: dates.map((date) => _buildDateCell(date)).toList(),
    );
  }

  Widget _buildDateCell(int date) {
    bool isSelected = date == selectedDate;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDate = date;
        });
      },
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF00C896) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            date.toString(),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpendsView() {
    return Column(
      children: [
        _buildSpendItem(
          Icons.shopping_cart,
          'Groceries',
          '17:00 - April 24',
          'Pantry',
          '-\$100.00',
          Colors.blue,
        ),
        SizedBox(height: 16),
        _buildSpendItem(
          Icons.more_horiz,
          'Others',
          '17:00 - April 24',
          'Payments',
          '\$120.00',
          Colors.lightBlue,
        ),
      ],
    );
  }

  Widget _buildSpendItem(
    IconData icon,
    String title,
    String time,
    String category,
    String amount,
    Color iconColor,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                category,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              SizedBox(height: 4),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: amount.contains('-') ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesView() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 50,
                sections: [
                  PieChartSectionData(
                    color: Color(0xFF4A90E2),
                    value: 79,
                    title: '79%',
                    radius: 60,
                    titleStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Color(0xFF7BB3F0),
                    value: 11,
                    title: '11%',
                    radius: 60,
                    titleStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Color(0xFF9AC5F4),
                    value: 10,
                    title: '10%',
                    radius: 60,
                    titleStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('Groceries', Color(0xFF4A90E2)),
              _buildLegendItem('Others', Color(0xFF7BB3F0)),
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
        SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.black87)),
      ],
    );
  }

  void _showMonthPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Select Month',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: months.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(months[index]),
                      onTap: () {
                        setState(() {
                          selectedMonth = months[index];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showYearPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Select Year',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: years.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(years[index]),
                      onTap: () {
                        setState(() {
                          selectedYear = years[index];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
