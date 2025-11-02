import 'package:flutter/material.dart';

import '../../../config/myColors/app_colors.dart';

class SuggestionChipsWidget extends StatelessWidget {
  final TextEditingController textController;
  const SuggestionChipsWidget({super.key, required this.textController});

  @override
  Widget build(BuildContext context) {
    final suggestions = [
      '💳 Spent on food',
      '💰 Received salary',
      '🛒 Bought groceries',
      '⛽ Fuel expense',
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: suggestions.map((suggestion) {
        return InkWell(
          onTap: () {
            textController.text = suggestion
                .replaceAll(RegExp(r'[^\w\s]'), '')
                .trim();
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.04,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Text(
              suggestion,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontSize: 12),
            ),
          ),
        );
      }).toList(),
    );
  }
}
