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
          spent: cat.spent ?? 0,
         //   color: cat.color
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

  Future<void> addToCategorySpent(int categoryId, int amountToAdd) async {
    final success = await _dbHelper.addToCategorySpent(
      categoryId: categoryId,
      amountToAdd: amountToAdd,
    );

    if (success) {
      // update local data immediately
      for (var budgetId in _categoriesByBudget.keys) {
        final categories = _categoriesByBudget[budgetId];
        if (categories != null) {
          final index = categories.indexWhere((c) => c.id == categoryId);
          if (index != -1) {
            final old = categories[index];
            categories[index] =
                old.copyWith(spent: old.spent + amountToAdd); // ✅ update local
            break;
          }
        }
      }

      notifyListeners(); // ✅ tell UI to rebuild
    }
  }


  Future<void> subtractFromCategorySpent(int categoryId, int amountToSubtract) async {
    final success = await _dbHelper.subtractFromCategorySpent(
      categoryId: categoryId,
      amountToSubtract: amountToSubtract,
    );

    if (success) {
      for (var budgetId in _categoriesByBudget.keys) {
        final categories = _categoriesByBudget[budgetId];
        if (categories != null) {
          final index = categories.indexWhere((c) => c.id == categoryId);
          if (index != -1) {
            final old = categories[index];
            final newSpent = (old.spent - amountToSubtract).clamp(0, double.infinity).toInt();
            categories[index] = old.copyWith(spent: newSpent); // ✅ update local
            break;
          }
        }
      }

      notifyListeners(); // ✅ refresh UI
    }
  }


  Future<void> deleteCategory(int categoryId) async {
    final deleted = await _dbHelper.deleteCategory(categoryId);

    if (deleted > 0) {
      for (var budgetId in _categoriesByBudget.keys) {
        final categories = _categoriesByBudget[budgetId];
        if (categories != null) {
          categories.removeWhere((c) => c.id == categoryId); // ✅ remove from memory
        }
      }

      notifyListeners(); // ✅ rebuild UI instantly
    }
  }




  /// Delete budget (cascade removes categories)
  Future<void> deleteBudget(int budgetId) async {
    await _dbHelper.deleteBudget(budgetId);
    await loadBudgets();
  }
}
