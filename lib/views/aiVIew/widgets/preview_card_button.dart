import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../config/myColors/app_colors.dart';

/// "Edit text" goes back to the input; "Save" stores everything.
/// Save is greyed out when [onSave] is null.
class PreviewCardButton extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback? onSave;

  const PreviewCardButton({
    super.key,
    required this.onEdit,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  onEdit();
                },
                icon: const Icon(Icons.edit_outlined, size: 20),
                label: Text(
                  'ai_edit_text'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryBlue,
                  side: BorderSide(
                    color: AppColors.primaryBlue.withValues(alpha: 0.4),
                  ),
                  shape: shape,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 56,
              child: FilledButton.icon(
                onPressed: onSave == null
                    ? null
                    : () {
                        HapticFeedback.mediumImpact();
                        onSave!();
                      },
                icon: const Icon(Icons.check_rounded, size: 22),
                label: Text(
                  'save'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primaryBlue.withValues(
                    alpha: 0.3,
                  ),
                  disabledForegroundColor: Colors.white.withValues(alpha: 0.85),
                  shape: shape,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
