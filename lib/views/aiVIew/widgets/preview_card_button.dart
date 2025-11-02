import 'package:flutter/material.dart';

import '../../../config/myColors/app_colors.dart';

class PreviewCardButton extends StatelessWidget {
  final void Function() editTransactionButton;
  final void Function() deleteTransactionButton;
  final void Function() saveTransactionButton;
  const PreviewCardButton({super.key, required this.editTransactionButton, required this.deleteTransactionButton, required this.saveTransactionButton});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.edit,
            label: 'Edit',
            color: AppColors.warning,
            onTap: editTransactionButton,
          ),
        ),
        SizedBox(width: 14,),
        Expanded(
          child: _buildActionButton(
            icon: Icons.delete,
            label: 'Delete',
            color: AppColors.error,
            onTap: deleteTransactionButton,
          ),
        ),
        SizedBox(width: 14,),
        Expanded(
          child: _buildActionButton(
            icon: Icons.check,
            label: 'Save',
            color: AppColors.success,
            isPrimary: true,
            onTap: saveTransactionButton,
          ),
        ),
      ],
    );
  }
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isPrimary ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPrimary ? Colors.transparent : color.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isPrimary ? Colors.white : color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.white : color,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
