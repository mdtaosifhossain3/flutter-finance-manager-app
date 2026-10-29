import 'dart:math';

import 'package:finance_manager_app/config/db/local/notification_db/notification_db_helper.dart';
import 'package:finance_manager_app/data/tipsData/tips_data.dart';
import 'package:finance_manager_app/models/notificationModel/notification_model.dart';
import 'package:finance_manager_app/models/recurringModel/recurring_item_model.dart';
import 'package:finance_manager_app/views/insightsView/insights_view.dart';
import 'package:finance_manager_app/views/recurringView/recurring_view.dart';
import 'package:finance_manager_app/views/reminderView/reminder_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class ReminderHelper {
  // ----------------------------
  //  NOTIFICATION IDS
  // ----------------------------
  // User reminders use their SQLite row id (small numbers), so every
  // app-generated notification lives in its own range far above them.
  static const int dailyTipId = 1000001;
  static const int transactionReviewId = 1000002;
  static const int transactionWarningId = 1000003;
  static const int weeklySummaryId = 1000004;
  static const int _budgetDailyBase = 2000000; // + budgetId * 8 + dayOffset
  static const int _budgetAlertBase = 3000000; // + budgetId
  static const int _recurringBase = 4000000; // + recurring item id

  // Days of daily budget notifications scheduled ahead (refreshed on app open)
  static const int _budgetDaysAhead = 7;

  // Payloads
  static const String _reminderPayload = 'reminder_page';
  static const String _dailyTipPayload = 'daily_tip';
  static const String _transactionReviewPayload = 'transaction_review';
  static const String _budgetPayload = 'budget_view';
  static const String _weeklySummaryPayload = 'weekly_summary';
  static const String _recurringPayload = 'recurring_view';

  // Ids used by earlier versions are cancelled once on upgrade
  static const String _legacyMigratedKey = 'noti_ids_migrated_v2';

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void>? _initFuture;

  static AndroidFlutterLocalNotificationsPlugin? get _android =>
      _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

  /// Safe to call multiple times; the work only runs once.
  static Future<void> initializeReminderNoti() {
    return _initFuture ??= _initialize().catchError((Object e) {
      _initFuture = null; // allow a retry on next call
      throw e;
    });
  }

  static Future<void> _initialize() async {
    tz.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));
    } catch (_) {
      // keep the timezone package default (UTC); schedule times are always
      // built from the device's local DateTime, so the instant stays correct
    }

    const adSettings = AndroidInitializationSettings("notification_icon");
    const initSettings = InitializationSettings(android: adSettings);
    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: notificationTapBackground,
    );

    const channels = [
      AndroidNotificationChannel(
        "reminder_channel",
        "Reminders",
        description: "Channel for Reminder Notification",
        importance: Importance.high,
        playSound: true,
      ),
      AndroidNotificationChannel(
        "daily_tip_channel",
        "Daily Finance Tips",
        description: "Channel for Daily Finance Tip",
        importance: Importance.high,
        playSound: true,
      ),
      AndroidNotificationChannel(
        "transaction_review_channel",
        "Daily Transaction Review",
        description: "Channel for Daily Transaction Review Reminders",
        importance: Importance.high,
        playSound: true,
      ),
      AndroidNotificationChannel(
        "budget_channel",
        "Budget Alerts",
        description: "Channel for Budget Limit Notifications",
        importance: Importance.high,
        playSound: true,
      ),
    ];
    for (final channel in channels) {
      await _android?.createNotificationChannel(channel);
    }

    await _cancelLegacyNotifications();
  }

  /// Older versions scheduled the daily tip as 999, the transaction review
  /// as 777 and budgets as 888000 + id. Remove those once so users who
  /// upgrade don't get duplicates. User reminders (payload reminder_page)
  /// are left untouched even if their id is 777 or 999.
  static Future<void> _cancelLegacyNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_legacyMigratedKey) ?? false) return;

      final pending = await _notificationsPlugin.pendingNotificationRequests();
      for (final p in pending) {
        if (p.payload == _reminderPayload) continue;
        final isLegacyId =
            p.id == 999 ||
            p.id == 777 ||
            (p.id >= 888000 && p.id < _budgetDailyBase);
        if (isLegacyId) await _notificationsPlugin.cancel(p.id);
      }
      await prefs.setBool(_legacyMigratedKey, true);
    } catch (e) {
      if (kDebugMode) print("Legacy notification cleanup error: $e");
    }
  }

  // ----------------------------
  //  PERMISSIONS
  // ----------------------------

  /// Opens the system "Alarms & reminders" screen. Only call this from a
  /// user action (e.g. saving a reminder), never from background scheduling.
  static Future<void> requestExactAlarmPermission() async {
    if (await _canScheduleExact()) return;
    await _android?.requestExactAlarmsPermission();
  }

  static Future<void> requestNotificationPermission() async {
    await _android?.requestNotificationsPermission();
  }

  /// Asks for POST_NOTIFICATIONS once (Android 13+) so daily tips,
  /// transaction reviews and budget alerts can actually be shown.
  static Future<void> requestNotificationPermissionOnce() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('noti_permission_asked') ?? false) return;
      await prefs.setBool('noti_permission_asked', true);
      await requestNotificationPermission();
    } catch (e) {
      if (kDebugMode) print("Notification permission error: $e");
    }
  }

  static Future<bool> _canScheduleExact() async {
    try {
      return await _android?.canScheduleExactNotifications() ?? true;
    } catch (_) {
      return false;
    }
  }

  /// Exact when allowed, otherwise inexact so the notification still
  /// arrives (possibly a few minutes late) instead of not at all.
  static Future<AndroidScheduleMode> _scheduleMode({
    AndroidScheduleMode exactMode = AndroidScheduleMode.exactAllowWhileIdle,
  }) async {
    return await _canScheduleExact()
        ? exactMode
        : AndroidScheduleMode.inexactAllowWhileIdle;
  }

  static Future<bool> _isEnabled(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final allNotifications = prefs.getBool('allNotifications') ?? true;
    return allNotifications && (prefs.getBool(key) ?? true);
  }

  /// Next occurrence of [hour]:[minute] in the device's local time.
  static tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = DateTime.now();
    var scheduled = DateTime(now.year, now.month, now.day, hour, minute);
    if (!scheduled.isAfter(now)) {
      scheduled = DateTime(now.year, now.month, now.day + 1, hour, minute);
    }
    return tz.TZDateTime.from(scheduled, tz.local);
  }

  // ----------------------------
  //  TAP HANDLING
  // ----------------------------

  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null) return;

    if (payload == _reminderPayload) {
      Get.to(() => ReminderView());
    } else if (payload == _weeklySummaryPayload) {
      Get.to(() => const InsightsView());
    } else if (payload == _recurringPayload) {
      Get.to(() => const RecurringView());
    } else if (payload.startsWith(_dailyTipPayload)) {
      // payload is "daily_tip:<tipKey>"
      final tipKey = payload.contains(':')
          ? payload.substring(payload.indexOf(':') + 1)
          : '';
      NotificationDbHelper().insertNotification(
        NotificationModel(
          title: "daily_finance_tip".tr,
          body: tipKey.isNotEmpty ? tipKey.tr : "Daily finance tip received",
          date: DateTime.now(),
        ),
      );
    } else if (payload == _transactionReviewPayload) {
      NotificationDbHelper().insertNotification(
        NotificationModel(
          title: "review_transactions_title".tr,
          body: "review_transactions_message".tr,
          date: DateTime.now(),
        ),
      );
    }
  }

  /// Handles the notification that launched the app from a terminated
  /// state ([onDidReceiveNotificationResponse] doesn't fire in that case).
  /// Call after the first screen has been pushed.
  static Future<void> handleLaunchNotification() async {
    try {
      await initializeReminderNoti();
      final details = await _notificationsPlugin
          .getNotificationAppLaunchDetails();
      final response = details?.notificationResponse;
      if (details?.didNotificationLaunchApp == true && response != null) {
        notificationTapBackground(response);
      }
    } catch (e) {
      if (kDebugMode) print("Launch notification error: $e");
    }
  }

  // ----------------------------
  //  USER REMINDERS
  // ----------------------------

  static Future<void> scheduleNoti(
    int id,
    String title,
    String body,
    DateTime time, {
    bool isRepeating = false,
  }) async {
    if (time.isBefore(DateTime.now()) && !isRepeating) {
      return;
    }

    // Repeating reminders fire at the next occurrence of their time of day.
    // A past date here would make Android fire the alarm immediately.
    final scheduledTime = isRepeating
        ? _nextInstanceOf(time.hour, time.minute)
        : tz.TZDateTime.from(time, tz.local);

    const notiDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        "reminder_channel",
        "Reminders",
        importance: Importance.high,
        priority: Priority.high,
        icon: 'notification_icon',
      ),
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      notiDetails,
      androidScheduleMode: await _scheduleMode(
        exactMode: AndroidScheduleMode.alarmClock,
      ),
      payload: _reminderPayload,
      matchDateTimeComponents: isRepeating ? DateTimeComponents.time : null,
    );
  }

  static Future<void> chanceledRemidnerNoti(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// ----------------------------
  ///  SCHEDULE DAILY TIP (9:30 AM)
  /// ----------------------------

  static Future<void> scheduleDailyTip() async {
    try {
      if (tipsKeys.isEmpty) return;
      if (!await _isEnabled('dailyTip')) return;

      final tipKey = tipsKeys[Random().nextInt(tipsKeys.length)];

      // Same id each time, so this replaces the previous tip
      await _notificationsPlugin.zonedSchedule(
        dailyTipId,
        "daily_finance_tip".tr,
        tipKey.tr,
        _nextInstanceOf(9, 30),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "daily_tip_channel",
            "Daily Finance Tips",
            importance: Importance.high,
            icon: "notification_icon",
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: await _scheduleMode(),
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "$_dailyTipPayload:$tipKey",
      );
    } catch (e, st) {
      if (kDebugMode) {
        print("scheduleDailyTip error: $e\n$st");
      }
    }
  }

  /// ----------------------------
  ///  SCHEDULE DAILY TRANSACTION REVIEW (10:30 PM)
  /// ----------------------------

  static Future<void> scheduleDailyTransactionReview() async {
    try {
      if (!await _isEnabled('dailyTransactionReview')) return;

      await _notificationsPlugin.zonedSchedule(
        transactionReviewId,
        "review_transactions_title".tr,
        "review_transactions_message".tr,
        _nextInstanceOf(22, 30),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "transaction_review_channel",
            "Daily Transaction Review",
            importance: Importance.high,
            icon: "notification_icon",
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: await _scheduleMode(),
        matchDateTimeComponents: DateTimeComponents.time,
        payload: _transactionReviewPayload,
      );
    } catch (e, st) {
      if (kDebugMode) {
        print("scheduleDailyTransactionReview error: $e\n$st");
      }
    }
  }

  /// ----------------------------
  ///  SCHEDULE WEEKLY SUMMARY (Friday 10:00 AM)
  /// ----------------------------

  static Future<void> scheduleWeeklySummary() async {
    try {
      if (!await _isEnabled('weeklySummary')) return;

      var next = _nextInstanceOf(10, 0);
      while (next.weekday != DateTime.friday) {
        next = tz.TZDateTime.from(
          DateTime(next.year, next.month, next.day + 1, 10, 0),
          tz.local,
        );
      }

      await _notificationsPlugin.zonedSchedule(
        weeklySummaryId,
        "weekly_summary_title".tr,
        "weekly_summary_message".tr,
        next,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "weekly_summary_channel",
            "Weekly Summary",
            importance: Importance.high,
            icon: "notification_icon",
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: await _scheduleMode(),
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: _weeklySummaryPayload,
      );
    } catch (e, st) {
      if (kDebugMode) {
        print("scheduleWeeklySummary error: $e\n$st");
      }
    }
  }

  /// ----------------------------
  ///  RECURRING BILL DUE (9:00 AM on the due day)
  /// ----------------------------

  static Future<void> scheduleRecurringDue(RecurringItem item) async {
    if (item.id == null) return;
    try {
      await cancelRecurringDue(item.id!);
      if (!await _isEnabled('recurringBills')) return;

      final d = item.nextDate;
      final at = DateTime(d.year, d.month, d.day, 9);
      if (!at.isAfter(DateTime.now())) return;

      await _notificationsPlugin.zonedSchedule(
        _recurringBase + item.id!,
        (item.isIncome ? "recurring_income_due_title" : "recurring_due_title")
            .tr,
        "recurring_due_message".trParams({
          'title': item.title,
          'amount': '৳${item.amount}',
        }),
        tz.TZDateTime.from(at, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "recurring_channel",
            "Bills & Recurring",
            importance: Importance.high,
            icon: "notification_icon",
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: await _scheduleMode(),
        payload: _recurringPayload,
      );
    } catch (e, st) {
      if (kDebugMode) {
        print("scheduleRecurringDue error: $e\n$st");
      }
    }
  }

  static Future<void> cancelRecurringDue(int id) async {
    await _notificationsPlugin.cancel(_recurringBase + id);
  }

  static Future<void> tt(title, msg) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('allNotifications') ?? true) {
        await _notificationsPlugin.show(
          transactionWarningId,
          "$title".tr,
          "$msg".tr,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              "reminder_channel",
              "Reminders",
              importance: Importance.high,
              priority: Priority.high,
              icon: "notification_icon",
            ),
          ),
        );
      }

      NotificationDbHelper notificationDbHelper = NotificationDbHelper();
      NotificationModel notificationModel = NotificationModel(
        title: "$title".tr,
        body: "$msg".tr,
        date: DateTime.now(),
      );
      notificationDbHelper.insertNotification(notificationModel);
    } catch (e) {
      if (kDebugMode) print("tt notification error: $e");
    }
  }

  /// Cancels the app's own scheduled notifications (tip, review, budgets).
  /// User-created reminders are kept.
  static Future<void> cancelAppNotifications() async {
    await _notificationsPlugin.cancel(dailyTipId);
    await _notificationsPlugin.cancel(transactionReviewId);
    await _notificationsPlugin.cancel(weeklySummaryId);
    await cancelAllBudgetNotifications();
  }

  // ----------------------------
  //  BUDGET NOTIFICATIONS
  // ----------------------------

  static int _budgetDailyId(int budgetId, int dayOffset) =>
      _budgetDailyBase + budgetId * 8 + dayOffset;

  /// Schedules one notification per day at 12:30 PM for the next
  /// [_budgetDaysAhead] days, never past [endDate]. One-shot notifications
  /// (instead of a repeating one) stop on their own when the budget ends;
  /// they're rescheduled with a fresh limit every time budgets load.
  static Future<void> scheduleDailyBudgetNotification({
    required int budgetId,
    required String budgetName,
    required double dailyLimit,
    required DateTime endDate,
  }) async {
    try {
      await cancelBudgetNotification(budgetId);
      if (!await _isEnabled('budgetNotification')) return;
      if (dailyLimit <= 0) return;

      final mode = await _scheduleMode();
      final now = DateTime.now();

      for (int day = 0; day < _budgetDaysAhead; day++) {
        final scheduled = DateTime(now.year, now.month, now.day + day, 12, 30);
        if (!scheduled.isAfter(now)) continue;
        if (scheduled.isAfter(endDate)) break;

        await _notificationsPlugin.zonedSchedule(
          _budgetDailyId(budgetId, day),
          "daily_budget_limit_title".tr,
          "$budgetName: ${"daily_spend_advice_one".tr}৳${dailyLimit.toStringAsFixed(0)} ${"daily_spend_advice_two".tr}",
          tz.TZDateTime.from(scheduled, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              "budget_channel",
              "Budget Alerts",
              importance: Importance.high,
              priority: Priority.high,
              icon: "notification_icon",
            ),
          ),
          androidScheduleMode: mode,
          payload: _budgetPayload,
        );
      }
    } catch (e) {
      if (kDebugMode) print("Error scheduling budget noti: $e");
    }
  }

  static Future<void> cancelBudgetNotification(int budgetId) async {
    try {
      for (int day = 0; day < _budgetDaysAhead; day++) {
        await _notificationsPlugin.cancel(_budgetDailyId(budgetId, day));
      }
    } catch (e) {
      if (kDebugMode) print("Error canceling budget noti: $e");
    }
  }

  static Future<void> cancelAllBudgetNotifications() async {
    try {
      final pending = await _notificationsPlugin.pendingNotificationRequests();
      for (final p in pending) {
        if (p.id >= _budgetDailyBase && p.id < _budgetAlertBase) {
          await _notificationsPlugin.cancel(p.id);
        }
      }
    } catch (e) {
      if (kDebugMode) print("Error canceling all budget noti: $e");
    }
  }

  static Future<void> _showBudgetAlert({
    required int budgetId,
    required String title,
    required String body,
  }) async {
    try {
      if (await _isEnabled('budgetNotification')) {
        await _notificationsPlugin.show(
          _budgetAlertBase + budgetId,
          title,
          body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              "budget_channel",
              "Budget Alerts",
              importance: Importance.high,
              priority: Priority.high,
              icon: "notification_icon",
            ),
          ),
          payload: _budgetPayload,
        );
      }

      NotificationDbHelper().insertNotification(
        NotificationModel(title: title, body: body, date: DateTime.now()),
      );
    } catch (e) {
      if (kDebugMode) print("Error showing budget alert: $e");
    }
  }

  static Future<void> showBudgetOverspendingNotification(
    int budgetId,
    String budgetName,
  ) {
    return _showBudgetAlert(
      budgetId: budgetId,
      title: "budget_exceeded_title".tr,
      body:
          "${"budget_exceeded_message_start".tr} $budgetName ${"budget_exceeded_message_end".tr}",
    );
  }

  static Future<void> showBudgetExpiryNotification(
    int budgetId,
    String budgetName,
  ) {
    return _showBudgetAlert(
      budgetId: budgetId,
      title: "budget_expired_title".tr,
      body:
          "${"budget_expired_message_start".tr} $budgetName ${"budget_expired_message_end".tr}",
    );
  }
}
