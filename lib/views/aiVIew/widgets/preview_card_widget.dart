import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/data/category/category_item_data.dart';
import 'package:finance_manager_app/data/category/income_item_data.dart';
import 'package:finance_manager_app/models/categoryModel/category_item_model.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/providers/aiProvider/ai_provider.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

String _money(int amount) => HelperFunctions.convertToBanglaDigits(
  '৳${NumberFormat.decimalPattern('en_IN').format(amount)}',
);

/// Summary plus one card per transaction the assistant found.
class PreviewCardWidget extends StatelessWidget {
  final List<TransactionModel> parsedDataEx;

  const PreviewCardWidget({super.key, required this.parsedDataEx});

  @override
  Widget build(BuildContext context) {
    if (parsedDataEx.isEmpty) return const _EmptyState();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Summary(transactions: parsedDataEx),
        const SizedBox(height: 16),
        for (var i = 0; i < parsedDataEx.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _TransactionCard(transaction: parsedDataEx[i], index: i),
          ),
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  final List<TransactionModel> transactions;

  const _Summary({required this.transactions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var spent = 0, earned = 0;
    for (final t in transactions) {
      if (t.type == TransactionType.income) {
        earned += t.amount;
      } else {
        spent += t.amount;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ai_found_count'.trParams({
            'count': HelperFunctions.convertToBanglaDigits(
              transactions.length.toString(),
            ),
          }),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'ai_review_hint'.tr,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textMuted,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            if (spent > 0)
              Expanded(
                child: _TotalTile(
                  label: 'ai_total_spent'.tr,
                  amount: spent,
                  color: AppColors.error,
                ),
              ),
            if (spent > 0 && earned > 0) const SizedBox(width: 12),
            if (earned > 0)
              Expanded(
                child: _TotalTile(
                  label: 'ai_total_earned'.tr,
                  amount: earned,
                  color: AppColors.success,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _TotalTile extends StatelessWidget {
  final String label;
  final int amount;
  final Color color;

  const _TotalTile({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _money(amount),
            style: theme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final int index;

  const _TransactionCard({required this.transaction, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncome = transaction.type == TransactionType.income;
    final color = Color(transaction.iconBgColor);
    final amountColor = isIncome ? AppColors.success : AppColors.error;
    final isDark = theme.brightness == Brightness.dark;
    final dividerColor = isDark
        ? AppColors.border
        : AppColors.lightBorder.withValues(alpha: 0.7);
    final labelStyle = theme.textTheme.bodyMedium?.copyWith(
      color: isDark ? AppColors.textSecondary : AppColors.lightTextMuted,
      fontWeight: FontWeight.w500,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: SvgPicture.asset(
                  "assets/functional_icons/${transaction.icon}.svg",
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title.isNotEmpty
                          ? transaction.title
                          : transaction.categoryKey.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_formatDate(transaction.date)}  ·  '
                      '${transaction.paymentMethod.tr}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${isIncome ? '+' : '−'}${_money(transaction.amount)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: amountColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  context.read<AiProvider>().removeTransactionAt(index);
                },
                icon: const Icon(Icons.close_rounded, size: 20),
                color: AppColors.textMuted,
                tooltip: 'remove'.tr,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12, right: 8),
            child: Divider(height: 1, color: dividerColor),
          ),
          // Each setting is a simple "label ... control" row
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                Text('ai_category_label'.tr, style: labelStyle),
                const SizedBox(width: 16),
                Expanded(
                  child: _CategoryChip(transaction: transaction, index: index),
                ),
              ],
            ),
          ),
          if (isIncome)
            Padding(
              padding: const EdgeInsets.only(top: 6, right: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text('ai_count_in_total'.tr, style: labelStyle),
                  ),
                  Switch(
                    value: transaction.includeInTotal,
                    activeThumbColor: AppColors.primaryBlue,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (v) => context
                        .read<AiProvider>()
                        .updateIncludeInTotal(index, v),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final days = DateTime(
      now.year,
      now.month,
      now.day,
    ).difference(DateTime(date.year, date.month, date.day)).inDays;

    if (days == 0) return 'today'.tr;
    if (days == 1) return 'yesterday'.tr;
    return HelperFunctions.convertToBanglaDigits(
      '${date.day}/${date.month}/${date.year}',
    );
  }
}

/// Shows the category; tapping it opens a picker.
class _CategoryChip extends StatelessWidget {
  final TransactionModel transaction;
  final int index;

  const _CategoryChip({required this.transaction, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = Color(transaction.iconBgColor);

    // Neutral field colors so the selector reads the same for every
    // category color, in both themes. The category color only tints the icon.
    final fieldColor = theme.scaffoldBackgroundColor;
    final borderColor = isDark ? AppColors.border : AppColors.lightBorder;
    final textColor = isDark
        ? AppColors.textPrimary
        : AppColors.lightTextPrimary;
    final arrowColor = isDark
        ? AppColors.textSecondary
        : AppColors.lightTextMuted;

    return Material(
      color: fieldColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _pickCategory(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
          child: Row(
            children: [
              Container(
                width: 26,
                height: 26,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  "assets/functional_icons/${transaction.icon}.svg",
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  transaction.categoryKey.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 22,
                color: arrowColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickCategory(BuildContext context) {
    HapticFeedback.selectionClick();
    final provider = context.read<AiProvider>();
    final categories = transaction.type == TransactionType.income
        ? incomeCategoryItems
        : categoryItems;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => _CategorySheet(
        categories: categories,
        selectedKey: transaction.categoryKey,
        onSelected: (category) {
          provider.updateCategory(index, category);
          Navigator.pop(sheetContext);
        },
      ),
    );
  }
}

class _CategorySheet extends StatelessWidget {
  final List<CategoryItemModel> categories;
  final String selectedKey;
  final ValueChanged<CategoryItemModel> onSelected;

  const _CategorySheet({
    required this.categories,
    required this.selectedKey,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Text(
              'ai_choose_category'.tr,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisExtent: 92,
              ),
              itemCount: categories.length,
              itemBuilder: (context, i) {
                final c = categories[i];
                final selected = c.key == selectedKey;
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onSelected(c);
                  },
                  child: Column(
                    children: [
                      const SizedBox(height: 6),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 48,
                        height: 48,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: c.color.withValues(
                            alpha: selected ? 0.25 : 0.1,
                          ),
                          shape: BoxShape.circle,
                          border: selected
                              ? Border.all(color: c.color, width: 2)
                              : null,
                        ),
                        child: SvgPicture.asset(
                          "assets/functional_icons/${c.icon}.svg",
                          colorFilter: ColorFilter.mode(
                            c.color,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        c.key.tr,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 56,
            color: AppColors.textMuted.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'ai_nothing_left'.tr,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
