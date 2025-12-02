import 'package:finance_manager_app/models/budgetModel/budget_category_model.dart';
import 'package:finance_manager_app/models/budgetModel/budget_model.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/myColors/app_colors.dart';
import '../../../providers/budget/budget_provider.dart';
import '../pages/budget_card_view.dart';

class BudgetCardWidget extends StatelessWidget {
  final BudgetProvider provider;
  final BudgetModel budget;
  const BudgetCardWidget({
    super.key,
    required this.budget,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    // Collect categories by budgetId
    final List<BudgetCategoryModel> categories =
        provider.categoriesByBudget[budget.id] ?? [];

    // Sum spent from all categories
    final int totalSpent = categories.fold(0, (sum, cat) => sum + (cat.spent));

    final double percentage = (totalSpent / budget.totalAmount).clamp(0.0, 1.0);
    final bool isOverspent = totalSpent > budget.totalAmount;
    final int remaining = budget.totalAmount - totalSpent;

    // Determine status color
    Color getStatusColor() {
      if (isOverspent) return AppColors.error;
      if (percentage > 0.8) return Colors.orange;
      return AppColors.success;
    }

    return GestureDetector(
      onTap: () {
        Get.to(
          () => BudgetCardView(
            budget: budget,
            categories: categories,
            remaining: remaining,
            totalSpent: totalSpent,
            percentage: percentage,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        budget.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 12,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '৳${HelperFunctions.convertToBanglaDigits(budget.totalAmount.toString())}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Circular percentage indicator
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        getStatusColor().withValues(alpha: 0.2),
                        getStatusColor().withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 42,
                        height: 42,
                        child: CircularProgressIndicator(
                          value: percentage > 1.0 ? 1.0 : percentage,
                          strokeWidth: 5,
                          backgroundColor: Theme.of(
                            context,
                          ).dividerColor.withValues(alpha: 0.2),
                          color: getStatusColor(),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Text(
                        '${HelperFunctions.convertToBanglaDigits((percentage * 100).toInt().toString())}%',
                        style: TextStyle(
                          color: getStatusColor(),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Enhanced progress bar with animation hint
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'budgetProgress'.tr,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Stack(
                  children: [
                    // Background track
                    Container(
                      height: 8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).dividerColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    // Filled progress with gradient
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: percentage > 1.0 ? 1.0 : percentage,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              getStatusColor(),
                              getStatusColor().withValues(alpha: 0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: getStatusColor().withValues(alpha: 0.3),
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
            ),
            const SizedBox(height: 20),

            // Spent and Remaining with icons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Spent
                  Expanded(
                    child: _buildInfoColumn(
                      context,
                      'spent'.tr,
                      totalSpent.toString(),
                      Icons.trending_up_rounded,
                      Theme.of(context).colorScheme.error,
                    ),
                  ),
                  // Divider
                  _buildDivider(context),
                  const SizedBox(width: 12),
                  // Remaining
                  Expanded(
                    child: _buildInfoColumn(
                      context,
                      isOverspent ? 'overspent'.tr : 'remaining'.tr,
                      isOverspent
                          ? (totalSpent - budget.totalAmount).toString()
                          : remaining.toString(),
                      isOverspent
                          ? Icons.warning_rounded
                          : Icons.savings_outlined,
                      getStatusColor(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Daily Limit and Days Left
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Daily Limit
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "label_daily_limit".tr,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    fontSize: 10,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color
                                        ?.withValues(alpha: 0.7),
                                  ),
                            ),
                            Text(
                              "৳${HelperFunctions.convertToBanglaDigits(provider.calculateDailyLimit(budget).toStringAsFixed(0))}",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Days Left / Expired
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              DateTime.now().isAfter(budget.endDate)
                                  ? "label_status".tr
                                  : "label_days_left".tr,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    fontSize: 10,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color
                                        ?.withValues(alpha: 0.7),
                                  ),
                            ),
                            Text(
                              DateTime.now().isAfter(budget.endDate)
                                  ? "label_expired".tr
                                  : "${HelperFunctions.convertToBanglaDigits((budget.endDate.difference(DateTime.now()).inDays + 1).toString())} ${"label_days".tr}",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        DateTime.now().isAfter(budget.endDate)
                                        ? AppColors.error
                                        : AppColors.success,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          DateTime.now().isAfter(budget.endDate)
                              ? Icons.event_busy
                              : Icons.timer_outlined,
                          size: 16,
                          color: DateTime.now().isAfter(budget.endDate)
                              ? AppColors.error
                              : AppColors.success,
                        ),
                      ],
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

  Widget _buildInfoColumn(
    BuildContext context,
    String label,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '৳${HelperFunctions.convertToBanglaDigits(amount)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
    );
  }
}
