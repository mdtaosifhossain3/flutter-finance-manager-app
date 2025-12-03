import 'dart:math';

import 'package:finance_manager_app/config/db/local/notification_db/notification_db_helper.dart';
import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/data/tipsData/tips_data.dart';
import 'package:finance_manager_app/models/notificationModel/notification_model.dart';
import 'package:finance_manager_app/views/reminderView/reminder_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReminderHelper {
  static late final tz.Location _bdLocation;

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initializeReminderNoti() async {
    tz.initializeTimeZones();
    try {
      _bdLocation = tz.getLocation('Asia/Dhaka');
      tz.setLocalLocation(_bdLocation); // set local location to Dhaka
    } catch (e) {
      // fallback to system local if getLocation fails
      tz.setLocalLocation(tz.local);
    }
    const adSettings = AndroidInitializationSettings("notification_icon");
    const initSettings = InitializationSettings(android: adSettings);
    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: notificationTapBackground,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      "reminder_channel",
      "Reminders",
      description: "Channel for Reminder Notification",
      importance: Importance.high,
      playSound: true,
    );

    _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const AndroidNotificationChannel dailyTipChannel =
        AndroidNotificationChannel(
          "daily_tip_channel",
          "Daily Finance Tips",
          description: "Channel for Daily Finance Tip",
          importance: Importance.high,
          playSound: true,
        );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(dailyTipChannel);

    const AndroidNotificationChannel transactionReviewChannel =
        AndroidNotificationChannel(
          "transaction_review_channel",
          "Daily Transaction Review",
          description: "Channel for Daily Transaction Review Reminders",
          importance: Importance.high,
          playSound: true,
        );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(transactionReviewChannel);

    const AndroidNotificationChannel budgetChannel = AndroidNotificationChannel(
      "budget_channel",
      "Budget Alerts",
      description: "Channel for Budget Limit Notifications",
      importance: Importance.high,
      playSound: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(budgetChannel);

    // Request exact alarms permission if you want to ensure alarmClock mode works
    await requestExactAlarmPermission();
  }

  static Future<void> requestExactAlarmPermission() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission();
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse response) {
    if (response.payload == 'reminder_page') {
      Get.to(() => ReminderView());
    } else if (response.payload == 'daily_tip') {
      // Insert daily tip into database when user taps it
      final notiHelper = NotificationDbHelper();
      final noti = NotificationModel(
        title: "daily_finance_tip".tr,
        body:
            "Daily finance tip received", // Generic message since we can't retrieve the exact tip
        date: DateTime.now(),
      );
      notiHelper.insertNotification(noti);
    } else if (response.payload == 'transaction_review') {
      // Insert transaction review notification into database when user taps it
      final notiHelper = NotificationDbHelper();
      final noti = NotificationModel(
        title: "review_transactions_title".tr,
        body: "review_transactions_message".tr,
        date: DateTime.now(),
      );
      notiHelper.insertNotification(noti);
    }
  }

  static Future<bool> _checkAndRequestExactAlarmPermission() async {
    // Permission.scheduleExactAlarm is the direct equivalent of SCHEDULE_EXACT_ALARM
    final status = await Permission.scheduleExactAlarm.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      // Show Snackbar to request permission, similar to your original intent
      Get.snackbar(
        "permission_required".tr,
        "grant_permission_message".tr,
        titleText: const SizedBox.shrink(),
        messageText: Row(
          children: [
            const Icon(Icons.access_time, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'connection_timeout'.tr,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryBlue,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
        mainButton: TextButton(
          onPressed: () async {
            // Open the app settings page. The user needs to manually grant it here.
            await openAppSettings();
            Get.back();
          },
          child: const Text(
            'Go to Settings',
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ),
      );
      return false;
    }
    // Handle status.isRestricted, status.isPermanentlyDenied, etc.
    // For simplicity, we open settings for all non-granted statuses
    await openAppSettings();
    return false;
  }

  // The scheduleNoti method is simplified to call the helper
  static Future<void> scheduleNoti(
    int id,
    String title,
    String body,
    DateTime time,
  ) async {
    if (time.isBefore(DateTime.now())) {
      return;
    }

    // --- 🚨 Alternative Exact Alarm Permission Check ---
    final bool canSchedule = await _checkAndRequestExactAlarmPermission();

    if (!canSchedule) {
      // Stop scheduling if permission is denied and the user didn't grant it
      return;
    }
    // --- ✅ End Permission Check ---

    // ... rest of your NotificationDetails setup ...
    final adDetails = AndroidNotificationDetails(
      "reminder_channel",
      "Reminders",
      importance: Importance.high,
      priority: Priority.high,
      icon: 'notification_icon',
    );

    final notiDetails = NotificationDetails(android: adDetails);

    // Proceed with scheduling only if permission is granted
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(time, tz.local),
      notiDetails,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      payload: "reminder_page",
    );
  }

  /// ----------------------------
  ///  SCHEDULE DAILY TIP (9:30 AM BDT)
  /// ----------------------------

  static Future<void> scheduleDailyTip() async {
    try {
      // 1. Pick random tip (ensure tipsKeys is non-empty)
      if (tipsKeys.isEmpty) {
        return;
      }
      final random = Random();
      final tipKey = tipsKeys[random.nextInt(tipsKeys.length)];

      // 2. Permission check for exact alarms / scheduling
      final bool allowed = await _checkAndRequestExactAlarmPermission();
      if (!allowed) {
        return;
      }

      // 3. Build next 9:30am in Asia/Dhaka
      final now = tz.TZDateTime.now(_bdLocation);
      tz.TZDateTime scheduled = tz.TZDateTime(
        _bdLocation,
        now.year,
        now.month,
        now.day,
        9, // 9 AM
        30, // 30 minutes
      );

      // if we've already passed today's 9:30, schedule for tomorrow
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      // 4. Schedule repeating daily notification (match time)
      await _notificationsPlugin.zonedSchedule(
        999, // fixed id for daily tip
        "daily_finance_tip".tr,
        tipKey.tr,
        scheduled,
        NotificationDetails(
          android: AndroidNotificationDetails(
            "daily_tip_channel",
            "Daily Finance Tips",
            importance: Importance.high,
            icon: "notification_icon",
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "daily_tip",
      );
    } catch (e, st) {
      if (kDebugMode) {
        print("scheduleDailyTip error: $e\n$st");
      }
    }
  }

  /// ----------------------------
  ///  SCHEDULE DAILY TRANSACTION REVIEW (9:00 PM BDT)
  /// ----------------------------

  static Future<void> scheduleDailyTransactionReview() async {
    try {
      // 1. Permission check for exact alarms / scheduling
      //  final bool allowed = await _checkAndRequestExactAlarmPermission();
      // if (!allowed) {
      //   return;
      // }

      // 2. Build next 9:00 PM in Asia/Dhaka
      final now = tz.TZDateTime.now(_bdLocation);
      tz.TZDateTime scheduled = tz.TZDateTime(
        _bdLocation,
        now.year,
        now.month,
        now.day,
        22, // 10 PM
        30, // 30 minutes
      );

      // if we've already passed today's 9:00 PM, schedule for tomorrow
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      // 3. Schedule repeating daily notification (match time)
      await _notificationsPlugin.zonedSchedule(
        777, // fixed id for daily transaction review
        "review_transactions_title".tr,
        "review_transactions_message".tr,
        scheduled,
        NotificationDetails(
          android: AndroidNotificationDetails(
            "transaction_review_channel",
            "Daily Transaction Review",
            importance: Importance.high,
            icon: "notification_icon",
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "transaction_review",
      );
    } catch (e, st) {
      if (kDebugMode) {
        print("scheduleDailyTransactionReview error: $e\n$st");
      }
    }
  }

  static Future<void> tt(title, msg) async {
    try {
      await _notificationsPlugin.show(
        999,
        "$title".tr,
        "$msg".tr,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "reminder_channel",
            "Reminders",
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );

      NotificationDbHelper notificationDbHelper = NotificationDbHelper();
      NotificationModel notificationModel = NotificationModel(
        title: "$title".tr,
        body: "$msg".tr,
        date: DateTime.now(),
      );
      notificationDbHelper.insertNotification(notificationModel);
    } catch (e) {
      Get.snackbar("", e.toString());
    }
  }

  static Future<void> chanceledRemidnerNoti(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // ----------------------------
  //  BUDGET NOTIFICATIONS
  // ----------------------------

  static Future<void> scheduleDailyBudgetNotification({
    required int budgetId,
    required String budgetName,
    required double dailyLimit,
  }) async {
    print(
      "DEBUG: ReminderHelper.scheduleDailyBudgetNotification called for $budgetName",
    );
    try {
      // 1. Permission check
      final bool allowed = await _checkAndRequestExactAlarmPermission();
      if (!allowed) {
        print("DEBUG: Permission denied for exact alarms");
        return;
      }

      // 2. Build next 9:00 AM
      final now = tz.TZDateTime.now(_bdLocation);
      tz.TZDateTime scheduled = tz.TZDateTime(
        _bdLocation,
        now.year,
        now.month,
        now.day,
        12, // 12 PM
        30,
      );

      print("DEBUG: Scheduled time before check: $scheduled, Now: $now");

      if (scheduled.isBefore(now)) {
        print("DEBUG: Scheduled time is in the past, adding 1 day");
        scheduled = scheduled.add(const Duration(days: 1));
      }

      print("DEBUG: Final scheduled time: $scheduled");

      // 3. Schedule with unique ID based on budgetId
      // We use a base ID (e.g., 888000) + budgetId to ensure uniqueness
      final int notificationId = 888000 + budgetId;

      await _notificationsPlugin.zonedSchedule(
        notificationId,
        "daily_budget_limit_title".tr,
        "$budgetName: ${"daily_spend_advice_one".tr}৳${dailyLimit.toStringAsFixed(0)} ${"daily_spend_advice_two".tr}",
        scheduled,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "budget_channel",
            "Budget Alerts",
            importance: Importance.high,
            priority: Priority.high,
            icon: "notification_icon",
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "budget_view",
      );
      print(
        "DEBUG: Notification successfully scheduled with ID $notificationId",
      );
    } catch (e) {
      if (kDebugMode) print("Error scheduling budget noti: $e");
    }
  }

  static Future<void> cancelBudgetNotification(int budgetId) async {
    try {
      final int notificationId = 888000 + budgetId;
      await _notificationsPlugin.cancel(notificationId);
    } catch (e) {
      if (kDebugMode) print("Error canceling budget noti: $e");
    }
  }

  static Future<void> showBudgetOverspendingNotification(
    String budgetName,
  ) async {
    try {
      await _notificationsPlugin.show(
        Random().nextInt(100000),
        "budget_exceeded_title".tr,
        "${"budget_exceeded_message_start".tr} $budgetName ${"budget_exceeded_message_end".tr}",
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "budget_channel",
            "Budget Alerts",
            importance: Importance.high,
            priority: Priority.high,
            icon: "notification_icon",
          ),
        ),
      );

      NotificationDbHelper notificationDbHelper = NotificationDbHelper();
      NotificationModel notificationModel = NotificationModel(
        title: "budget_exceeded_title".tr,
        body:
            "${"budget_exceeded_message_start".tr} $budgetName ${"budget_exceeded_message_end".tr}",
        date: DateTime.now(),
      );
      notificationDbHelper.insertNotification(notificationModel);
    } catch (e) {
      if (kDebugMode) print("Error showing overspending noti: $e");
    }
  }

  static Future<void> showBudgetExpiryNotification(String budgetName) async {
    try {
      await _notificationsPlugin.show(
        Random().nextInt(100000),
        "budget_expired_title".tr,
        "${"budget_expired_message_start".tr} $budgetName ${"budget_expired_message_end".tr}",
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "budget_channel",
            "Budget Alerts",
            importance: Importance.high,
            priority: Priority.high,
            icon: "notification_icon",
          ),
        ),
      );

      NotificationDbHelper notificationDbHelper = NotificationDbHelper();
      NotificationModel notificationModel = NotificationModel(
        title: "budget_expired_title".tr,
        body:
            "${"budget_expired_message_start".tr} $budgetName ${"budget_expired_message_end".tr}",
        date: DateTime.now(),
      );
      notificationDbHelper.insertNotification(notificationModel);
    } catch (e) {
      if (kDebugMode) print("Error showing expiry noti: $e");
    }
  }
}
