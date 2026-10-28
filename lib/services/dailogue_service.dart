import 'package:finance_manager_app/config/db/local/notification_db/notification_db_helper.dart';
import 'package:finance_manager_app/models/notificationModel/notification_model.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/services/report_pdf_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

/// Offers last week's report on the first app open of each new week
/// (Monday to Sunday), and last month's report on the first open of each new
/// month.
class DialogService {
  static const _weeklyKey = 'last_weekly_dialog_date';
  static const _monthlyKey = 'last_monthly_dialog_date';
  static const _firstLaunchKey = 'is_first_launch';

  // HomeView calls this every time it is rebuilt (e.g. switching tabs).
  static bool _running = false;

  /// Call this on app startup or Home screen init
  static Future<void> checkAndShowDialogs(BuildContext context) async {
    if (_running) return;
    _running = true;
    try {
      final prefs = await SharedPreferences.getInstance();

      final isFirstLaunch = prefs.getBool(_firstLaunchKey) ?? true;
      if (isFirstLaunch) {
        // First app open: nothing to report yet. Start counting from now.
        final now = DateTime.now().toIso8601String();
        await prefs.setBool(_firstLaunchKey, false);
        await prefs.setString(_weeklyKey, now);
        await prefs.setString(_monthlyKey, now);
        return;
      }

      if (context.mounted) await _check(prefs, context, ReportKind.weekly);
      if (context.mounted) await _check(prefs, context, ReportKind.monthly);
    } finally {
      _running = false;
    }
  }

  static Future<void> _check(
    SharedPreferences prefs,
    BuildContext context,
    ReportKind kind,
  ) async {
    final key = kind == ReportKind.weekly ? _weeklyKey : _monthlyKey;
    final now = DateTime.now();
    final lastShown = DateTime.tryParse(prefs.getString(key) ?? '');

    if (lastShown == null) {
      await prefs.setString(key, now.toIso8601String());
      return;
    }
    // Already offered during the current week / month?
    final period = ReportPeriod.previous(kind, now);
    if (!lastShown.isBefore(period.end)) return;

    // Remember before showing, so it is never offered twice.
    await prefs.setString(key, now.toIso8601String());

    if (!context.mounted) return;
    final db = context.read<AddExpenseProvider>().addTransactionDbHelper;
    if ((await period.loadTransactions(db)).isEmpty) return;

    await NotificationDbHelper().insertNotification(
      NotificationModel(
        title: kind == ReportKind.weekly
            ? "weeklyFinancialSummaryTitle".tr
            : "monthlyFinancialReportTitle".tr,
        body: kind == ReportKind.weekly
            ? "weeklyFinancialSummaryDescription".tr
            : "monthlyFinancialReportDescription".tr,
        date: now,
        reportKind: kind,
      ),
    );

    if (context.mounted) await _showDialog(context, period);
  }

  static Future<void> _showDialog(
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
