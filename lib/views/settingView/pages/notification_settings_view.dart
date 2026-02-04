import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class NotificationSettingsView extends StatelessWidget {
  const NotificationSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: "notification_settings".tr,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSwitchTile(
                context,
                title: "all_notifications".tr,
                subtitle: "all_notifications_desc".tr,
                value: provider.allNotifications,
                onChanged: (value) => provider.toggleAllNotifications(value),
                icon: Icons.notifications_active,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(height: 24),
              Text(
                "notification_types".tr,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              _buildSwitchTile(
                context,
                title: "daily_finance_tip".tr,
                subtitle: "daily_finance_tip_desc".tr,
                value: provider.dailyTip,
                onChanged: provider.allNotifications
                    ? (value) => provider.toggleDailyTip(value)
                    : null,
                icon: Icons.lightbulb,
                color: Colors.amber,
              ),
              const SizedBox(height: 12),
              _buildSwitchTile(
                context,
                title: "daily_transaction_review".tr,
                subtitle: "daily_transaction_review_desc".tr,
                value: provider.dailyTransactionReview,
                onChanged: provider.allNotifications
                    ? (value) => provider.toggleDailyTransactionReview(value)
                    : null,
                icon: Icons.receipt_long,
                color: Colors.purple,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool)? onChanged,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primaryBlue,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        secondary: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: onChanged == null
                ? Colors.grey.withValues(alpha: 0.1)
                : color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: onChanged == null ? Colors.grey : color,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: onChanged == null ? AppColors.textSecondary : null,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
