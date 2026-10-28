import 'package:finance_manager_app/config/db/local/notification_db/notification_db_helper.dart';
import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/budget/budget_provider.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/providers/givenTakenProvider/given_taken_provider.dart';
import 'package:finance_manager_app/providers/notesProvider/notes_provider.dart';
import 'package:finance_manager_app/providers/reminderProvider/reminder_provider.dart';
import 'package:finance_manager_app/providers/savingsProvider/savings_provider.dart';
import 'package:finance_manager_app/services/uid_service.dart';
import 'package:finance_manager_app/views/authView/phnVerificationView/phone_verification_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class UnsubscirbeView extends StatelessWidget {
  const UnsubscirbeView({super.key});

  // plan options for dialog
  static const _dailyPassword = "a2e48f4c4513432d2ba1219fc68b9074";
  // static const _monthlyPassword = "8e720471e31d322a083d29497b9237a7";
  // plan options for dialog
  static const _dailyAppID = "APP_140124";
  // static const _monthlyAppID = "APP_134793";

  Future<void> unsubscribe(
    BuildContext context,
    String aplicatonID,
    String password,
    String? subscriberId,
  ) async {
    // Capture providers before async gap to avoid context issues
    final addExpenseProvider = context.read<AddExpenseProvider>();
    final budgetProvider = context.read<BudgetProvider>();
    final savingsProvider = context.read<SavingsProvider>();
    final givenTakenProvider = context.read<GivenTakenProvider>();
    final notesProvider = context.read<NotesProvider>();
    final reminderProvider = context.read<ReminderProvider>();

    String phone = (subscriberId ?? '').trim();
    if (phone.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      phone =
          prefs.getString("MOBILE_NUMBER") ??
          prefs.getString("USER_PHONE") ??
          prefs.getString("user_uid") ??
          UidService.instance.uid ??
          '';
    }

    if (phone.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'Mobile number not found. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Clean phone number format
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.startsWith('880')) {
      cleanPhone = cleanPhone.substring(2);
    } else if (cleanPhone.startsWith('88')) {
      cleanPhone = cleanPhone.substring(2);
    }

    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final res = await http
          .post(
            Uri.parse('https://fluttbizitsolutions.com/api/unsubcribe.php'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "applicationId": aplicatonID,
              "password": password,
              "version": "1.0",
              "action": 0,
              // subscriberId may be passed as a direct tel:8801... string
              "subscriberId": "tel:88$cleanPhone",
            }),
          )
          .timeout(const Duration(seconds: 15));

      // Close loading
      if (context.mounted) Navigator.of(context).pop();

      final body = jsonDecode(res.body);
      final statusCode = body["statusCode"];

      print("Response Body: $body");
      if (statusCode == "E1356" || statusCode == "E1325") {
        Get.snackbar(
          'error'.tr,
          'not_subscribed_error'.tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      // Delete Local Data safely
      try {
        await addExpenseProvider.deleteFullTransaction();
      } catch (e) {
        debugPrint('Error deleting transaction data: $e');
      }
      try {
        await budgetProvider.deleteFullBudget();
      } catch (e) {
        debugPrint('Error deleting budget data: $e');
      }
      try {
        await savingsProvider.deleteFullSavings();
      } catch (e) {
        debugPrint('Error deleting savings data: $e');
      }
      try {
        await givenTakenProvider.deleteFullData();
      } catch (e) {
        debugPrint('Error deleting given/taken data: $e');
      }
      try {
        await notesProvider.clearAllNotes();
      } catch (e) {
        debugPrint('Error clearing notes data: $e');
      }
      try {
        await reminderProvider.deleteFullReminders();
      } catch (e) {
        debugPrint('Error deleting reminders: $e');
      }
      try {
        await NotificationDbHelper().deleteFull();
      } catch (e) {
        debugPrint('Error deleting notifications: $e');
      }

      await UidService.instance.clearUid();
      sharedPreferences.setBool("IS_SUBSCRIBED", false);
      sharedPreferences.clear();

      Get.offAll(() => const PhoneVerificationView());
      Get.snackbar(
        'success'.tr,
        'unsubscribe_success'.tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } on SocketException {
      if (context.mounted) Navigator.of(context).pop();
      Get.snackbar(
        'error'.tr,
        'Network Issue: Check your internet connection',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } on TimeoutException {
      if (context.mounted) Navigator.of(context).pop();
      Get.snackbar(
        'error'.tr,
        'Connection timed out. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();
      Get.snackbar(
        'error'.tr,
        'Error: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'unsubscribe'.tr,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'choose_plan'.tr, // Using existing key or generic title
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 30),
              _buildOptionCard(
                context,
                title: 'daily_plan'.tr,
                icon: Icons.calendar_today,
                color: Colors.blue,
                onTap: () => _showUnsubscribeDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUnsubscribeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.unsubscribe,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    'unsubscribe'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'cancel'.tr,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () async {
                            final sharedPreferences =
                                await SharedPreferences.getInstance();
                            final phone =
                                sharedPreferences.getString("MOBILE_NUMBER") ??
                                sharedPreferences.getString("USER_PHONE") ??
                                sharedPreferences.getString("user_uid") ??
                                UidService.instance.uid;

                            if (dialogContext.mounted) {
                              Navigator.pop(dialogContext);
                            }

                            if (context.mounted) {
                              unsubscribe(
                                context,
                                _dailyAppID,
                                _dailyPassword,
                                phone,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'yes'.tr,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool selected = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: selected
            ? color.withValues(alpha: 0.06)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? color : color.withValues(alpha: 0.3),
          width: selected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: selected
                        ? color.withValues(alpha: 0.16)
                        : color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
