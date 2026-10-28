import 'package:finance_manager_app/config/db/local/budget_db/add_budget_db_helper.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/budgetModel/budget_category_model.dart';
import '../../models/budgetModel/budget_model.dart';
import '../../services/reminder_helper.dart';

class BudgetProvider with ChangeNotifier {
  final AddBudgetDbHelper _dbHelper = AddBudgetDbHelper();

  List<BudgetModel> _budgets = [];
  final Map<int, List<BudgetCategoryModel>> _categoriesByBudget = {};

  List<BudgetModel> get budgets => _budgets;
  Map<int, List<BudgetCategoryModel>> get categoriesByBudget =>
      _categoriesByBudget;

  /// Fetch all budgets and their categories
  Future<void> loadBudgets() async {
    // Yield to let the UI render the first frame
    await Future.delayed(Duration.zero);
    try {
      _budgets = await _dbHelper.getBudgets();
      _categoriesByBudget.clear();

      for (var budget in _budgets) {
        final categories = await _dbHelper.getCategoriesByBudget(budget.id!);
        _categoriesByBudget[budget.id!] = categories;
      }

      await scheduleDailyLimitNotification();
      await checkBudgetExpiry();
    } catch (e) {
      debugPrint("Error loading budgets: $e");
    } finally {
      notifyListeners();
    }
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

    // Check if the new budget is already overspent
    await checkOverspending(budgetId);

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
    required String icon,
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

    // Check if adding this category caused overspending
    await checkOverspending(budgetId);
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
      int? affectedBudgetId;
      for (var budgetId in _categoriesByBudget.keys) {
        final categories = _categoriesByBudget[budgetId];
        if (categories != null) {
          final index = categories.indexWhere((c) => c.id == categoryId);
          if (index != -1) {
            final old = categories[index];
            categories[index] = old.copyWith(spent: old.spent + amountToAdd);
            affectedBudgetId = budgetId;
            break;
          }
        }
      }

      notifyListeners(); // ✅ Refresh UI immediately

      // Check if updating this category caused overspending
      if (affectedBudgetId != null) {
        await checkOverspending(affectedBudgetId);
      }
    }
  }

  /// Delete budget (cascade removes categories)
  Future<void> deleteBudget(int budgetId) async {
    await _dbHelper.deleteBudget(budgetId);
    await ReminderHelper.cancelBudgetNotification(budgetId);
    await _clearAlertFlags(budgetId: budgetId);
    await loadBudgets();
  }

  Future<void> deleteFullBudget() async {
    try {
      await _dbHelper.deleteFullBudget();
      await ReminderHelper.cancelAllBudgetNotifications();
      await _clearAlertFlags();
      _budgets.clear();
      _categoriesByBudget.clear();
      notifyListeners();
    } catch (e) {
      debugPrint("Error in deleteFullBudget: $e");
    }
  }

  // ----------------------------
  //  ADVANCED BUDGET LOGIC
  // ----------------------------

  /// Calculate daily spending limit for a budget
  double calculateDailyLimit(BudgetModel budget) {
    final now = DateTime.now();
    if (now.isAfter(budget.endDate)) return 0;

    final categories = _categoriesByBudget[budget.id] ?? [];
    final totalSpent = categories.fold(0, (sum, item) => sum + item.spent);
    final remainingAmount = budget.totalAmount - totalSpent;

    if (remainingAmount <= 0) return 0;

    final remainingDays = budget.endDate.difference(now).inDays + 1;
    return remainingAmount / (remainingDays > 0 ? remainingDays : 1);
  }

  // Budgets stay active through the whole of their end date
  DateTime _endOfBudget(BudgetModel budget) => DateTime(
    budget.endDate.year,
    budget.endDate.month,
    budget.endDate.day + 1,
  ).subtract(const Duration(seconds: 1));

  static const String _overspentFlag = 'budget_overspent_notified_';
  static const String _expiredFlag = 'budget_expiry_notified_';

  /// Removes the "already notified" flags for one budget, or all budgets.
  Future<void> _clearAlertFlags({int? budgetId}) async {
    final prefs = await SharedPreferences.getInstance();
    if (budgetId != null) {
      await prefs.remove('$_overspentFlag$budgetId');
      await prefs.remove('$_expiredFlag$budgetId');
      return;
    }
    for (final key in prefs.getKeys().toList()) {
      if (key.startsWith(_overspentFlag) || key.startsWith(_expiredFlag)) {
        await prefs.remove(key);
      }
    }
  }

  /// Notifies once when a budget goes over its limit. The flag resets when
  /// spending drops back under, so crossing the limit again notifies again.
  Future<void> checkOverspending(int budgetId) async {
    final budget = _budgets.firstWhereOrNull((b) => b.id == budgetId);
    if (budget == null) return;

    final categories = _categoriesByBudget[budgetId] ?? [];
    final totalSpent = categories.fold(0, (sum, item) => sum + item.spent);

    final prefs = await SharedPreferences.getInstance();
    final key = '$_overspentFlag$budgetId';
    final alreadyNotified = prefs.getBool(key) ?? false;

    if (totalSpent > budget.totalAmount) {
      if (alreadyNotified) return;
      await prefs.setBool(key, true);
      await ReminderHelper.showBudgetOverspendingNotification(
        budgetId,
        budget.title,
      );
    } else if (alreadyNotified) {
      await prefs.remove(key);
    }
  }

  /// Notifies once per budget when it expires. The flag resets if the
  /// budget's end date is moved into the future again.
  Future<void> checkBudgetExpiry() async {
    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();

    for (var budget in _budgets) {
      if (budget.id == null) continue;
      final key = '$_expiredFlag${budget.id}';

      if (now.isAfter(_endOfBudget(budget))) {
        if (prefs.getBool(key) ?? false) continue;
        await prefs.setBool(key, true);
        await ReminderHelper.showBudgetExpiryNotification(
          budget.id!,
          budget.title,
        );
      } else {
        await prefs.remove(key);
      }
    }
  }

  /// Schedule daily notification for all active budgets
  Future<void> scheduleDailyLimitNotification() async {
    for (var budget in _budgets) {
      if (budget.id == null) continue;
      final endOfBudget = _endOfBudget(budget);

      if (DateTime.now().isBefore(endOfBudget) && budget.totalAmount > 0) {
        await ReminderHelper.scheduleDailyBudgetNotification(
          budgetId: budget.id!,
          budgetName: budget.title,
          dailyLimit: calculateDailyLimit(budget),
          endDate: endOfBudget,
        );
      } else {
        // Expired or invalid budget: make sure nothing stays scheduled
        await ReminderHelper.cancelBudgetNotification(budget.id!);
      }
    }
  }

  final AddExpenseProvider? transactionProvider;

  BudgetProvider({this.transactionProvider}) {
    if (transactionProvider != null) {
      transactionProvider!.addListener(_onTransactionsChanged);
    }
  }

  @override
  void dispose() {
    transactionProvider?.removeListener(_onTransactionsChanged);
    super.dispose();
  }

  void _onTransactionsChanged() {
    recalculateSpentAmounts();
  }

  Future<void> recalculateSpentAmounts() async {
    if (transactionProvider == null) return;

    final transactions = transactionProvider!.transactionData;

    // Iterate ALL budgets to ensure data consistency
    for (var budget in _budgets) {
      final categories = _categoriesByBudget[budget.id];
      if (categories == null) continue;

      bool budgetChanged = false;

      for (var category in categories) {
        // Calculate total spent for this category in this budget period
        final relevantTransactions = transactions.where((tx) {
          // Inclusive date check: start <= date <= end
          // Using !isBefore(start) and !isAfter(end)
          final isWithin =
              !tx.date.isBefore(budget.startDate) &&
              !tx.date.isAfter(
                budget.endDate
                    .add(const Duration(days: 1))
                    .subtract(const Duration(seconds: 1)),
              );

          return tx.categoryKey == category.categoryName && isWithin;
        });

        final totalSpent = relevantTransactions.fold<int>(
          0,
          (sum, tx) => sum + tx.amount,
        );

        if (totalSpent != category.spent) {
          // Update local state
          final index = categories.indexOf(category);
          categories[index] = category.copyWith(spent: totalSpent);

          // Update DB
          await _dbHelper.updateCategorySpent(category.id!, totalSpent);
          budgetChanged = true;
        }
      }

      if (budgetChanged) {
        // checkOverspending only notifies when the limit is first crossed
        await checkOverspending(budget.id!);
      }
    }
    notifyListeners();
  }
}
