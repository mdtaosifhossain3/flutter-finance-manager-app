import 'package:finance_manager_app/config/routes/routes_name.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "miscellaneous_expense".tr),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04,
          vertical: 24,
        ),
        child: Wrap(
          direction: Axis.horizontal,
          spacing: 24,
          runSpacing: 24,
          children: [
            InkWell(
              onTap: () {
                Get.toNamed(RoutesName.givenTakenView);
              },
              child: Column(
                children: [
                  Icon(Icons.handshake_outlined, size: 28),
                  SizedBox(height: 8),
                  Text('given_taken'.tr),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed(RoutesName.budgetView);
              },
              child: Column(
                children: [
                  Icon(Icons.wallet_outlined, size: 28),
                  SizedBox(height: 8),
                  Text('budget'.tr),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed(RoutesName.reminderView);
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
                Get.toNamed(RoutesName.savingsView);
              },
              child: Column(
                children: [
                  Icon(Icons.savings_outlined, size: 28),
                  SizedBox(height: 8),
                  Text('savings'.tr),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed(RoutesName.noteView);
              },
              child: Column(
                children: [
                  Icon(Icons.note_alt_outlined, size: 28),
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
