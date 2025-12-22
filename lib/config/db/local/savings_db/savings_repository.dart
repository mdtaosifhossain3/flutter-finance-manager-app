import 'package:finance_manager_app/config/db/local/savings_db/savings_db_helper.dart';
import 'package:finance_manager_app/models/savings_goal_model.dart';
import 'package:finance_manager_app/models/savings_transaction_model.dart';

class SavingsRepository {
  final SavingsDBHelper _dbHelper = SavingsDBHelper();

  // ==================== SAVINGS GOALS ====================

  /// Create a new savings goal
  Future<int> createGoal({
    required String name,
    required double targetAmount,
    required String startDate,
  }) async {
    return await _dbHelper.createGoal(
      name: name,
      targetAmount: targetAmount,
      startDate: startDate,
    );
  }

  /// Get all savings goals
  Future<List<SavingsGoal>> getAllGoals() async {
    final goalMaps = await _dbHelper.getAllGoals();
    return goalMaps.map((map) => SavingsGoal.fromMap(map)).toList();
  }

  /// Get a specific goal by ID
  Future<SavingsGoal?> getGoalById(int id) async {
    final goalMap = await _dbHelper.getGoalById(id);
    return goalMap != null ? SavingsGoal.fromMap(goalMap) : null;
  }

  /// Update a savings goal
  Future<int> updateGoal({
    required int id,
    required String name,
    required double targetAmount,
    required String startDate,
  }) async {
    return await _dbHelper.updateGoal(
      id: id,
      name: name,
      targetAmount: targetAmount,
      startDate: startDate,
    );
  }

  /// Delete a savings goal (cascade deletes transactions)
  Future<int> deleteGoal(int id) async {
    return await _dbHelper.deleteGoal(id);
  }

  // ==================== SAVINGS TRANSACTIONS ====================

  /// Add a transaction (add or remove amount)
  Future<int> addTransaction({
    required int goalId,
    required String type, // 'add' or 'remove'
    required double amount,
    required String date,
    String? note,
  }) async {
    return await _dbHelper.addTransaction(
      goalId: goalId,
      type: type,
      amount: amount,
      date: date,
      note: note,
    );
  }

  /// Get transactions by goal ID
  Future<List<SavingsTransaction>> getTransactionsByGoal(int goalId) async {
    final txnMaps = await _dbHelper.getTransactionsByGoal(goalId);
    return txnMaps.map((map) => SavingsTransaction.fromMap(map)).toList();
  }

  /// Get a specific transaction by ID
  Future<SavingsTransaction?> getTransactionById(int id) async {
    final txnMap = await _dbHelper.getTransactionById(id);
    return txnMap != null ? SavingsTransaction.fromMap(txnMap) : null;
  }

  /// Update a transaction (reverse old → apply new)
  Future<int> updateTransaction({
    required int id,
    required int goalId,
    required String type,
    required double newAmount,
    required String date,
    String? note,
  }) async {
    return await _dbHelper.updateTransaction(
      id: id,
      goalId: goalId,
      type: type,
      newAmount: newAmount,
      date: date,
      note: note,
    );
  }

  /// Delete a transaction (reverse and recalculate)
  Future<int> deleteTransaction(int id) async {
    return await _dbHelper.deleteTransaction(id);
  }

  // ==================== UTILITY METHODS ====================

  /// Get total saved across all goals
  Future<double> getTotalSaved() async {
    return await _dbHelper.getTotalSaved();
  }

  /// Get total target across all goals
  Future<double> getTotalTarget() async {
    return await _dbHelper.getTotalTarget();
  }

  /// Clear all data (for testing/reset)
  Future<void> clearAllData() async {
    return await _dbHelper.clearAllData();
  }

  /// Delete full savings data for logged-out user
  Future<void> deleteFullSavings() async {
    return await _dbHelper.deleteFullSavings();
  }

  /// Close database
  Future<void> closeDB() async {
    return await _dbHelper.closeDB();
  }
}
