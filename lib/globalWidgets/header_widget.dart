import 'package:finance_manager_app/globalWidgets/notification_widget.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String categoryName;
  final bool showBackButton;
  const HeaderWidget({super.key, required this.categoryName, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (showBackButton)
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24,
            ),
          ),
         Text(
          categoryName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        NotificationWidget(),
      ],
    );
  }
}
