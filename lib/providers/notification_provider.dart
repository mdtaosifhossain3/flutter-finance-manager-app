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

  Future<void> toggleAllNotifications(bool value) async {
    _allNotifications = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('allNotifications', value);

    // If turning off all, we might want to cancel everything or just stop future scheduling
    // If turning on, we might want to reschedule enabled ones
    if (value) {
      _rescheduleEnabledNotifications();
    } else {
      _cancelAllNotifications();
    }

    notifyListeners();
  }

  Future<void> toggleDailyTip(bool value) async {
    _dailyTip = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dailyTip', value);

    if (_allNotifications && value) {
      ReminderHelper.scheduleDailyTip();
    } else {
      // We need a way to cancel specific notifications.
      // ReminderHelper needs to expose cancel methods or fixed IDs.
      // For now, we rely on the check inside scheduleDailyTip not to run if disabled,
      // but to cancel an existing one, we need the ID.
      // Daily Tip ID is 999.
      ReminderHelper.chanceledRemidnerNoti(999);
    }
    notifyListeners();
  }

  Future<void> toggleDailyTransactionReview(bool value) async {
    _dailyTransactionReview = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dailyTransactionReview', value);

    if (_allNotifications && value) {
      ReminderHelper.scheduleDailyTransactionReview();
    } else {
      // Daily Transaction Review ID is 777.
      ReminderHelper.chanceledRemidnerNoti(777);
    }
    notifyListeners();
  }

  Future<void> toggleBudgetNotification(bool value) async {
    _budgetNotification = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('budgetNotification', value);

    // Budget notifications are more complex as they are per budget.
    // We might need to iterate over budgets to reschedule or cancel.
    // For now, we just save the preference. The ReminderHelper will check this preference.
    notifyListeners();
  }

  void _rescheduleEnabledNotifications() {
    if (_dailyTip) ReminderHelper.scheduleDailyTip();
    if (_dailyTransactionReview) {
      ReminderHelper.scheduleDailyTransactionReview();
    }
    // Budget notifications would need to be rescheduled by the BudgetProvider or similar
  }

  void _cancelAllNotifications() {
    ReminderHelper.chanceledRemidnerNoti(999); // Daily Tip
    ReminderHelper.chanceledRemidnerNoti(777); // Transaction Review
    // We should ideally cancel all budget notifications too
    // _notificationsPlugin.cancelAll(); // This would be best if exposed in ReminderHelper
  }
}
