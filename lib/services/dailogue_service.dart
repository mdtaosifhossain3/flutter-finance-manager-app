import 'package:finance_manager_app/services/monthly_pdf_summary_service.dart';
import 'package:finance_manager_app/services/weekly_pdf_summary_service.dart';
import 'package:flutter/material.dart';
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
    await _checkWeeklyDialog(context, prefs);
    await _checkMonthlyDialog(context, prefs);
  }

  static Future<void> _checkWeeklyDialog(
    BuildContext context,
    SharedPreferences prefs,
  ) async {
    final lastShownString = prefs.getString(_weeklyKey);
    final now = DateTime.now();

    if (lastShownString != null) {
      final lastShown = DateTime.parse(lastShownString);
      if (now.difference(lastShown).inDays < 1) return; // not yet 7 days
    } else {
      // No previous date, don't show on first real open
      await prefs.setString(_weeklyKey, now.toIso8601String());
      return;
    }

    await _showWeeklyDialog(context);
    await prefs.setString(_weeklyKey, now.toIso8601String());
  }

  static Future<void> _checkMonthlyDialog(
    BuildContext context,
    SharedPreferences prefs,
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

    await _showMonthlyDialog(context);
    await prefs.setString(_monthlyKey, now.toIso8601String());
  }

  // Weekly Dialog
  static Future<void> _showWeeklyDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("📅 Weekly Financial Summary"),
        content: const Text(
          "Here's your weekly financial summary! Take a look at your expenses this week.",
        ),
        actions: [
          TextButton(
            child: const Text("View Insights"),
            onPressed: () {
              WeeklyPdfGenerator.generateWeeklyReportPdf(DateTime.now());

              Navigator.pop(context);
              // Navigate to monthly report if you want
              // Navigator.pushNamed(context, '/report');
            },
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  // Weekly Dialog
  static Future<void> showWeeklyDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("📅 Weekly Financial Summary"),
        content: const Text(
          "Here's your weekly financial summary! Take a look at your expenses this week.",
        ),
        actions: [
          TextButton(
            child: const Text("View Insights"),
            onPressed: () {
              WeeklyPdfGenerator.generateWeeklyReportPdf(DateTime.now());
              Navigator.pop(context);
              // Navigate to monthly report if you want
              // Navigator.pushNamed(context, '/report');
            },
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  // Monthly Dialog
  static Future<void> _showMonthlyDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("📊 Monthly Financial Report"),
        content: const Text(
          "New month, new insights! Check your monthly income and spending summary.",
        ),
        actions: [
          TextButton(
            child: const Text("View Insights"),
            onPressed: () {
              MonthlyPdfGenerator.generateMonthlyReportPdf(DateTime.now());

              Navigator.pop(context);
              // Navigate to monthly report if you want
              // Navigator.pushNamed(context, '/report');
            },
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  // Monthly Dialog
  static Future<void> showMonthlyDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("📊 Monthly Financial Report"),
        content: const Text(
          "New month, new insights! Check your monthly income and spending summary.",
        ),
        actions: [
          TextButton(
            child: const Text("View Insights"),
            onPressed: () {
              MonthlyPdfGenerator.generateMonthlyReportPdf(DateTime.now());
              Navigator.pop(context);
              // Navigate to monthly report if you want
              // Navigator.pushNamed(context, '/report');
            },
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
