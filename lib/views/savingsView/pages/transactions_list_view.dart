import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/models/savings_goal_model.dart';
import 'package:finance_manager_app/providers/savingsProvider/savings_provider.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:finance_manager_app/views/savingsView/pages/add_transaction_dailogue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class TransactionsListView extends StatefulWidget {
  final SavingsGoal goal;

  const TransactionsListView({super.key, required this.goal});

  @override
  State<TransactionsListView> createState() => _TransactionsListViewState();
}

class _TransactionsListViewState extends State<TransactionsListView> {
  late SavingsGoal _currentGoal;

  @override
  void initState() {
    super.initState();
    _currentGoal = widget.goal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('allTransactions'.tr),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<SavingsProvider>(
          builder: (context, provider, child) {
            // Update current goal from provider
            final updatedGoal = provider.getGoalById(_currentGoal.id);
            if (updatedGoal != null) {
              _currentGoal = updatedGoal;
            }

            final transactions = provider.getGoalTransactions(_currentGoal.id);
            final isDark = Theme.of(context).brightness == Brightness.dark;

            if (transactions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_outlined,
                      size: 64,
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'noTransactions'.tr,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final txn = transactions[index];
                final isAdd = txn.isAdd;
                final textPrimary = isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary;
                final textSecondary = isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary;

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
                                    (isAdd
                                            ? AppColors.success
                                            : AppColors.error)
                                        .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isAdd
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: isAdd
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
                                    isAdd ? 'moneyAdded'.tr : 'moneyRemoved'.tr,
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(
                                          color: textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    HelperFunctions.getFormattedDate(
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

                            // Spacer
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
                                color: isAdd
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
                                _deleteTransaction(context, provider, txn);
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
              },
            );
          },
        ),
      ),
    );
  }

  void _deleteTransaction(
    BuildContext context,
    SavingsProvider provider,
    transaction,
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
                await provider.deleteTransaction(
                  transaction.id,
                  _currentGoal.id,
                );
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
