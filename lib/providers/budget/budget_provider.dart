import 'package:finance_manager_app/config/db/local/budget_db/add_budget_db_helper.dart';
import 'package:flutter/foundation.dart';

import '../../models/tempm/budgetModel/budget_category_model.dart';
import '../../models/tempm/budgetModel/budget_model.dart';


class BudgetProvider with ChangeNotifier {
  final AddBudgetDbHelper _dbHelper = AddBudgetDbHelper();

  List<BudgetModel> _budgets = [];
  final Map<int, List<BudgetCategoryModel>> _categoriesByBudget = {};

  List<BudgetModel> get budgets => _budgets;
  Map<int, List<BudgetCategoryModel>> get categoriesByBudget => _categoriesByBudget;

  /// Fetch all budgets and their categories
  Future<void> loadBudgets() async {
    _budgets = await _dbHelper.getBudgets();
    _categoriesByBudget.clear();

    for (var budget in _budgets) {
      final categories = await _dbHelper.getCategoriesByBudget(budget.id!);
      _categoriesByBudget[budget.id!] = categories;
    }

    notifyListeners();
  }

  /// Insert new budget
  Future<int> addBudget(BudgetModel budget, List<BudgetCategoryModel> categories) async {
    final budgetId = await _dbHelper.insertBudget(budget);

    for (var cat in categories) {
      await _dbHelper.insertBudgetCategory(
        BudgetCategoryModel(
          budgetId: budgetId,
          categoryName: cat.categoryName,
          allocatedAmount: cat.allocatedAmount,
        ),
      );
    }

    await loadBudgets();
    return budgetId;
  }

  /// Add category to an existing budget
  Future<void> addCategoryToBudget(int budgetId, BudgetCategoryModel category) async {
    await _dbHelper.insertBudgetCategory(category);
    await loadBudgets();
  }

  /// Delete budget (cascade removes categories)
  Future<void> deleteBudget(int budgetId) async {
    await _dbHelper.deleteBudget(budgetId);
    await loadBudgets();
  }
}
