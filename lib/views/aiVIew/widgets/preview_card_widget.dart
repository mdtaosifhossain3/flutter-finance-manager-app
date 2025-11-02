import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/globalWidgets/card_widget.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:flutter/material.dart';

import '../../../config/myColors/app_colors.dart';

class PreviewCardWidget extends StatelessWidget {
  final parsedDataEx;

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
                'AI Suggestions',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 16),
              if (parsedDataEx.isEmpty)
                const Text(
                  'No transactions were detected in the input.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),

              ...parsedDataEx
                  .map((transaction) => CardWidget(transaction: transaction))
                  .toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionCard(TransactionModel transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.darkMainBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Type indicator
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: transaction.type == TransactionType.expense
                  ? AppColors.error
                  : AppColors.success,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          // Category and Notes
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.categoryName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (transaction.notes?.isNotEmpty == true)
                  Text(
                    transaction.notes!,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Amount and Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: transaction.type == TransactionType.expense
                      ? AppColors.error
                      : AppColors.success,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _formatDate(transaction.date),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
