import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/models/budgetModel/budget_category_model.dart';
import 'package:finance_manager_app/models/budgetModel/budget_model.dart';
import 'package:finance_manager_app/providers/budget/budget_provider.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: customAppBar(
        title: "budgetOverview".tr,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.03,
            ),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: AppColors.error,
                padding: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 1,
              ),
              onPressed: () {
                context.read<BudgetProvider>().deleteBudget(widget.budget.id!);

                Get.back();
              },
              icon: const Icon(Icons.delete),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Budget Summary Card
            _buildBudgetSummaryCard(),
            SizedBox(height: 24),

            // Progress Bar
            _buildProgressBar(),
            SizedBox(height: 24),

            // Chart Section
            //   _buildChartSection(),
            SizedBox(height: 24),

            // Expenses List
            _buildExpensesList(),
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

        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.blue.withValues(alpha:0.3),
            //     blurRadius: 10,
            //     offset: Offset(0, 4),
            //   ),
            // ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'budgetOverview'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBudgetMetric(
                    'allocated'.tr,
                    widget.budget.totalAmount,
                    Colors.white,
                  ),
                  _buildBudgetMetric('spent'.tr, totalSpent, Colors.red[300]!),
                  _buildBudgetMetric(
                    'remaining'.tr,
                    remaining,
                    Colors.green[300]!,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBudgetMetric(String label, int amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '৳${HelperFunctions.convertToBanglaDigits(amount.toString())}',
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
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

        double progressPercentage = (totalSpent / widget.budget.totalAmount)
            .clamp(0.0, 1.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'budgetProgress'.tr,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  '${HelperFunctions.convertToBanglaDigits((percentage * 100).toInt().toString())}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: progressPercentage > 0.8
                        ? AppColors.error
                        : AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progressPercentage,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: progressPercentage > 0.8
                          ? [Colors.red[400]!, Colors.red[600]!]
                          : [Colors.blue[400]!, Colors.blue[600]!],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
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
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Theme.of(context).cardColor,
              title: Text(
                'addCategoryToBudget'.tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dropdown for selecting category
                  Flexible(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true, // ensures the dropdown takes full width
                      decoration: InputDecoration(
                        labelText: 'selectCategory'.tr,
                        labelStyle: Theme.of(context).textTheme.labelMedium,
                        border: OutlineInputBorder(),
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
                  ),
                  const SizedBox(height: 15),
                  // Amount input
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'allocatedAmount'.tr,
                      labelStyle: Theme.of(context).textTheme.labelMedium,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('cancel'.tr),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedCategory == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('pleaseSelectCategory'.tr),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final input = amountController.text.trim();
                    final int? amount = int.tryParse(input);

                    if (amount == null || amount <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('pleaseEnterValidAmount'.tr),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Add category to existing budget via provider
                    await context
                        .read<BudgetProvider>()
                        .addCategoryToExistingBudget(
                          budgetId: budgetId,
                          categoryName: selectedCategory!,
                          allocatedAmount: amount,
                        );

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('categoryAddedSuccess'.tr),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: Text(
                    'addCategory'.tr,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
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

  Widget _buildExpensesList() {
    return Consumer<BudgetProvider>(
      builder: (context, provider, child) {
        final categories = provider.categoriesByBudget[widget.budget.id];
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: Offset(0, 2),
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
                    'categories'.tr,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: AppColors.primaryBlue,
                      padding: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 1,
                    ),
                    onPressed: () {
                      showAddCategoryDialog(context, widget.budget.id!);
                    },
                    icon: const Icon(Icons.add, size: 20),
                  ),
                ],
              ),
              SizedBox(height: 16),
              //...expenses.map((expense) => _buildExpenseItem(expense)),
              if (categories == null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("No categories yet"),
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
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            'addSpent'.tr,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'addAmount'.tr,
              labelStyle: Theme.of(context).textTheme.labelMedium,
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text('cancel'.tr),
            ),
            ElevatedButton(
              onPressed: () async {
                final input = amountController.text.trim();

                if (input.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('budgetAmountValidError'.tr),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final int? amount = int.tryParse(input);
                if (amount == null || amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('budgetAmountValidError'.tr),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // ✅ Update category amount via provider
                await context.read<BudgetProvider>().updateCategoryAmount(
                  categoryId: categoryId,
                  amountToAdd: amount,
                );

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('amountUpdatedSuccess'.tr),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text(
                'update'.tr,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExpenseItem(BudgetCategoryModel expense) {
    final spentPercent = expense.allocatedAmount == 0
        ? 0.0
        : expense.spent / expense.allocatedAmount;
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    expense.categoryName.tr,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          onTap: () {
                            showEditCategoryAmountDialog(context, expense.id!);
                          },
                          child: Icon(Icons.edit_rounded, size: 18),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          onTap: () async {
                            await context.read<BudgetProvider>().deleteCategory(
                              expense.id!,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("categoryDeleted".tr)),
                            );
                          },
                          child: Icon(
                            Icons.delete_rounded,
                            size: 18,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          // Progress Bar (spent / allocated)
          LinearProgressIndicator(
            value: spentPercent.clamp(0.0, 1.0),
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(
              spentPercent >= 1
                  ? Colors.redAccent
                  : Colors.greenAccent.shade700,
            ),
          ),

          SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "৳${HelperFunctions.convertToBanglaDigits(expense.spent.toString())} / ৳${HelperFunctions.convertToBanglaDigits(expense.allocatedAmount.toString())}",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
