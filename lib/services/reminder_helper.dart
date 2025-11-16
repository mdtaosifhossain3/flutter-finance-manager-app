import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/views/reminderView/reminder_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReminderHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initializeReminderNoti() async {
    tz.initializeTimeZones();

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
      playSound: true,
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

  static Future<void> tt() async {
    try {
      await _notificationsPlugin.show(
        999,
        "Test Notification",
        "If you see this, releasing is working",
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "reminder_channel",
            "Reminders",
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    } catch (e) {
      Get.snackbar("", e.toString());
    }
  }

  static Future<void> chanceledRemidnerNoti(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}
