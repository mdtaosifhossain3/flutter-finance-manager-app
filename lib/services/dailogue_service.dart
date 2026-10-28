import 'package:finance_manager_app/config/db/local/notification_db/notification_db_helper.dart';
import 'package:finance_manager_app/models/notificationModel/notification_model.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/providers/reportProvider/report_provider.dart';
import 'package:finance_manager_app/services/report_pdf_service.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:finance_manager_app/views/mainView/main_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

/// Popups shown when the home screen opens:
/// - first open of a new month: explains that Home now starts fresh and
///   where to find last month's data
/// - last day of the month: this month's report
/// - first open of a new week: last week's report
class DialogService {
  static const _weeklyKey = 'last_weekly_dialog_date';
  static const _monthlyReportKey = 'last_monthly_report_month';
  static const _newMonthKey = 'last_new_month_popup_month';
  static const _firstLaunchKey = 'is_first_launch';

  // HomeView calls this every time it is rebuilt (e.g. switching tabs).
  static bool _running = false;

  /// "2026-10" style id of the month containing [date].
  static String _monthId(DateTime date) => '${date.year}-${date.month}';

  /// Call this on app startup or Home screen init
  static Future<void> checkAndShowDialogs(BuildContext context) async {
    if (_running) return;
    _running = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();

      final isFirstLaunch = prefs.getBool(_firstLaunchKey) ?? true;
      if (isFirstLaunch) {
        // First app open: nothing to report yet. Start counting from now.
        await prefs.setBool(_firstLaunchKey, false);
        await prefs.setString(_weeklyKey, now.toIso8601String());
        await prefs.setString(_newMonthKey, _monthId(now));
        return;
      }

      if (context.mounted) await _checkNewMonth(prefs, context);
      if (context.mounted) await _checkMonthlyReport(prefs, context);
      if (context.mounted) await _checkWeeklyReport(prefs, context);
    } catch (e) {
      debugPrint('DialogService: $e');
    } finally {
      _running = false;
    }
  }

  // ----------------------------
  //  NEW MONTH POPUP
  // ----------------------------

  static Future<void> _checkNewMonth(
    SharedPreferences prefs,
    BuildContext context,
  ) async {
    final now = DateTime.now();
    final lastSeen = prefs.getString(_newMonthKey);

    // Remember before showing, so it is never shown twice in a month.
    await prefs.setString(_newMonthKey, _monthId(now));

    // Users updating the app mid-month have no value yet: don't show it then.
    if (lastSeen == null || lastSeen == _monthId(now)) return;

    if (!context.mounted) return;
    final lastMonth = ReportPeriod.lastMonth(now);
    final db = context.read<AddExpenseProvider>().addTransactionDbHelper;
    if ((await lastMonth.loadTransactions(db)).isEmpty) return;

    if (context.mounted) await _showNewMonthDialog(context, lastMonth.start);
  }

  static String _monthLabel(DateTime month) =>
      HelperFunctions.getLocalizedMonth(DateFormat('MMM').format(month));

  static Future<void> _showNewMonthDialog(
    BuildContext context,
    DateTime lastMonth,
  ) async {
    final monthName = _monthLabel(lastMonth);

    final viewReport = await Get.dialog<bool>(
      Builder(
        builder: (dialogContext) {
          final theme = Theme.of(dialogContext);
          return AlertDialog(
            icon: const Icon(Icons.calendar_month_rounded, size: 40),
            title: Text('new_month_title'.tr, textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'new_month_message'.trParams({'month': monthName}),
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 16),
                _HowToStep(
                  icon: Icons.pie_chart_rounded,
                  text: 'new_month_step_report'.tr,
                ),
                const SizedBox(height: 10),
                _HowToStep(
                  icon: Icons.calendar_month,
                  text: 'new_month_step_calendar'.tr,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text('okay'.tr),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(
                  'new_month_view_button'.trParams({'month': monthName}),
                ),
              ),
            ],
          );
        },
      ),
      barrierDismissible: false,
    );

    if (viewReport == true && context.mounted) {
      // Open the Report tab on last month
      context.read<ReportProvider>().updateSelectedMonth(lastMonth);
      MainView.openTab(MainView.reportTab);
    }
  }

  // ----------------------------
  //  MONTHLY REPORT (LAST DAY OF THE MONTH)
  // ----------------------------

  static Future<void> _checkMonthlyReport(
    SharedPreferences prefs,
    BuildContext context,
  ) async {
    final now = DateTime.now();
    if (!ReportPeriod.isLastDayOfMonth(now)) return;
    if (prefs.getString(_monthlyReportKey) == _monthId(now)) return;

    // Remember before showing, so it is never offered twice.
    await prefs.setString(_monthlyReportKey, _monthId(now));

    if (!context.mounted) return;
    await _offerReport(context, ReportPeriod.thisMonth(now));
  }

  // ----------------------------
  //  WEEKLY REPORT (FIRST OPEN OF A NEW WEEK)
  // ----------------------------

  static Future<void> _checkWeeklyReport(
    SharedPreferences prefs,
    BuildContext context,
  ) async {
    final now = DateTime.now();
    final lastShown = DateTime.tryParse(prefs.getString(_weeklyKey) ?? '');

    if (lastShown == null) {
      await prefs.setString(_weeklyKey, now.toIso8601String());
      return;
    }
    // Already offered during the current week?
    final period = ReportPeriod.lastWeek(now);
    if (!lastShown.isBefore(period.end)) return;

    // Remember before showing, so it is never offered twice.
    await prefs.setString(_weeklyKey, now.toIso8601String());

    if (!context.mounted) return;
    await _offerReport(context, period);
  }

  /// Saves the report to the notification list and shows the dialog,
  /// unless the period has no transactions.
  static Future<void> _offerReport(
    BuildContext context,
    ReportPeriod period,
  ) async {
    final db = context.read<AddExpenseProvider>().addTransactionDbHelper;
    if ((await period.loadTransactions(db)).isEmpty) return;

    final weekly = period.kind == ReportKind.weekly;
    await NotificationDbHelper().insertNotification(
      NotificationModel(
        title: weekly
            ? "weeklyFinancialSummaryTitle".tr
            : "monthlyFinancialReportTitle".tr,
        body: weekly
            ? "weeklyFinancialSummaryDescription".tr
            : "monthlyFinancialReportDescription".tr,
        date: DateTime.now(),
        reportKind: period.kind,
      ),
    );

    if (context.mounted) await _showReportDialog(context, period);
  }

  static Future<void> _showReportDialog(
    BuildContext context,
    ReportPeriod period,
  ) async {
    final weekly = period.kind == ReportKind.weekly;
    final viewReport = await Get.dialog<bool>(
      Builder(
        builder: (dialogContext) => AlertDialog(
          title: Text(
            weekly
                ? "weeklyFinancialSummaryTitle".tr
                : "monthlyFinancialReportTitle".tr,
          ),
          content: Text(
            weekly
                ? "weeklyFinancialSummaryDescription".tr
                : "monthlyFinancialReportDescription".tr,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text("close".tr),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text("viewInsights".tr),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    if (viewReport == true && context.mounted) {
      await ReportPdfService.open(context, period);
    }
  }
}

/// One "how to find it" line in the new month popup.
class _HowToStep extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HowToStep({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
        ),
      ],
    );
  }
}
