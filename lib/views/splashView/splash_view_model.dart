import 'package:finance_manager_app/services/reminder_helper.dart';

import 'package:finance_manager_app/services/uid_service.dart';
import 'package:finance_manager_app/views/authView/phnVerificationView/phone_verification_view.dart';
import 'package:finance_manager_app/views/mainView/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashViewModel {
  static Future<void> initApp(BuildContext context) async {
    // Run everything in parallel
    await Future.wait([_initEnv(), _initUid(), _initReminder()]);
    _checkAuthAndNavigate();
  }

  static Future<void> _initEnv() async {
    await dotenv.load(fileName: '.env');
  }

  static Future<void> _initUid() async {
    await UidService.instance.initialize();
  }

  static Future<void> _initReminder() async {
    try {
      await ReminderHelper.initializeReminderNoti();
    } catch (_) {}
  }

  static Future<void> _checkAuthAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSubscribed = prefs.getBool("IS_SUBSCRIBED") ?? false;

    if (isSubscribed) {
      Get.offAll(() => const MainView());
    } else {
      Get.offAll(() => const PhoneVerificationView());
    }
  }
}
