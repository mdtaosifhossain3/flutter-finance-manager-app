import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/models/savings_goal_model.dart';
import 'package:finance_manager_app/providers/savingsProvider/savings_provider.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:finance_manager_app/views/savingsView/pages/add_savings_goal_dailogue.dart';
import 'package:finance_manager_app/views/savingsView/pages/savings_goal_details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavingsCardWidget extends StatelessWidget {
  final SavingsProvider provider;
  final SavingsGoal goal;

  const SavingsCardWidget({
    super.key,
    required this.provider,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? AppColors.darkCardBackground
        : AppColors.lightCardBackground;
    final textPrimary = isDark
        ? AppColors.textPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.textSecondary
        : AppColors.lightTextSecondary;

    return GestureDetector(
      onTap: () => Get.to(() => SavingsGoalDetailsView(goal: goal)),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.border : AppColors.lightBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Subtle gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor.withValues(alpha: 0.03),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    _buildHeader(context, textPrimary, textSecondary),
                    const SizedBox(height: 20),

                    // Main Amount Display
                    _buildAmountDisplay(context, textPrimary, textSecondary),
                    const SizedBox(height: 20),

                    // Progress Section
                    _buildProgressSection(context, textSecondary),
                    const SizedBox(height: 16),

                    // Bottom Stats
                    _buildBottomStats(context, textSecondary),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Goal Icon/Avatar
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor.withValues(alpha: 0.8),
                Theme.of(context).primaryColor,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            goal.isCompleted ? Icons.check_circle : Icons.savings_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),

        // Title and Date
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                goal.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 12,
                    color: textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    HelperFunctions.getFormattedDate(
                      DateTime.parse(goal.startDate),
                    ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Menu Button
        SizedBox(
          width: 36,
          height: 36,
          child: PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 18, color: textSecondary),
                    const SizedBox(width: 8),
                    Text('edit'.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'delete'.tr,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'edit') {
                AddSavingsGoalDialog.show(context, goal: goal);
              } else if (value == 'delete') {
                _showDeleteConfirmation(context);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.more_horiz,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountDisplay(
    BuildContext context,
    Color textPrimary,
    Color textSecondary,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          // Current Amount - Main Focus
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '৳',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                HelperFunctions.recievedIntAndconvertToBanglaDigits(
                  goal.currentAmount.toInt(),
                ),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'saved'.tr,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: textSecondary, fontSize: 13),
          ),

          const SizedBox(height: 12),

          // Divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  textSecondary.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Target and Remaining Row
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'target'.tr,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '৳${HelperFunctions.recievedIntAndconvertToBanglaDigits(goal.targetAmount.toInt())}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 30,
                color: textSecondary.withValues(alpha: 0.2),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'remaining'.tr,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '৳${HelperFunctions.recievedIntAndconvertToBanglaDigits(goal.remainingAmount.toInt())}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: goal.isCompleted
                            ? AppColors.success
                            : AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context, Color textSecondary) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'progress'.tr,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${HelperFunctions.recievedIntAndconvertToBanglaDigits(goal.progressPercentage.toInt())}%',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: goal.isCompleted
                    ? AppColors.success
                    : Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Progress Bar
        Stack(
          children: [
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            FractionallySizedBox(
              widthFactor: (goal.progressPercentage / 100).clamp(0.0, 1.0),
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: goal.isCompleted
                        ? [
                            AppColors.success,
                            AppColors.success.withValues(alpha: 0.7),
                          ]
                        : [
                            Theme.of(context).primaryColor,
                            Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.7),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (goal.isCompleted
                                  ? AppColors.success
                                  : Theme.of(context).primaryColor)
                              .withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomStats(BuildContext context, Color textSecondary) {
    return Row(
      children: [
        // Status Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: goal.isCompleted
                ? AppColors.success.withValues(alpha: 0.15)
                : Theme.of(context).primaryColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                goal.isCompleted ? Icons.check_circle : Icons.trending_up,
                size: 14,
                color: goal.isCompleted
                    ? AppColors.success
                    : Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 6),
              Text(
                goal.isCompleted ? 'completed'.tr : 'inProgress'.tr,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: goal.isCompleted
                      ? AppColors.success
                      : Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),

        // Tap hint
        Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: textSecondary.withValues(alpha: 0.5),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.error,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text('deleteGoal'.tr),
          ],
        ),
        content: Text('confirmDeleteGoal'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteGoal(goal.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 8),
                      Text('goalDeleted'.tr),
                    ],
                  ),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
  }
}
