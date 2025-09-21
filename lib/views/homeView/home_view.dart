import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../../providers/theme_provider.dart';
import 'widgets/segmented_progress_bar_widget.dart';

class HomeView extends StatefulWidget {
  @override
  _StatisticsHomeScreenState createState() => _StatisticsHomeScreenState();
}

class _StatisticsHomeScreenState extends State<HomeView>
    with TickerProviderStateMixin {
  String selectedPeriod = 'M';
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  String _formatCurrency(double amount) {
    if (amount >= 1000) {
      return amount
          .toStringAsFixed(0)
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    }
    return amount.toStringAsFixed(2);
  }

  // Data for different time periods
  final Map<String, PeriodData> periodData = {
    'W': PeriodData(
      expenses: 600.50,
      budget: 600.0,
      title: 'This Week',
      transactions: [
        TransactionData(
          'Coffee Shop',
          'Today, 9:15 AM',
          4.50,
          Icons.coffee,
          Colors.brown,
        ),
        TransactionData(
          'Uber Ride',
          'Yesterday, 6:30 PM',
          12.80,
          Icons.local_taxi,
          Colors.black,
        ),
        TransactionData(
          'Grocery Store',
          'Yesterday, 2:10 PM',
          45.20,
          Icons.shopping_cart,
          Colors.green,
        ),
        TransactionData(
          'Netflix',
          '16 Dec, 8:00 PM',
          15.99,
          Icons.movie,
          Colors.red,
        ),
        TransactionData(
          'Lunch',
          '15 Dec, 1:30 PM',
          22.50,
          Icons.restaurant,
          Colors.orange,
        ),
      ],
    ),
    'M': PeriodData(
      expenses: 6500.0,
      budget: 9050.0,
      title: 'This Month',
      transactions: [
        TransactionData(
          'Apple Pay',
          '15 Dec, 8:00 PM',
          149.00,
          Icons.apple,
          Colors.white,
        ),
        TransactionData(
          'Spotify Premium',
          '14 Dec, 4:30 PM',
          46.50,
          Icons.library_music,
          Colors.green,
        ),
        TransactionData(
          'John Abraham',
          '14 Dec, 2:10 PM',
          92.00,
          Icons.person,
          Colors.green,
        ),
        TransactionData(
          'Shopping',
          '14 Dec, 2:10 PM',
          225.50,
          Icons.shopping_bag,
          Colors.green,
        ),
        TransactionData(
          'Electricity Bill',
          '12 Dec, 10:00 AM',
          156.80,
          Icons.flash_on,
          Colors.yellow,
        ),
      ],
    ),
    'Y': PeriodData(
      expenses: 78400.0,
      budget: 108000.0,
      title: 'This Year',
      transactions: [
        TransactionData(
          'Annual Insurance',
          '01 Dec, 9:00 AM',
          2400.00,
          Icons.security,
          Colors.blue,
        ),
        TransactionData(
          'Car Payment',
          '28 Nov, 3:00 PM',
          850.00,
          Icons.directions_car,
          Colors.grey,
        ),
        TransactionData(
          'Vacation Trip',
          '15 Nov, 6:00 PM',
          3200.00,
          Icons.flight,
          Colors.purple,
        ),
        TransactionData(
          'Home Renovation',
          '10 Nov, 11:00 AM',
          4500.00,
          Icons.home,
          Colors.orange,
        ),
        TransactionData(
          'Investment',
          '05 Nov, 2:30 PM',
          5000.00,
          Icons.trending_up,
          Colors.green,
        ),
      ],
    ),
  };

  // Getters for current period data
  double get currentExpenses => periodData[selectedPeriod]!.expenses;
  double get currentBudget => periodData[selectedPeriod]!.budget;
  List<TransactionData> get currentTransactions =>
      periodData[selectedPeriod]!.transactions;
  String get currentTitle => periodData[selectedPeriod]!.title;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _updateProgressAnimation();

    // Start animation after a short delay
    Future.delayed(Duration(milliseconds: 300), () {
      _progressController.forward();
    });
  }

  void _updateProgressAnimation() {
    _progressAnimation =
        Tween<double>(begin: 0.0, end: currentExpenses / currentBudget).animate(
          CurvedAnimation(
            parent: _progressController,
            curve: Curves.easeInOutCubic,
          ),
        );
  }

  void _onPeriodChanged(String period) {
    if (selectedPeriod != period) {
      setState(() {
        selectedPeriod = period;
      });

      // Reset and restart animation with new values
      _progressController.reset();
      _updateProgressAnimation();

      Future.delayed(Duration(milliseconds: 100), () {
        _progressController.forward();
      });
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03,
                ),
                child: Column(
                  children: [
                    _buildExpensesChart(),

                    SizedBox(height: 16),
                    _buildTransactionHistory(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Wednesday', style: Theme.of(context).textTheme.bodySmall),
              Text(
                '17 September',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  context.read<ThemeProvider>().toggleTheme();
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.read<ThemeProvider>().isDark
                        ? AppColors.darkSecondaryBackground
                        : AppColors.lightCardBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    context.read<ThemeProvider>().isDark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: context.read<ThemeProvider>().isDark
                        ? AppColors.textPrimary
                        : AppColors.primaryBlue,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.read<ThemeProvider>().isDark
                        ? AppColors.darkSecondaryBackground
                        : AppColors.lightCardBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: context.read<ThemeProvider>().isDark
                        ? AppColors.textPrimary
                        : AppColors.primaryBlue,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesChart() {
    return Column(
      children: [
        SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(shape: BoxShape.circle),
              ),
              // Animated progress circle
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(280, 280),
                    painter: CircularProgressPainter(
                      progress: _progressAnimation.value,
                      strokeWidth: 20,
                      backgroundColor: context.watch<ThemeProvider>().isDark
                          ? AppColors.darkSecondaryBackground
                          : AppColors.lightSecondaryBackground,
                      segmentColors: [
                        AppColors.primaryBlue,
                        AppColors.success,
                        AppColors.warning,
                        AppColors.error,
                      ],
                    ),
                  );
                },
              ),

              // Center content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Expenses',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '£${_formatCurrency(currentExpenses)}',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Out of £${_formatCurrency(currentBudget)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        _buildPeriodSelector(),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    final periods = ['W', 'M', 'Y'];

    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.watch<ThemeProvider>().isDark
            ? AppColors.darkSecondaryBackground
            : AppColors.lightSecondaryBackground,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: periods.map((period) {
          final isSelected = selectedPeriod == period;
          return GestureDetector(
            onTap: () => _onPeriodChanged(period),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: context.watch<ThemeProvider>().isDark
                    ? isSelected
                          ? AppColors.primaryBlue
                          : Colors.transparent
                    : isSelected
                    ? AppColors.textPrimary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                period,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTransactionHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's History",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                backgroundColor: context.watch<ThemeProvider>().isDark
                    ? Colors.transparent
                    : AppColors.lightSecondaryBackground,
                foregroundColor: AppColors.textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {},
              child: Text(
                "See All",
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        // SizedBox(height: 20),
        ...currentTransactions.map(
          (transaction) => _buildTransactionItem(transaction),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(TransactionData transaction) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.watch<ThemeProvider>().isDark
            ? AppColors.darkSecondaryBackground
            : AppColors.lightSecondaryBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: transaction.iconColor == Colors.white
                  ? Colors.grey[800]
                  : transaction.iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transaction.icon,
              color: transaction.iconColor == Colors.white
                  ? Colors.white
                  : transaction.iconColor,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(height: 4),
                Text(
                  transaction.date,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          Text(
            '£${transaction.amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress; // from 0.0 to 1.0
  final double strokeWidth;
  final Color backgroundColor;
  final List<Color> segmentColors;

  CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.segmentColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final double startAngle = -math.pi / 2;
    final double sweepAngle = 2 * math.pi * progress;

    // 🔘 Draw background (empty circle in grey)
    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect.deflate(20), 0, 2 * math.pi, false, bgPaint);

    // 🔘 Divide progress into up to 4 colored segments
    final double segmentSweep = sweepAngle / segmentColors.length;

    for (int i = 0; i < segmentColors.length; i++) {
      final paint = Paint()
        ..color = segmentColors[i]
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final double start = startAngle + (i * segmentSweep);

      // Only draw until progress is reached
      if (progress > (i / segmentColors.length)) {
        double sweep = math.min(
          segmentSweep,
          sweepAngle - (i * segmentSweep),
        ); // handle partial last arc
        if (sweep > 0) {
          canvas.drawArc(rect.deflate(20), start, sweep, false, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class PeriodData {
  final double expenses;
  final double budget;
  final String title;
  final List<TransactionData> transactions;

  PeriodData({
    required this.expenses,
    required this.budget,
    required this.title,
    required this.transactions,
  });
}

class TransactionData {
  final String title;
  final String date;
  final double amount;
  final IconData icon;
  final Color iconColor;

  TransactionData(
    this.title,
    this.date,
    this.amount,
    this.icon,
    this.iconColor,
  );
}
