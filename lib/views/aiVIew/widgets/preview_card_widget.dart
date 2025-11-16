import 'package:finance_manager_app/globalWidgets/card_widget.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/myColors/app_colors.dart';

class PreviewCardWidget extends StatelessWidget {
  final List<TransactionModel> parsedDataEx;

  const PreviewCardWidget({super.key, required this.parsedDataEx});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ai_suggestions'.tr,
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 16),
              if (parsedDataEx.isEmpty)
                 Text(
                  'no_transactions_detected'.tr,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),

              ...parsedDataEx.map(
                (transaction) => CardWidget(transaction: transaction),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
