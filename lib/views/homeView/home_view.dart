import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/config/routes/routes_name.dart';
import 'package:finance_manager_app/providers/budget/budget_provider.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/providers/homeProvider/home_provider.dart';
import 'package:finance_manager_app/providers/theme_provider.dart';
import 'package:finance_manager_app/services/dailogue_service.dart';
import 'package:finance_manager_app/services/reminder_helper.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:finance_manager_app/views/homeView/widgets/home_view_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';

import 'dart:math' as math;

import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late AnimationController _progressController;
  late final pv = context.read<HomeViewProvider>();

  Future<void> _checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (mounted &&
          info.updateAvailability == UpdateAvailability.updateAvailable) {
        await updateHandler();
      }
    } catch (e) {
      // Handle update check errors silently
      //print('Update check error: $e');
    }
  }

  Future<void> updateHandler() async {
    try {
      await InAppUpdate.startFlexibleUpdate();
      await InAppUpdate.completeFlexibleUpdate();
    } catch (e) {
      // print('Update error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _checkForUpdate();
    _progressController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    // Start animation after a short delay
    Future.delayed(Duration(milliseconds: 200), () {
      _progressController.forward();
    });

    // Schedule async call after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      DialogService.checkAndShowDialogs(context);

      // Fetch initial data
      if (mounted) {
        context.read<AddExpenseProvider>().getTransactionsForMonth(
          DateTime.now(),
        );
        context.read<BudgetProvider>().loadBudgets();
      }

      await ReminderHelper.scheduleDailyTip();
      await ReminderHelper.scheduleDailyTransactionReview();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _onPeriodChanged(String period) {
    if (pv.dwm != period) {
      pv.setDWM(period);

      // Reset and restart animation with new values
      _progressController.reset();

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
                HelperFunctions.getLocalizedDate().split(',')[1].trim(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  // Get.to(SentOtpView());
                  Get.toNamed(RoutesName.notificationView);
                  //   Get.to(PricingView());
                },

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
    final homeProvider = context.watch<HomeViewProvider>();
    final totals = homeProvider.getTotals();
    int expense = totals["expenses"] ?? 0;
    int income = totals["income"] ?? 0;

    int remaining = (income == 0 || expense == 0) ? 0 : income - expense;

    // Calculate progress based on ReportProvider totals
    double progressEnd = 0.0;
    if (income > 0) {
      progressEnd = expense / income;
    }

    final progressAnimation = Tween<double>(begin: 0.0, end: progressEnd)
        .animate(
          CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
        );

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
                  animation: progressAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(280, 280),
                      painter: CircularProgressPainter(
                        progress: progressAnimation.value,
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
                      remaining < 0 ? 'overspent'.tr : 'remaining'.tr,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${remaining < 0 ? '-' : ''}${HelperFunctions.convertToBanglaDigits(remaining.abs().toString())}',

                      // HelperFunctions.convertToBanglaDigits(
                      //   context
                      //       .watch<HomeViewProvider>()
                      //       .getTotals()["expenses"]
                      //       .toString(),
                      // ),
                      //style: Theme.of(context).textTheme.headlineLarge,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                        color: remaining < 0
                            ? AppColors.error
                            : context.watch<ThemeProvider>().themeMode ==
                                  ThemeMode.dark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    SizedBox(height: 4),

                    Text(
                      '${"outOfText".tr} ৳${HelperFunctions.convertToBanglaDigits(income.toString())}',
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
        builder: (context, provider, child) {
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
                    color: Theme.of(context).colorScheme.surface.withValues(
                      alpha: isSelected ? .97 : 0.0,
                    ),
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
        },
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
              "historyTitle".tr,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            // TextButton(
            //   onPressed: () {
            //     Get.to(ExpensesView());
            //   },
            //   child: Text(
            //     "seeAllButton".tr,
            //     style: Theme.of(
            //       context,
            //     ).textTheme.labelMedium?.copyWith(color: AppColors.primaryBlue),
            //   ),
            // ),
          ],
        ),

        SizedBox(height: 14),

        Consumer<HomeViewProvider>(
          builder: (context, provider, _) {
            final filteredTxns = provider.filteredTransactionsForHome;

            // Show loading if initial data fetch is happening
            if (context.watch<AddExpenseProvider>().isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: filteredTxns.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: Text("noTransactions".tr)),
                    )
                  : ListView.builder(
                      key: ValueKey<String>(
                        provider.dwm,
                      ), // rebuild on period change
                      //   reverse: true,
                      itemCount: filteredTxns.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final tx = filteredTxns[index];
                        return HomeViewCardWidget(transaction: tx);
                      },
                    ),
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
