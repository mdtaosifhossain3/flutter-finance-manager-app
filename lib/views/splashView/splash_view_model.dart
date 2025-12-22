import 'package:finance_manager_app/providers/authProvider/auth_provider.dart';
import 'package:finance_manager_app/providers/proProvider/pro_provider.dart';
import 'package:finance_manager_app/services/reminder_helper.dart';
import 'package:finance_manager_app/services/uid_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

class SplashViewModel {
  static Future<void> initApp(BuildContext context) async {
    // Run everything in parallel
    await Future.wait([_initFirebase(), _initUid(), _initReminder()]);

    if (!context.mounted) return;
    await context.read<ProProvider>().initializeProStatus();
    if (!context.mounted) return;

    // Auth check LAST
    await context.read<AuthProvider>().checkAuthState();
  }

  static Future<void> _initFirebase() async {
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
}
