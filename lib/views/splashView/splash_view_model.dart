import 'package:finance_manager_app/config/routes/routes_name.dart';
import 'package:finance_manager_app/providers/budget/budget_provider.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/providers/speechProvider/speech_provider.dart';
import 'package:finance_manager_app/services/reminder_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SplashViewModel {
  static Future<void> initApp(BuildContext context) async {
    // Yield to allow the Splash Screen to render its first frame
    await Future.delayed(Duration(milliseconds: 300));

    // 1. Initialize Reminders
    try {
      await ReminderHelper.initializeReminderNoti();
    } catch (e) {
      debugPrint('Reminder initialization failed: $e');
    }

    // 2. Load Transactions
    if (context.mounted) {
      final txProvider = Provider.of<AddExpenseProvider>(
        context,
        listen: false,
      );
      await txProvider.getTransactionsForMonth(DateTime.now());
    }

    // 3. Load Budgets
    if (context.mounted) {
      final budgetProvider = Provider.of<BudgetProvider>(
        context,
        listen: false,
      );
      await budgetProvider.loadBudgets();
    }

    // 4. Initialize Speech
    if (context.mounted) {
      final speechProvider = Provider.of<SpeechProvider>(
        context,
        listen: false,
      );
      await speechProvider.initializeSpeech();
    }

    // 5. Navigate to Main View
    Get.offAllNamed(RoutesName.mainView);
  }
}
