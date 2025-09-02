import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/routes/routes_name.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return   GestureDetector(
      onTap: () {
        Get.toNamed(RoutesName.notificationView);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.notifications_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
