import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/models/budgetModel/budget_category_model.dart';
import 'package:finance_manager_app/models/budgetModel/budget_model.dart';
import 'package:finance_manager_app/providers/budget/budget_provider.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../data/budget/budget_categories.dart';

class BudgetCardView extends StatefulWidget {
  final BudgetModel budget;
  final List<BudgetCategoryModel> categories;
  final int remaining;
  final int totalSpent;
  final double percentage;
  const BudgetCardView({
    super.key,
    required this.budget,
    required this.categories,
    required this.remaining,
    required this.totalSpent,
    required this.percentage,
  });

  @override
  State<BudgetCardView> createState() => _BudgetCardViewState();
}

class _BudgetCardViewState extends State<BudgetCardView> {
  String selectedPeriod = 'Month';

  @override
  Widget build(BuildContext context) {
    final provider = context.read<BudgetProvider>();

    return Scaffold(
      appBar: customAppBar(
        title: widget.budget.title,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: AppColors.error.withValues(alpha: 0.1),
                foregroundColor: AppColors.error,
                padding: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.warning_rounded,
                            color: AppColors.error,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text('confirm_delete'.tr)),
                      ],
                    ),
                    content: Text('delete_category_message'.tr),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('cancel'.tr),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('delete'.tr),
                      ),
                    ],
                  ),
                );

                if (confirm == true && mounted) {
                  await provider.deleteBudget(widget.budget.id!);
                  Get.back();
                  Get.snackbar(
                    'deleted'.tr,
                    'budgetDeletedSuccess'.tr,
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: AppColors.error,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                    duration: const Duration(seconds: 2),
                    icon: Icon(Icons.check_circle_rounded, color: Colors.white),
                  );
                }
              },
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBudgetSummaryCard(),
            const SizedBox(height: 24),
            _buildProgressBar(),
            const SizedBox(height: 24),
            _buildExpensesList(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetSummaryCard() {
    return Consumer<BudgetProvider>(
      builder: (context, provider, child) {
        final categories = provider.categoriesByBudget[widget.budget.id];
        final int totalSpent = categories != null
            ? categories.fold(0, (sum, cat) => sum + (cat.spent))
            : 0;
        final int remaining = widget.budget.totalAmount - totalSpent;
        final bool isOverspent = totalSpent > widget.budget.totalAmount;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildBudgetMetric(
                        'allocated'.tr,
                        widget.budget.totalAmount,
                        Icons.account_balance_wallet_outlined,
                        Colors.white,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 60,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    Expanded(
                      child: _buildBudgetMetric(
                        'spent'.tr,
                        totalSpent,
                        Icons.trending_up_rounded,
                        Colors.red[200]!,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 60,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    Expanded(
                      child: _buildBudgetMetric(
                        isOverspent ? 'over'.tr : 'remaining'.tr,
                        isOverspent
                            ? (totalSpent - widget.budget.totalAmount)
                            : remaining,
                        isOverspent
                            ? Icons.warning_rounded
                            : Icons.savings_outlined,
                        isOverspent ? Colors.red[200]! : Colors.green[200]!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBudgetMetric(
    String label,
    int amount,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          '${amount < 0 ? '-' : ''}৳ ${HelperFunctions.convertToBanglaDigits(amount.abs().toString())}',
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Consumer<BudgetProvider>(
      builder: (context, provider, child) {
        final categories = provider.categoriesByBudget[widget.budget.id];
        final int totalSpent = categories != null
            ? categories.fold(0, (sum, cat) => sum + (cat.spent))
            : 0;
        final double percentage = (totalSpent / widget.budget.totalAmount)
            .clamp(0.0, 1.0);
        final bool isOverspent = totalSpent > widget.budget.totalAmount;

        Color getProgressColor() {
          if (isOverspent) return AppColors.error;
          if (percentage > 0.8) return Colors.orange;
          return AppColors.success;
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: getProgressColor().withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.trending_up_rounded,
                          size: 18,
                          color: getProgressColor(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'budgetProgress'.tr,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.3,
                            ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: getProgressColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${HelperFunctions.convertToBanglaDigits((percentage * 100).toInt().toString())}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: getProgressColor(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Stack(
                children: [
                  Container(
                    height: 12,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage > 1.0 ? 1.0 : percentage,
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            getProgressColor(),
                            getProgressColor().withValues(alpha: 0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: getProgressColor().withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (isOverspent) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'budgetExceeded'.tr,
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildExpensesList() {
    return Consumer<BudgetProvider>(
      builder: (context, provider, child) {
        final categories = provider.categoriesByBudget[widget.budget.id];

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.category_outlined,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'categories'.tr,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.3,
                              fontSize: 18,
                            ),
                      ),
                    ],
                  ),

                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () =>
                          showAddCategoryDialog(context, widget.budget.id!),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.add_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (categories == null || categories.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.category_outlined,
                            size: 48,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'noCategoriesYet'.tr,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color
                                    ?.withValues(alpha: 0.6),
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'addCategoryToStart'.tr,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color
                                    ?.withValues(alpha: 0.5),
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...categories.map((expense) => _buildExpenseItem(expense)),
            ],
          ),
        );
      },
    );
  }

  Map<String, dynamic> _getCategoryIconData(String category) {
    switch (category.toLowerCase()) {
      case 'health_fitness':
        return {'icon': "health", 'color': Colors.teal};

      case 'food_dining':
        return {'icon': "food", 'color': Colors.red};

      case 'bills_utilities':
        return {'icon': "bills", 'color': Colors.orange};

      case 'phone':
        return {'icon': "phone", 'color': Colors.blueGrey};

      case 'beauty':
        return {'icon': "beauty", 'color': Colors.pinkAccent};

      case 'housing':
        return {'icon': "home", 'color': Colors.indigo};

      case 'transportation':
        return {'icon': "transport", 'color': Colors.blue};

      case 'entertainment':
        return {'icon': "entertainment", 'color': Colors.deepPurple};

      case 'shopping':
        return {'icon': "shopping", 'color': Colors.pink};

      case 'groceries':
        return {'icon': "groceries", 'color': Colors.green};

      case 'education':
        return {'icon': "education", 'color': Colors.deepOrange};

      case 'personal':
        return {'icon': "personal", 'color': Colors.cyan};

      case 'investment':
        return {'icon': "invesment", 'color': Colors.amber};

      case 'marketing_advertising':
        return {'icon': "marketing", 'color': Colors.redAccent};

      case 'travel_accommodation':
        return {'icon': "travel", 'color': Colors.cyanAccent};

      case 'office_supplies_equipment':
        return {'icon': "office", 'color': Colors.brown};

      case 'insurance':
        return {'icon': "insurance", 'color': Colors.brown.shade400};

      case 'subscription_services':
        return {'icon': "subscripiton", 'color': Colors.purpleAccent};

      case 'fuel_mileage':
        return {'icon': "fuel", 'color': Colors.deepOrangeAccent};

      case 'charity_donations':
        return {'icon': "charity", 'color': Colors.redAccent};

      case 'kids':
        return {'icon': "kids", 'color': Colors.lightBlueAccent};

      case 'repairs':
        return {'icon': "repair", 'color': Colors.grey};

      case 'pets':
        return {'icon': "pets", 'color': Colors.brown};

      case 'sports':
        return {'icon': "sports", 'color': Colors.green.shade700};

      default:
        return {'icon': "other", 'color': Colors.grey};
    }
  }

  Future<void> showAddCategoryDialog(BuildContext context, int budgetId) async {
    final TextEditingController amountController = TextEditingController();
    String? selectedCategory;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              backgroundColor: Theme.of(context).cardColor,
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.add_circle_outline_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'addCategoryToBudget'.tr,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'selectCategory'.tr,
                      labelStyle: Theme.of(context).textTheme.labelMedium,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    initialValue: selectedCategory,
                    items: categoryKeys
                        .map(
                          (cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(
                              cat.tr,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => selectedCategory = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'spent'.tr,
                      labelStyle: Theme.of(context).textTheme.labelMedium,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.payments_outlined),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('cancel'.tr),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedCategory == null) {
                      Get.snackbar(
                        'error'.tr,
                        'pleaseSelectCategory'.tr,
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: AppColors.error,
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                      );
                      return;
                    }

                    final input = amountController.text.trim();
                    final int? amount = int.tryParse(input);

                    if (amount == null || amount <= 0) {
                      Get.snackbar(
                        'error'.tr,
                        'pleaseEnterValidAmount'.tr,
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: AppColors.error,
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                      );
                      return;
                    }

                    final iconDataMap = _getCategoryIconData(selectedCategory!);
                    final provider = context.read<BudgetProvider>();

                    await provider.addCategoryToExistingBudget(
                      budgetId: budgetId,
                      categoryName: selectedCategory!,
                      spent: amount,
                      icon: iconDataMap['icon'],
                      iconBgColor: iconDataMap['color'].value,
                    );

                    Get.back();
                    Get.snackbar(
                      'success'.tr,
                      'categoryAddedSuccess'.tr,
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: AppColors.success,
                      colorText: Colors.white,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                      duration: const Duration(seconds: 2),
                      icon: Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'addCategory'.tr,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> showEditCategoryAmountDialog(
    BuildContext context,
    int categoryId,
  ) async {
    final TextEditingController amountController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Theme.of(context).cardColor,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.edit_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'addSpent'.tr,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'addAmount'.tr,
              labelStyle: Theme.of(context).textTheme.labelMedium,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.payments_outlined),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('cancel'.tr),
            ),
            ElevatedButton(
              onPressed: () async {
                final input = amountController.text.trim();

                if (input.isEmpty) {
                  Get.snackbar(
                    'error'.tr,
                    'budgetAmountValidError'.tr,
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: AppColors.error,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                  );
                  return;
                }

                final int? amount = int.tryParse(input);
                if (amount == null || amount <= 0) {
                  Get.snackbar(
                    'error'.tr,
                    'budgetAmountValidError'.tr,
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: AppColors.error,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                  );
                  return;
                }

                final provider = context.read<BudgetProvider>();
                await provider.updateCategoryAmount(
                  categoryId: categoryId,
                  amountToAdd: amount,
                );

                Get.back();
                Get.snackbar(
                  'success'.tr,
                  'amountUpdatedSuccess'.tr,
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: AppColors.success,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                  duration: const Duration(seconds: 2),
                  icon: Icon(Icons.check_circle_rounded, color: Colors.white),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'update'.tr,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExpenseItem(BudgetCategoryModel expense) {
    // Calculate percentage if you have a budget amount per category
    // If not available, you can remove the progress indicator
    final bool hasSpent = expense.spent > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Category Icon/Avatar
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                //   colors: [
                //     Theme.of(
                //       context,
                //     ).colorScheme.primary.withValues(alpha: 0.2),
                //     Theme.of(
                //       context,
                //     ).colorScheme.primary.withValues(alpha: 0.1),
                //   ],
                // ),
                color: Color(expense.iconBgColor).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/functional_icons/${expense.icon}.svg',
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    Color(expense.iconBgColor),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Category Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              expense.categoryName.tr,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.3,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: hasSpent
                                        ? AppColors.error.withValues(alpha: 0.1)
                                        : Theme.of(context)
                                              .colorScheme
                                              .surfaceContainerHighest
                                              .withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        hasSpent
                                            ? Icons.trending_up_rounded
                                            : Icons.remove_circle_outline,
                                        size: 10,
                                        color: hasSpent
                                            ? AppColors.error
                                            : Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.color
                                                  ?.withValues(alpha: 0.5),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '৳${HelperFunctions.convertToBanglaDigits(expense.spent.toString())}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: hasSpent
                                              ? AppColors.error
                                              : Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.color
                                                    ?.withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Action Buttons
                      Row(
                        children: [
                          // Edit Button
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                showEditCategoryAmountDialog(
                                  context,
                                  expense.id!,
                                );
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: 18,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Delete Button
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                // Show confirmation dialog
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('confirm_delete'.tr),
                                    content: Text('delete_category_message'.tr),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: Text('cancel'.tr),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        style: TextButton.styleFrom(
                                          foregroundColor: AppColors.error,
                                        ),
                                        child: Text('delete'.tr),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true && mounted) {
                                  final provider = context
                                      .read<BudgetProvider>();
                                  await provider.deleteCategory(expense.id!);
                                  Get.snackbar(
                                    'deleted'.tr,
                                    'categoryDeleted'.tr,
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: AppColors.error,
                                    colorText: Colors.white,
                                    margin: const EdgeInsets.all(16),
                                    borderRadius: 12,
                                    duration: const Duration(seconds: 2),
                                    icon: Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.white,
                                    ),
                                  );
                                }
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.delete_outline_rounded,
                                  size: 18,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
