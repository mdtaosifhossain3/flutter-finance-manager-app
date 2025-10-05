import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/myColors/app_colors.dart';
import '../../../models/tempm/budgetModel/budget_category_model.dart';
import '../../../models/tempm/budgetModel/budget_model.dart';
import '../../../providers/budget/budget_provider.dart';
import '../pages/budget_card_view.dart';

class BudgetCardWidget extends StatelessWidget {
 final BudgetProvider provider;
 final BudgetModel budget;
  const BudgetCardWidget({super.key,required this.budget,required this.provider});
  @override
  Widget build(BuildContext context) {
    // ✅ Collect categories by budgetId
    final List<BudgetCategoryModel> categories =
        provider.categoriesByBudget[budget.id] ?? [];

    // ✅ Sum spent from all categories
    final int totalSpent = categories.fold(
      0,
          (sum, cat) => sum + (cat.spent),
    );

    final double percentage =
    (totalSpent / budget.totalAmount).clamp(0.0, 1.0);

    final bool isOverspent = totalSpent > budget.totalAmount;
    final int remaining = budget.totalAmount - totalSpent;
    final int overspent = totalSpent - budget.totalAmount;
    return GestureDetector(
      onTap: () {
        //percentage
        Get.to(() => BudgetCardView(
          budget: budget,
          categories: categories,
          remaining: remaining,
          totalSpent: totalSpent,percentage:percentage));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).cardColor,
              Theme.of(context).colorScheme.surface,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  budget.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isOverspent
                          ? AppColors.error.withOpacity(0.5)
                          : AppColors.success.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isOverspent ? Icons.trending_up : Icons.trending_down,
                        color: isOverspent ? AppColors.error : AppColors.success,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${(percentage * 100).toInt()}%',
                        style: TextStyle(
                          color: isOverspent
                              ? AppColors.error
                              : AppColors.success,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Spent
            Text(
              '৳$totalSpent',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 4),

            // Remaining / Overspent
            Text(
              isOverspent
                  ? '৳$overspent overspent of ৳${budget.totalAmount}'
                  : '৳$remaining left of ৳${budget.totalAmount}',
              style: TextStyle(
                color: isOverspent ? AppColors.error : AppColors.success,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // Progress bar
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage > 1.0 ? 1.0 : percentage,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isOverspent
                          ? [AppColors.error.withOpacity(0.7), AppColors.error]
                          : [AppColors.success.withOpacity(0.7),
                        AppColors.success],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Message
            totalSpent ==0 ? SizedBox.shrink() : Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isOverspent
                    ? AppColors.error.withOpacity(0.1)
                    : AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isOverspent
                      ? AppColors.error.withOpacity(0.3)
                      : AppColors.success.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isOverspent
                        ? Icons.warning_rounded
                        : Icons.check_circle_rounded,
                    color: isOverspent ? AppColors.error : AppColors.success,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                    isOverspent
                          ? 'You\'ve exceeded your budget. Consider reducing spending.'
                          : percentage > 0.8
                          ? 'You\'re close to your budget limit. Spend carefully.'
                          : 'You\'re doing great! Keep it up.',
                      style: TextStyle(
                        color: isOverspent
                            ? AppColors.error
                            : AppColors.success,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );  }
}
