import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/models/savings_goal_model.dart';
import 'package:finance_manager_app/providers/savingsProvider/savings_provider.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:finance_manager_app/utils/savings_optional_utils.dart';
import 'package:finance_manager_app/views/savingsView/pages/add_transaction_dailogue.dart';
import 'package:finance_manager_app/views/savingsView/pages/transactions_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SavingsGoalDetailsView extends StatefulWidget {
  final SavingsGoal goal;

  const SavingsGoalDetailsView({super.key, required this.goal});

  @override
  State<SavingsGoalDetailsView> createState() => _SavingsGoalDetailsViewState();
}

class _SavingsGoalDetailsViewState extends State<SavingsGoalDetailsView> {
  late SavingsGoal _currentGoal;

  @override
  void initState() {
    super.initState();
    _currentGoal = widget.goal;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkMainBackground
          : AppColors.lightMainBackground,
      appBar: AppBar(title: Text(_currentGoal.name), centerTitle: true),
      body: SafeArea(
        child: Consumer<SavingsProvider>(
          builder: (context, provider, child) {
            final updatedGoal = provider.getGoalById(_currentGoal.id);
            if (updatedGoal != null) {
              _currentGoal = updatedGoal;
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  // Status Badge
                  _buildStatusBadge(context, isDark),
                  const SizedBox(height: 20),

                  // Quick Stats Cards
                  _buildQuickStats(context, isDark),
                  const SizedBox(height: 24),

                  // Progress Section
                  _buildProgressSection(context, isDark),
                  const SizedBox(height: 24),

                  // Milestone (if applicable)
                  if (!_currentGoal.isCompleted)
                    _buildMilestone(context, isDark),

                  // Transactions Section
                  _buildTransactionsSection(context, provider, isDark),

                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //    Get.to(() => AddTransactionView(goal: _currentGoal));
          AddTransactionDialog.show(context, _currentGoal);
        },
        backgroundColor: Theme.of(context).primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'addMoney'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: _currentGoal.isCompleted
              ? AppColors.success.withValues(alpha: 0.1)
              : Theme.of(context).primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _currentGoal.isCompleted
                ? AppColors.success.withValues(alpha: 0.3)
                : Theme.of(context).primaryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentGoal.isCompleted
                    ? AppColors.success
                    : Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              _currentGoal.isCompleted ? Icons.check_circle : Icons.trending_up,
              color: _currentGoal.isCompleted
                  ? AppColors.success
                  : Theme.of(context).primaryColor,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              _currentGoal.isCompleted ? 'completed'.tr : 'active'.tr,
              style: TextStyle(
                color: _currentGoal.isCompleted
                    ? AppColors.success
                    : Theme.of(context).primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Saved Amount
          Expanded(
            child: _buildStatCard(
              context,
              isDark,
              label: 'saved'.tr,
              amount: _currentGoal.currentAmount,
              icon: Icons.account_balance_wallet_outlined,
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: 12),

          // Target Amount
          Expanded(
            child: _buildStatCard(
              context,
              isDark,
              label: 'target'.tr,
              amount: _currentGoal.targetAmount,
              icon: Icons.flag_outlined,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 12),

          // Remaining Amount
          Expanded(
            child: _buildStatCard(
              context,
              isDark,
              label: 'left'.tr,
              amount: _currentGoal.remainingAmount,
              icon: Icons.trending_up,
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    bool isDark, {
    required String label,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.border
              : AppColors.lightBorder.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color.withValues(alpha: 0.7), size: 20),
          const SizedBox(height: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '৳${HelperFunctions.recievedIntAndconvertToBanglaDigits(amount.toInt())}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context, bool isDark) {
    final textPrimary = isDark
        ? AppColors.textPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.textSecondary
        : AppColors.lightTextSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? AppColors.border
                : AppColors.lightBorder.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'progress'.tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${HelperFunctions.recievedIntAndconvertToBanglaDigits(_currentGoal.progressPercentage.toInt())}%',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: _currentGoal.isCompleted
                        ? AppColors.success
                        : Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Progress Bar
            Stack(
              children: [
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: (_currentGoal.progressPercentage / 100).clamp(
                    0.0,
                    1.0,
                  ),
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _currentGoal.isCompleted
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
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (_currentGoal.isCompleted
                                      ? AppColors.success
                                      : Theme.of(context).primaryColor)
                                  .withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Additional Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'started'.tr,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      HelperFunctions.getFormattedDate(
                        DateTime.parse(_currentGoal.startDate),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                if (!_currentGoal.isCompleted) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.keyboard_arrow_up,
                          color: Theme.of(context).primaryColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'keepGoing'.tr,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestone(BuildContext context, bool isDark) {
    final milestone = SavingsOptionalUtils.getMilestonePercentage(
      _currentGoal.progressPercentage,
    );

    if (milestone == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.success.withValues(alpha: 0.1),
              AppColors.success.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.celebration,
                color: AppColors.success,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'milestoneAchieved'.tr,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${"milestoneReached_one".tr} $milestone% ${"milestoneReached_other".tr}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsSection(
    BuildContext context,
    SavingsProvider provider,
    bool isDark,
  ) {
    final transactions = provider.getGoalTransactions(_currentGoal.id);
    final textPrimary = isDark
        ? AppColors.textPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.textSecondary
        : AppColors.lightTextSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'recentActivity'.tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (transactions.isEmpty)
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBackground : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? AppColors.border
                      : AppColors.lightBorder.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 48,
                    color: textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'noTransactions'.tr,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'addFirstTransaction'.tr,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textSecondary.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          else
            ...transactions.take(5).map((txn) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBackground : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.2 : 0.03,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: isDark
                        ? AppColors.border
                        : AppColors.lightBorder.withValues(alpha: 0.3),
                  ),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Icon
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:
                                  (txn.isAdd
                                          ? AppColors.success
                                          : AppColors.error)
                                      .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              txn.isAdd
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: txn.isAdd
                                  ? AppColors.success
                                  : AppColors.error,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Title and Date
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  txn.isAdd
                                      ? 'moneyAdded'.tr
                                      : 'moneyRemoved'.tr,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  HelperFunctions.getFormattedDateTime(
                                    DateTime.parse(txn.date),
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: textSecondary,
                                        fontSize: 12,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          // Spacer to avoid overlap with amount if title is long
                          const SizedBox(width: 60),
                        ],
                      ),
                    ),

                    // Amount (Bottom Right)
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Text(
                        '${txn.signPrefix}৳${HelperFunctions.recievedIntAndconvertToBanglaDigits(txn.amount.toInt())}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: txn.isAdd
                                  ? AppColors.success
                                  : AppColors.error,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),

                    // Menu (Top Right)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Material(
                        color: Colors.transparent,
                        child: PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_horiz,
                            size: 20,
                            color: textSecondary.withValues(alpha: 0.5),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onSelected: (value) {
                            if (value == 'edit') {
                              AddTransactionDialog.show(
                                context,
                                _currentGoal,
                                transaction: txn,
                              );
                            } else if (value == 'delete') {
                              _confirmDeleteTransaction(context, provider, txn);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              height: 40,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                    color: textPrimary,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'edit'.tr,
                                    style: TextStyle(
                                      color: textPrimary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              height: 40,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                    color: AppColors.error,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'delete'.tr,
                                    style: TextStyle(
                                      color: AppColors.error,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

          if (transactions.length > 5)
            Center(
              child: TextButton(
                onPressed: () {
                  Get.to(() => TransactionsListView(goal: _currentGoal));
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'viewMore'.tr,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _confirmDeleteTransaction(
    BuildContext context,
    SavingsProvider provider,
    dynamic txn,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text(
          'Are you sure you want to delete this transaction?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              try {
                await provider.deleteTransaction(txn.id, _currentGoal.id);
                Get.snackbar(
                  'Success',
                  'Transaction deleted',
                  backgroundColor: AppColors.success,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(16),
                );
              } catch (e) {
                Get.snackbar(
                  'Error',
                  e.toString(),
                  backgroundColor: AppColors.error,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(16),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
