import 'package:finance_manager_app/config/db/local/notification_db/notification_db_helper.dart';
import 'package:finance_manager_app/models/notificationModel/notification_model.dart';
import 'package:finance_manager_app/services/monthly_pdf_summary_service.dart';
import 'package:finance_manager_app/services/weekly_pdf_summary_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DialogService {
  static const _weeklyKey = 'last_weekly_dialog_date';
  static const _monthlyKey = 'last_monthly_dialog_date';
  static const _firstLaunchKey = 'is_first_launch';

  /// Call this on app startup or Home screen init
  static Future<void> checkAndShowDialogs(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    final isFirstLaunch = prefs.getBool(_firstLaunchKey) ?? true;
    if (isFirstLaunch) {
      // First app open: don't show dialogs, just mark first launch done
      await prefs.setBool(_firstLaunchKey, false);
      return;
    }

    // Show dialogs for subsequent app opens
    if (context.mounted) await _checkWeeklyDialog(prefs, context);
    if (context.mounted) await _checkMonthlyDialog(prefs, context);
  }

  static Future<void> _checkWeeklyDialog(
    SharedPreferences prefs,
    BuildContext context,
  ) async {
    final lastShownString = prefs.getString(_weeklyKey);
    final now = DateTime.now();

    if (lastShownString != null) {
      final lastShown = DateTime.parse(lastShownString);
      if (now.difference(lastShown).inDays < 7) return; // not yet 7 days
    } else {
      // No previous date, don't show on first real open
      await prefs.setString(_weeklyKey, now.toIso8601String());
      return;
    }

    if (context.mounted) await _showWeeklyDialog(context);
    await prefs.setString(_weeklyKey, now.toIso8601String());
    final NotificationModel notificationModel = NotificationModel(
      title: "weeklyFinancialSummaryTitle".tr,
      body: "weeklyFinancialSummaryDescription".tr,
      date: DateTime.now(),
    );
    NotificationDbHelper().insertNotification(notificationModel);
  }

  static Future<void> _checkMonthlyDialog(
    SharedPreferences prefs,
    BuildContext context,
  ) async {
    final lastShownString = prefs.getString(_monthlyKey);
    final now = DateTime.now();

    if (lastShownString != null) {
      final lastShown = DateTime.parse(lastShownString);
      if (lastShown.year == now.year && lastShown.month == now.month) {
        return; // already shown this month
      }
    } else {
      // No previous date, don't show on first real open
      await prefs.setString(_monthlyKey, now.toIso8601String());
      return;
    }

    if (context.mounted) await _showMonthlyDialog(context);
    await prefs.setString(_monthlyKey, now.toIso8601String());
    final NotificationModel notificationModel = NotificationModel(
      title: "monthlyFinancialReportTitle".tr,
      body: "monthlyFinancialReportDescription".tr,
      date: DateTime.now(),
    );
    NotificationDbHelper().insertNotification(notificationModel);
  }

  // Weekly Dialog
  static Future<void> _showWeeklyDialog(BuildContext context) async {
    await Get.dialog(
      AlertDialog(
        title: Text("weeklyFinancialSummaryTitle".tr),
        content: Text("weeklyFinancialSummaryDescription".tr),
        actions: [
          TextButton(
            child: const Text("View Insights"),
            onPressed: () {
              // ✅ Call your PDF generator
              WeeklyPdfGenerator.generateWeeklyReportPdf(
                DateTime.now(),
                context,
              );

              Get.back(); // Close the dialog
            },
          ),
          TextButton(onPressed: () => Get.back(), child: const Text("Close")),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Monthly Dialog
  static Future<void> _showMonthlyDialog(BuildContext context) async {
    await Get.dialog(
      AlertDialog(
        title: Text("monthlyFinancialReportTitle".tr),
        content: Text("monthlyFinancialReportDescription".tr),
        actions: [
          TextButton(
            child: Text("viewInsights".tr),
            onPressed: () {
              MonthlyPdfGenerator.generateMonthlyReportPdf(
                DateTime(DateTime.now().year, DateTime.now().month - 1, 1),
                context,
              );

              Get.back();
            },
          ),
          TextButton(onPressed: () => Get.back(), child: Text("close".tr)),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
