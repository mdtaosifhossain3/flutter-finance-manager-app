import 'package:finance_manager_app/providers/authProvider/auth_provider.dart';

import 'package:finance_manager_app/providers/proProvider/pro_provider.dart';
import 'package:finance_manager_app/services/reminder_helper.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class SplashViewModel {
  static Future<void> initApp(BuildContext context) async {
    // Yield to allow the Splash Screen to render its first frame
    await Future.delayed(Duration(seconds: 1));

    // 1. Initialize Reminders
    try {
      await ReminderHelper.initializeReminderNoti();
    } catch (e) {
      debugPrint('Reminder initialization failed: $e');
    }

    // 5. Initialize Pro Status
    if (context.mounted) {
      final proProvider = Provider.of<ProProvider>(context, listen: false);
      await proProvider.initializeProStatus();
    }

    // 6. Navigate to Main View
    // 6. Check Auth State and Navigate
    if (context.mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.checkAuthState();
    }
  }
}
