import 'dart:core';

import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/reminderProvider/reminder_provider.dart';
import 'package:finance_manager_app/services/reminder_helper.dart';
import 'package:finance_manager_app/views/reminderView/add_reminder_form.dart';
import 'package:finance_manager_app/views/reminderView/reminder_card_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReminderView extends StatefulWidget {
  const ReminderView({super.key});

  @override
  State<ReminderView> createState() => _ReminderViewState();
}

class _ReminderViewState extends State<ReminderView> {
  @override
  void initState() {
    super.initState();

    // Initialize reminder provider on first open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReminderProvider>().initialize();
      ReminderHelper.requestNotificationPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: "reminder".tr,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 28),
            onPressed: () {
              Get.to(() => const AddReminderForm());
            },
            tooltip: 'Add Reminder',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<ReminderProvider>(
        builder: (context, reminderProvider, _) {
          // Show loading state (always prioritize loading)
          if (reminderProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show empty state only after loading is complete
          if (reminderProvider.reminders.isEmpty) {
            return _buildEmptyState(context);
          }

          // Show error if any
          if (reminderProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  Text(reminderProvider.errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => reminderProvider.loadReminders(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Show reminders list
          return RefreshIndicator(
            onRefresh: () => reminderProvider.loadReminders(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reminderProvider.reminders.length,
              itemBuilder: (context, idx) {
                final reminder = reminderProvider.reminders[idx];

                final isActive = reminder['isActive'] == 1;

                return Dismissible(
                  key: Key(reminder['id'].toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.red[400],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    child: Icon(
                      Icons.delete_outline,
                      color: AppColors.textPrimary,
                      size: 28,
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    return await _showDeleteConfirmation(context);
                  },
                  onDismissed: (direction) {
                    reminderProvider.deleteReminder(reminder["id"]);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("delete_success".tr),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Theme.of(context).dividerColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => ReminderPreviewScreen(reminder: reminder));
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),

                        title: Text(
                          reminder['title'],
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? Theme.of(context).colorScheme.onPrimary
                                : Colors.grey[400],
                            decoration: isActive
                                ? null
                                : TextDecoration.lineThrough,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              // Category Tag
                              // Container(
                              //   padding: const EdgeInsets.symmetric(
                              //     horizontal: 8,
                              //     vertical: 4,
                              //   ),
                              //   decoration: BoxDecoration(
                              //     color: categoryColor.withOpacity(0.1),
                              //     borderRadius: BorderRadius.circular(6),
                              //   ),
                              //   child: Row(
                              //     mainAxisSize: MainAxisSize.min,
                              //     children: [
                              //       Icon(
                              //         Icons.category_outlined,
                              //         size: 12,
                              //         color: categoryColor,
                              //       ),
                              //       const SizedBox(width: 4),
                              //       Text(
                              //         reminder['category'],
                              //         style: TextStyle(
                              //           fontSize: 12,
                              //           color: categoryColor,
                              //           fontWeight: FontWeight.w500,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // Date Tag
                              if (reminder['remindersTime'] != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 12,
                                        color: Colors.blue[700],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _formatDate(reminder['remindersTime']),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.blue[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              // Time Tag
                              if (reminder['remindersTime'] != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 12,
                                        color: Colors.orange[700],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _formatTime(reminder['remindersTime']),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.orange[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              // Repeat Tag
                              if (reminder['isRepeating'] == 1)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.repeat,
                                        size: 12,
                                        color: Colors.purple[700],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Daily',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.purple[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        trailing: Transform.scale(
                          scale: 0.9,
                          child: Switch(
                            value: isActive,
                            activeThumbColor: AppColors.primaryBlue,
                            onChanged: (value) {
                              reminderProvider.toggleReminder(
                                reminder['id'],
                                value,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 44,
              color: Colors.blue[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "no_reminders_yet".tr,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            "create_first_reminder".tr,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Get.to(() => const AddReminderForm());
            },
            icon: const Icon(Icons.add_rounded),
            label: Text("add_reminder".tr),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("delete_reminder".tr),
          content: Text("confirmation_message".tr),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("cancel".tr),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("delete".tr),
            ),
          ],
        );
      },
    );
  }
}

// Add these helper methods to your widget class
String _formatDate(String dateTimeStr) {
  try {
    final dateTime = DateTime.parse(dateTimeStr);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final reminderDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final isBangla = Get.locale?.languageCode == 'bn';

    if (reminderDate == today) {
      return isBangla ? 'আজ' : 'Today';
    } else if (reminderDate == yesterday) {
      return isBangla ? 'গতকাল' : 'Yesterday';
    } else {
      if (isBangla) {
        String formatted = DateFormat('MMM dd, yyyy').format(dateTime);

        const monthMap = {
          'Jan': 'জানুয়ারি',
          'Feb': 'ফেব্রুয়ারি',
          'Mar': 'মার্চ',
          'Apr': 'এপ্রিল',
          'May': 'মে',
          'Jun': 'জুন',
          'Jul': 'জুলাই',
          'Aug': 'আগস্ট',
          'Sep': 'সেপ্টেম্বর',
          'Oct': 'অক্টোবর',
          'Nov': 'নভেম্বর',
          'Dec': 'ডিসেম্বর',
        };

        monthMap.forEach((en, bn) {
          formatted = formatted.replaceAll(en, bn);
        });

        // Step 3: English → Bangla digits
        const enDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
        const bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

        for (int i = 0; i < enDigits.length; i++) {
          formatted = formatted.replaceAll(enDigits[i], bnDigits[i]);
        }

        return formatted;
      } else {
        // Default English format
        return DateFormat('MMMM dd, y', 'en').format(dateTime);
      }
    }
  } catch (e) {
    return DateFormat('MMM dd, yyyy').format(DateTime.parse(dateTimeStr));
  }
}

String _formatTime(String dateTimeStr) {
  try {
    final isBangla = Get.locale?.languageCode == 'bn';
    final dateTime = DateTime.parse(dateTimeStr);

    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    final formatted = '${hour == 0 ? 12 : hour}:$minute $period';

    if (isBangla) {
      // Convert English digits to Bangla digits
      const enDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      const bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

      String banglaTime = formatted;
      for (int i = 0; i < 10; i++) {
        banglaTime = banglaTime.replaceAll(enDigits[i], bnDigits[i]);
      }

      return banglaTime;
    }

    return formatted;
  } catch (e) {
    return DateFormat('MMM dd, yyyy').format(DateTime.parse(dateTimeStr));
  }
}
