import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/models/tempm/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:finance_manager_app/views/homeView/home_view_model.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  // String HomeViewModel.selectedPeriod = 'M';
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  // String _formatCurrency(double amount) {
  //   if (amount >= 1000) {
  //     return amount
  //         .toStringAsFixed(0)
  //         .replaceAllMapped(
  //           RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
  //           (Match m) => '${m[1]},',
  //         );
  //   }
  //   return amount.toStringAsFixed(2);
  // }

  // Data for different time periods
  final Map<String, PeriodData> periodData = {
    'W': PeriodData(
      expenses: 600.50,
      budget: 600,
      title: 'This Week',
      transactions:[
        TransactionModel(
            type: TransactionType.expense,
            date: DateTime.now(),
            title: "",
            categoryName: "Hospital",
            amount: 120,
            paymentMethod: "Cash",
            icon: Icons.local_hospital,
            iconBgColor:  Color(0xFFFF6B6B)
        ),
        TransactionModel(
            type: TransactionType.expense,
            date: DateTime.now(),
            title: "",
            categoryName: "Medicine Doctor",
            amount: 120,
            paymentMethod: "Hospital",
            icon: Icons.medication,
            iconBgColor:  Color(0xFF4ECDC4)
        ),
        TransactionModel(
            type: TransactionType.expense,
            date: DateTime.now(),
            title: "",
            categoryName: "Food",
            amount: 120,
            paymentMethod: "Hospital",
            icon: Icons.local_hospital,
            iconBgColor:  Color(0xFFFF6B6B)
        ),
        TransactionModel(
            type: TransactionType.expense,
            date: DateTime.now(),
            title: "",
            categoryName: "Food",
            amount: 120,
            paymentMethod: "Hospital",
            icon: Icons.local_hospital,
            iconBgColor:  Color(0xFFFF6B6B)
        ),
      ]



    ),
    'M': PeriodData(
      expenses: 6500,
      budget: 9050,
      title: 'This Month',
      transactions: [

      ],
    ),
    'Y': PeriodData(
      expenses: 78400,
      budget: 108000,
      title: 'This Year',
      transactions: [

      ],
    ),
  };

  // Getters for current period data
  double get currentExpenses =>
      periodData[HomeViewModel.selectedPeriod]!.expenses;
  double get currentBudget => periodData[HomeViewModel.selectedPeriod]!.budget;
  List<TransactionModel> get currentTransactions =>
      periodData[HomeViewModel.selectedPeriod]!.transactions;
  String get currentTitle => periodData[HomeViewModel.selectedPeriod]!.title;

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
    if (HomeViewModel.selectedPeriod != period) {
      setState(() {
        HomeViewModel.selectedPeriod = period;
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
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                ),
                child: Column(
                  children: [
                    _buildExpensesChart(),

                    SizedBox(height: 16),
                    _buildTransactionHistory(),
                    SizedBox(height: 100),
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
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04, vertical: 10),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Wednesday", style: Theme.of(context).textTheme.labelSmall),
              Text(
                '17 September',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          Row(
            children: [
              // SizedBox(width: 10),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: Theme.of(context).primaryColor,
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
                      backgroundColor: Theme.of(context).dividerColor,
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
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '৳${HomeViewModel.formatCurrency(currentExpenses)}',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Out of ৳${HomeViewModel.formatCurrency(currentBudget)}',
                    style: Theme.of(context).textTheme.labelMedium,
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
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: periods.map((period) {
          final isSelected = HomeViewModel.selectedPeriod == period;
          return GestureDetector(
            onTap: () => _onPeriodChanged(period),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surface.withOpacity(isSelected ? .97 : 0.0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                period,
                style: isSelected
                    ? Theme.of(context).textTheme.titleMedium
                    : Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMuted,
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
            Text("History", style: Theme.of(context).textTheme.headlineSmall),
            TextButton(
              onPressed: () {},
              child: Text(
                "See All",
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: AppColors.primaryBlue),
              ),
            ),
          ],
        ),

        SizedBox(height: 14),
        ...currentTransactions.map(
          (transaction) => _buildTransactionItem(transaction),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(TransactionModel transaction) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color:transaction.iconBgColor,
            //  borderRadius: BorderRadius.circular(12),
              shape: BoxShape.circle
            ),
            child: Icon(transaction.icon,color: Colors.white,),
          ),

          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.categoryName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 4),
                Text(
                  HelperFunctions.getFormattedDateTime(transaction.date),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          Text(
            '${transaction.type == TransactionType.expense ?"-":""}৳${transaction.amount}',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(color: transaction.type == TransactionType.expense ? AppColors.error:AppColors.lightTextMuted),
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
  final List<TransactionModel> transactions;

  PeriodData({
    required this.expenses,
    required this.budget,
    required this.title,
    required this.transactions,
  });
}

