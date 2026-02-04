import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/authProvider/auth_provider.dart';
import 'package:finance_manager_app/config/db/local/notification_db/notification_db_helper.dart';
import 'package:finance_manager_app/providers/budget/budget_provider.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/providers/givenTakenProvider/given_taken_provider.dart';
import 'package:finance_manager_app/providers/notesProvider/notes_provider.dart';
import 'package:finance_manager_app/providers/reminderProvider/reminder_provider.dart';
import 'package:finance_manager_app/providers/savingsProvider/savings_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ResetDeleteView extends StatelessWidget {
  const ResetDeleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'reset_delete_options'.tr,
        leading: IconButton(
          onPressed: () => Get.back(),
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
                'reset_delete_description'.tr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 30),
              _buildOptionCard(
                context,
                title: 'reset_app_data'.tr,
                description: 'reset_app_data_desc'.tr,
                icon: Icons.restore,
                color: Colors.orange,
                onTap: () => _showResetConfirmationDialog(context),
              ),
              const SizedBox(height: 20),
              _buildOptionCard(
                context,
                title: 'delete_account'.tr,
                description: 'delete_account_desc'.tr,
                icon: Icons.delete_forever,
                color: AppColors.error,
                onTap: () => _showDeleteAccountConfirmationDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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
                    color: color.withValues(alpha: 0.1),
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
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
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

  void _showResetConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'reset_app_data'.tr,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        content: Text(
          'reset_app_data_confirmation'.tr,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'cancel'.tr,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);

              // Show loading
              Get.dialog(
                const Center(child: CircularProgressIndicator()),
                barrierDismissible: false,
              );

              try {
                // Delete Local Data
                await context
                    .read<AddExpenseProvider>()
                    .deleteFullTransaction();
                if (!context.mounted) return;
                await context.read<BudgetProvider>().deleteFullBudget();
                if (!context.mounted) return;
                await context.read<SavingsProvider>().deleteFullSavings();
                if (!context.mounted) return;
                await context.read<GivenTakenProvider>().deleteFullData();
                if (!context.mounted) return;
                await context.read<NotesProvider>().clearAllNotes();
                if (!context.mounted) return;
                await context.read<ReminderProvider>().deleteFullReminders();
                if (!context.mounted) return;
                await NotificationDbHelper().deleteFull();
                Get.back(); // Close loading

                Get.snackbar(
                  'successTitle'.tr,
                  'app_data_reset_success'.tr,
                  backgroundColor: AppColors.success,
                  colorText: Colors.white,
                );
              } catch (e) {
                Get.back(); // Close loading
                Get.snackbar(
                  'error_title'.tr,
                  e.toString(),
                  backgroundColor: AppColors.error,
                  colorText: Colors.white,
                );
              }
            },
            child: Text(
              'reset'.tr,
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'delete_account'.tr,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.error,
          ),
        ),
        content: Text(
          'delete_account_confirmation'.tr,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'cancel'.tr,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);

              // 1. Delete Local Data first
              await context.read<AddExpenseProvider>().deleteFullTransaction();
              if (!context.mounted) return;
              await context.read<BudgetProvider>().deleteFullBudget();
              if (!context.mounted) return;
              await context.read<SavingsProvider>().deleteFullSavings();
              if (!context.mounted) return;
              await context.read<GivenTakenProvider>().deleteFullData();
              if (!context.mounted) return;
              await context.read<NotesProvider>().clearAllNotes();
              if (!context.mounted) return;
              await context.read<ReminderProvider>().deleteFullReminders();
              if (!context.mounted) return;
              await NotificationDbHelper().deleteFull();

              // 2. Delete Cloud Data & Account
              if (context.mounted) {
                await context.read<AuthProvider>().deleteAccount();
              }
            },
            child: Text(
              'delete'.tr,
              style: const TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
