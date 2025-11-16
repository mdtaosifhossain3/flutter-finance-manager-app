import 'package:finance_manager_app/models/notificationModel/notification_model.dart';
import 'package:finance_manager_app/services/weekly_pdf_summary_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/db/local/notification_db/notification_db_helper.dart';

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
          ? Center(child: Text("noNotifications".tr))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final n = notifications[index];
                return ListTile(
                  onTap: () async {
                    n.isWeekly
                        ? await WeeklyPdfGenerator.generateWeeklyReportPdf(
                            DateTime.now(),
                            context,
                          )
                        : null;
                  },
                  leading: Icon(
                    n.isWeekly ? Icons.schedule : Icons.notifications,
                    color: n.isWeekly ? Colors.orange : Colors.blue,
                  ),
                  title: Text(n.title),
                  subtitle: Text(n.body),
                  trailing: Text(
                    "${n.date.hour}:${n.date.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                );
              },
            ),
    );
  }
}
