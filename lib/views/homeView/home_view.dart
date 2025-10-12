import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/card_widget.dart';
import 'package:finance_manager_app/providers/homeProvider/home_provider.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

import '../reportView/pages/expenses_view.dart';
import 'home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    // Start animation after a short delay
    Future.delayed(Duration(milliseconds: 200), () {
      _progressController.forward();
    });
  }

  @override
  void didChangeDependencies() {
    _updateProgressAnimation();
    super.didChangeDependencies();
  }

  void _updateProgressAnimation() {
    _progressAnimation =
        Tween<double>(
          begin: 0.0,
          end:
              context.read<HomeViewProvider>().getTotals()["expenses"]! /
              context.read<HomeViewProvider>().getTotals()["income"]!,
        ).animate(
          CurvedAnimation(
            parent: _progressController,
            curve: Curves.easeInOutCubic,
          ),
        );
  }

  void _onPeriodChanged(String period) {
    if (context.read<HomeViewProvider>().dwm != period) {
      context.read<HomeViewProvider>().setDWM(period);

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
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: 10,
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                HelperFunctions.getLocalizedDate().split(',')[0],
                style: Theme.of(context).textTheme.labelSmall,
              ),
              Text(
                HelperFunctions.getLocalizedDate().split(',')[1].trim(),                textAlign: TextAlign.center,
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
                    color: AppColors.primaryBlue,
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
    return SingleChildScrollView(
      child: Column(
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
                      'expensesTitle'.tr,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      HelperFunctions.convertToBanglaDigits(context
                          .watch<HomeViewProvider>()
                          .getTotals()["expenses"]
                          .toString(),),

                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    SizedBox(height: 4),
                  
                    Text(
                      '${"outOfText".tr} ৳${HelperFunctions.convertToBanglaDigits(context.watch<HomeViewProvider>().getTotals()["income"].toString())}',
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
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = ['periodDay'.tr, 'periodWeek'.tr, 'periodMonth'.tr];

    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Consumer<HomeViewProvider>(
        builder: (context,provider,child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: periods.map((period) {
              final isSelected = provider.dwm == period;
              return GestureDetector(
                onTap: () => _onPeriodChanged(period),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: isSelected ? .97 : 0.0),
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
          );
        }
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
            Text("historyTitle".tr, style: Theme.of(context).textTheme.headlineSmall),
            TextButton(
              onPressed: () {
                Get.to(ExpensesView());
              },
              child: Text(
                "seeAllButton".tr,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: AppColors.primaryBlue),
              ),
            ),
          ],
        ),

        SizedBox(height: 14),

        Consumer<HomeViewProvider>(
          builder: (context, provider, child) {
            final filteredTxns = provider.filterTransactions(provider.dwm);

            return filteredTxns.isEmpty
                ?  Text("noTransactions".tr)
                : SizedBox(
                  child: ListView.builder(
                    reverse: true,
                                itemCount: filteredTxns.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index){
                    final tx = filteredTxns[index];
                    return CardWidget(transaction:tx ,);
                              }),
                );
          },
        ),
      ],
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
