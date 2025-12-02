import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/models/notificationModel/notification_model.dart';
import 'package:finance_manager_app/services/weekly_pdf_summary_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/db/local/notification_db/notification_db_helper.dart';

import 'package:finance_manager_app/utils/helper_functions.dart';

class NotificationCenterPage extends StatefulWidget {
  const NotificationCenterPage({super.key});

  @override
  State<NotificationCenterPage> createState() => _NotificationCenterPageState();
}

class _NotificationCenterPageState extends State<NotificationCenterPage> {
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final data = await NotificationDbHelper().getAllNotifications();
    setState(() => notifications = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("notifications".tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded),
            onPressed: () async {
              await NotificationDbHelper().clearAll();
              loadNotifications();
            },
          ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 64,
                    color: AppColors.textMuted.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "noNotifications".tr,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final n = notifications[index];
                final isWeekly = n.isWeekly;
                final isTip = n.title == "daily_finance_tip".tr;

                Color iconColor;
                Color iconBgColor;
                IconData iconData;

                if (isWeekly) {
                  iconColor = AppColors.warning;
                  iconBgColor = AppColors.warning.withValues(alpha: 0.1);
                  iconData = Icons.schedule_rounded;
                } else if (isTip) {
                  iconColor = AppColors.primaryPurple;
                  iconBgColor = AppColors.primaryPurple.withValues(alpha: 0.1);
                  iconData = Icons.lightbulb_rounded;
                } else {
                  iconColor = AppColors.primaryBlue;
                  iconBgColor = AppColors.primaryBlue.withValues(alpha: 0.1);
                  iconData = Icons.notifications_rounded;
                }

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      if (n.isWeekly) {
                        await WeeklyPdfGenerator.generateWeeklyReportPdf(
                          DateTime.now(),
                          context,
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).dividerColor.withValues(alpha: 0.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: iconBgColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(iconData, color: iconColor, size: 24),
                          ),
                          const SizedBox(width: 16),

                          // Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        n.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelLarge,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      HelperFunctions.getFormattedDate(n.date),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  n.body,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                            ?.withValues(alpha: 0.8),
                                        height: 1.4,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
