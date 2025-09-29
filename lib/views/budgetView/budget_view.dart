import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/theme_provider.dart';
import 'package:finance_manager_app/views/budgetView/pages/add_budget_view.dart';
import 'package:finance_manager_app/views/budgetView/pages/budget_card_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class BudgetViewScreen extends StatefulWidget {
  const BudgetViewScreen({super.key});

  @override
  _BudgetViewScreenState createState() => _BudgetViewScreenState();
}

class _BudgetViewScreenState extends State<BudgetViewScreen>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  // Sample budget data
  final List<BudgetCard> budgetCards = [
    BudgetCard(
      title: 'Vacation',
      spent: 1247.50,
      budget: 2500.00,
      color: Colors.red,
    ),
    BudgetCard(
      title: 'Food & Dining',
      spent: 320.00,
      budget: 400.00,
      color: Colors.orange,
    ),
    BudgetCard(
      title: 'Transportation',
      spent: 145.50,
      budget: 200.00,
      color: Colors.green,
    ),
    BudgetCard(
      title: 'Entertainment',
      spent: 280.00,
      budget: 250.00, // Overspent
      color: Colors.purple,
    ),
    BudgetCard(
      title: 'Shopping',
      spent: 450.75,
      budget: 300.00, // Overspent
      color: Colors.red,
    ),
    BudgetCard(
      title: 'Health & Fitness',
      spent: 85.00,
      budget: 150.00,
      color: Colors.teal,
    ),
    BudgetCard(
      title: 'Bills & Utilities',
      spent: 380.00,
      budget: 400.00,
      color: Colors.indigo,
    ),
    BudgetCard(
      title: 'Subscriptions',
      spent: 89.99,
      budget: 100.00,
      color: Colors.cyan,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      budgetCards.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 1500),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
      );
    }).toList();

    // Start animations with staggered delay
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'Budget Overview',
        actions: [
          SizedBox(width: 10),
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.03,
            ),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).cardColor,
                foregroundColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 1,
              ),
              onPressed: () {
                Get.to(AddBudgetView());
              },
              icon: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                  vertical: 10,
                ),
                physics: BouncingScrollPhysics(),
                itemCount: budgetCards.length,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _animations[index],
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 30 * (1 - _animations[index].value)),
                        child: Opacity(
                          opacity: _animations[index].value,
                          child: _buildBudgetCard(budgetCards[index], index),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetCard(BudgetCard budget, int index) {
    final double percentage = (budget.spent / budget.budget).clamp(0.0, 1.0);
    final bool isOverspent = budget.spent > budget.budget;
    final double remaining = budget.budget - budget.spent;
    final double overspent = budget.spent - budget.budget;

    return GestureDetector(
      onTap: () {
        Get.to(BudgetCardView());
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and percentage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  budget.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: budget.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: budget.color.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isOverspent ? Icons.trending_up : Icons.trending_down,
                        color: isOverspent ? AppColors.error : budget.color,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${(percentage * 100).toInt()}%',
                        style: TextStyle(
                          color: isOverspent ? AppColors.error : budget.color,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Amount display
            Text(
              '৳${budget.spent.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 4),

            // Status text
            Text(
              isOverspent
                  ? '৳${overspent.toStringAsFixed(2)} overspent of ৳${budget.budget.toStringAsFixed(2)}'
                  : '৳${remaining.toStringAsFixed(2)} left of ৳${budget.budget.toStringAsFixed(2)}',
              style: TextStyle(
                color: isOverspent ? AppColors.error : AppColors.success,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),

            // Progress bar
            Container(
              height: 8,
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
                          : [budget.color.withOpacity(0.7), budget.color],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),

            // Bottom message
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isOverspent
                    ? AppColors.error.withOpacity(0.1)
                    : AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isOverspent
                      ? AppColors.error.withOpacity(0.3)
                      : AppColors.success.withOpacity(0.3),
                  width: 1,
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
                  SizedBox(width: 8),
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
            ),
          ],
        ),
      ),
    );
  }
}

class BudgetCard {
  final String title;
  final double spent;
  final double budget;
  final Color color;

  BudgetCard({
    required this.title,
    required this.spent,
    required this.budget,
    required this.color,
  });
}
