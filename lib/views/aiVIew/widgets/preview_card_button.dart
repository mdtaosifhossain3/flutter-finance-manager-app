import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/myColors/app_colors.dart';

class PreviewCardButton extends StatelessWidget {
  final void Function() editTransactionButton;
  final void Function() deleteTransactionButton;
  final void Function() saveTransactionButton;
  const PreviewCardButton({
    super.key,
    required this.editTransactionButton,
    required this.deleteTransactionButton,
    required this.saveTransactionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Delete Button
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 56,
            child: OutlinedButton(
              onPressed: deleteTransactionButton,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.error.withValues(alpha: 0.2)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                foregroundColor: AppColors.error,
              ),
              child: const Icon(Icons.delete_outline_rounded, size: 22),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Edit Button
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 56,
            child: OutlinedButton(
              onPressed: editTransactionButton,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                foregroundColor: AppColors.textSecondary,
              ),
              child: const Icon(Icons.edit_outlined, size: 22),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Save Button (Primary)
        Expanded(
          flex: 5,
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: saveTransactionButton,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_rounded, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'save'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
