import 'package:finance_manager_app/config/db/local/budget_db/add_budget_db_helper.dart';
import 'package:flutter/material.dart';

import '../../models/budgetModel/budget_category_model.dart';
import '../../models/budgetModel/budget_model.dart';

class BudgetProvider with ChangeNotifier {
  final AddBudgetDbHelper _dbHelper = AddBudgetDbHelper();

  List<BudgetModel> _budgets = [];
  final Map<int, List<BudgetCategoryModel>> _categoriesByBudget = {};

  List<BudgetModel> get budgets => _budgets;
  Map<int, List<BudgetCategoryModel>> get categoriesByBudget =>
      _categoriesByBudget;

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
  Future<int> addBudget(
    BudgetModel budget,
    List<BudgetCategoryModel> categories,
  ) async {
    final budgetId = await _dbHelper.insertBudget(budget);

    for (var cat in categories) {
      await _dbHelper.insertBudgetCategory(
        BudgetCategoryModel(
          budgetId: budgetId,
          categoryName: cat.categoryName,
          spent: cat.spent,
          icon: cat.icon,
          iconBgColor: cat.iconBgColor,
        ),
      );
    }

    await loadBudgets();
    return budgetId;
  }

  /// Add category to an existing budget
  Future<void> addCategoryToBudget(
    int budgetId,
    BudgetCategoryModel category,
  ) async {
    await _dbHelper.insertBudgetCategory(category);
    await loadBudgets();
  }

  Future<void> deleteCategory(int categoryId) async {
    final deleted = await _dbHelper.deleteCategory(categoryId);

    if (deleted > 0) {
      for (var budgetId in _categoriesByBudget.keys) {
        final categories = _categoriesByBudget[budgetId];
        if (categories != null) {
          categories.removeWhere(
            (c) => c.id == categoryId,
          ); // ✅ remove from memory
        }
      }

      notifyListeners(); // ✅ rebuild UI instantly
    }
  }

  // ✅ Add a new category to an existing budget
  Future<void> addCategoryToExistingBudget({
    required int budgetId,
    required String categoryName,
    required int spent,
    required IconData icon,
    required int iconBgColor,
  }) async {
    // Add to database
    await _dbHelper.addCategoryToExistingBudget(
      budgetId: budgetId,
      categoryName: categoryName,
      spent: spent,
      icon: icon,
      iconBgColor: iconBgColor,
    );

    // Reload budgets and categories
    await loadBudgets();
  }

  // ✅ Update (add to) allocated amount of an existing category
  Future<void> updateCategoryAmount({
    required int categoryId,
    required int amountToAdd,
  }) async {
    final success = await _dbHelper.updateCategoryAmount(
      categoryId: categoryId,
      amountToAdd: amountToAdd,
    );

    if (success) {
      // Update local in-memory data instantly
      for (var budgetId in _categoriesByBudget.keys) {
        final categories = _categoriesByBudget[budgetId];
        if (categories != null) {
          final index = categories.indexWhere((c) => c.id == categoryId);
          if (index != -1) {
            final old = categories[index];
            categories[index] = old.copyWith(spent: old.spent + amountToAdd);
            break;
          }
        }
      }

      notifyListeners(); // ✅ Refresh UI immediately
    }
  }

  /// Delete budget (cascade removes categories)
  Future<void> deleteBudget(int budgetId) async {
    await _dbHelper.deleteBudget(budgetId);
    await loadBudgets();
  }
}
