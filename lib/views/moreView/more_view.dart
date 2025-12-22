import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/views/noteView/notes_view.dart';
import 'package:finance_manager_app/views/reminderView/reminder_view.dart';
import 'package:finance_manager_app/views/savingsView/savings_view.dart';
import 'package:finance_manager_app/views/settingView/setting_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "miscellaneous_expense".tr),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Wrap(
          direction: Axis.horizontal,
          spacing: 24,
          runSpacing: 24,
          children: [
            InkWell(
              onTap: () {
                Get.to(SettingsPage());
              },
              child: Column(
                children: [
                  Icon(Icons.settings, size: 28),
                  SizedBox(height: 8),
                  Text('settings'.tr),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(ReminderView());
              },
              child: Column(
                children: [
                  Icon(Icons.schedule, size: 28),
                  SizedBox(height: 8),
                  Text('reminder'.tr),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(SavingsView());
              },
              child: Column(
                children: [
                  Icon(Icons.savings, size: 28),
                  SizedBox(height: 8),
                  Text('savings'.tr),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(NotesView());
              },
              child: Column(
                children: [
                  Icon(Icons.note, size: 28),
                  SizedBox(height: 8),
                  Text('note'.tr),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
