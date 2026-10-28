import 'package:finance_manager_app/services/reminder_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier {
  bool _allNotifications = true;
  bool _dailyTip = true;
  bool _dailyTransactionReview = true;
  bool _budgetNotification = true;

  bool get allNotifications => _allNotifications;
  bool get dailyTip => _dailyTip;
  bool get dailyTransactionReview => _dailyTransactionReview;
  bool get budgetNotification => _budgetNotification;

  NotificationProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _allNotifications = prefs.getBool('allNotifications') ?? true;
    _dailyTip = prefs.getBool('dailyTip') ?? true;
    _dailyTransactionReview = prefs.getBool('dailyTransactionReview') ?? true;
    _budgetNotification = prefs.getBool('budgetNotification') ?? true;
    notifyListeners();
  }

  /// [rescheduleBudgets] re-creates the daily budget notifications (from
  /// BudgetProvider) when they are turned back on.
  Future<void> toggleAllNotifications(
    bool value, {
    Future<void> Function()? rescheduleBudgets,
  }) async {
    _allNotifications = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('allNotifications', value);

    // User-created reminders are kept either way; this only controls the
    // app's own notifications (tip, review, budgets).
    if (value) {
      await _rescheduleEnabledNotifications(rescheduleBudgets);
    } else {
      await ReminderHelper.cancelAppNotifications();
    }
  }

  Future<void> toggleDailyTip(bool value) async {
    _dailyTip = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dailyTip', value);

    if (_allNotifications && value) {
      await ReminderHelper.scheduleDailyTip();
    } else {
      await ReminderHelper.chanceledRemidnerNoti(ReminderHelper.dailyTipId);
    }
  }

  Future<void> toggleDailyTransactionReview(bool value) async {
    _dailyTransactionReview = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dailyTransactionReview', value);

    if (_allNotifications && value) {
      await ReminderHelper.scheduleDailyTransactionReview();
    } else {
      await ReminderHelper.chanceledRemidnerNoti(
        ReminderHelper.transactionReviewId,
      );
    }
  }

  Future<void> toggleBudgetNotification(
    bool value, {
    Future<void> Function()? rescheduleBudgets,
  }) async {
    _budgetNotification = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('budgetNotification', value);

    if (_allNotifications && value) {
      await rescheduleBudgets?.call();
    } else {
      await ReminderHelper.cancelAllBudgetNotifications();
    }
  }

  Future<void> _rescheduleEnabledNotifications(
    Future<void> Function()? rescheduleBudgets,
  ) async {
    if (_dailyTip) await ReminderHelper.scheduleDailyTip();
    if (_dailyTransactionReview) {
      await ReminderHelper.scheduleDailyTransactionReview();
    }
    if (_budgetNotification) await rescheduleBudgets?.call();
  }
}
