import 'package:flutter/foundation.dart';
import 'package:finance_manager_app/config/db/local/savings_db/savings_repository.dart';
import 'package:finance_manager_app/models/savings_goal_model.dart';
import 'package:finance_manager_app/models/savings_transaction_model.dart';

class SavingsProvider with ChangeNotifier {
  final SavingsRepository _repository = SavingsRepository();

  // State variables
  List<SavingsGoal> _goals = [];
  final Map<int, List<SavingsTransaction>> _transactionsByGoal = {};
  double _totalSaved = 0.0;
  double _totalTarget = 0.0;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<SavingsGoal> get goals => _goals;
  Map<int, List<SavingsTransaction>> get transactionsByGoal =>
      _transactionsByGoal;
  double get totalSaved => _totalSaved;
  double get totalTarget => _totalTarget;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Overall progress percentage (total saved / total target)
  double get overallProgressPercentage {
    if (_totalTarget <= 0) return 0;
    final progress = (_totalSaved / _totalTarget) * 100;
    return progress > 100 ? 100 : progress;
  }

  /// Number of goals completed
  int get completedGoalsCount => _goals.where((g) => g.isCompleted).length;

  // ==================== LIFECYCLE ====================

  /// Load all goals and calculate totals
  Future<void> loadGoals() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _goals = await _repository.getAllGoals();
      _transactionsByGoal.clear();

      // Load transactions for each goal
      for (var goal in _goals) {
        final transactions = await _repository.getTransactionsByGoal(goal.id);
        _transactionsByGoal[goal.id] = transactions;
      }

      // Calculate totals
      await _calculateTotals();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // ==================== SAVINGS GOALS ====================

  /// Create a new savings goal
  Future<int> createGoal({
    required String name,
    required double targetAmount,
    required String startDate,
  }) async {
    try {
      _error = null;
      final goalId = await _repository.createGoal(
        name: name,
        targetAmount: targetAmount,
        startDate: startDate,
      );

      // Reload goals after creation
      await loadGoals();
      return goalId;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Get a specific goal by ID
  SavingsGoal? getGoalById(int id) {
    try {
      return _goals.firstWhere((g) => g.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Update a savings goal
  Future<void> updateGoal({
    required int id,
    required String name,
    required double targetAmount,
    required String startDate,
  }) async {
    try {
      _error = null;
      await _repository.updateGoal(
        id: id,
        name: name,
        targetAmount: targetAmount,
        startDate: startDate,
      );

      // Reload goals after update
      await loadGoals();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Delete a savings goal
  Future<void> deleteGoal(int id) async {
    try {
      _error = null;
      await _repository.deleteGoal(id);
      _goals.removeWhere((g) => g.id == id);
      _transactionsByGoal.remove(id);
      await _calculateTotals();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // ==================== SAVINGS TRANSACTIONS ====================

  /// Add a transaction (add or remove amount from goal)
  Future<int> addTransaction({
    required int goalId,
    required String type, // 'add' or 'remove'
    required double amount,
    required String date,
    String? note,
  }) async {
    try {
      _error = null;
      final txnId = await _repository.addTransaction(
        goalId: goalId,
        type: type,
        amount: amount,
        date: date,
        note: note,
      );

      // Reload goals (to update current amount)
      await loadGoals();
      return txnId;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Get transactions for a specific goal
  List<SavingsTransaction> getGoalTransactions(int goalId) {
    return _transactionsByGoal[goalId] ?? [];
  }

  /// Update a transaction
  Future<void> updateTransaction({
    required int id,
    required int goalId,
    required String type,
    required double newAmount,
    required String date,
    String? note,
  }) async {
    try {
      _error = null;
      await _repository.updateTransaction(
        id: id,
        goalId: goalId,
        type: type,
        newAmount: newAmount,
        date: date,
        note: note,
      );

      // Reload goals (to update current amount)
      await loadGoals();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Delete a transaction
  Future<void> deleteTransaction(int id, int goalId) async {
    try {
      _error = null;
      await _repository.deleteTransaction(id);

      // Remove from local list
      final transactions = _transactionsByGoal[goalId];
      if (transactions != null) {
        transactions.removeWhere((t) => t.id == id);
      }

      // Reload goals (to update current amount)
      await loadGoals();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // ==================== UTILITY METHODS ====================

  /// Calculate total saved and target
  Future<void> _calculateTotals() async {
    _totalSaved = await _repository.getTotalSaved();
    _totalTarget = await _repository.getTotalTarget();
  }

  /// Clear all savings data (for testing/reset)
  Future<void> clearAllData() async {
    try {
      _error = null;
      await _repository.clearAllData();
      _goals.clear();
      _transactionsByGoal.clear();
      _totalSaved = 0.0;
      _totalTarget = 0.0;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Delete all savings data for logged-out user
  Future<void> deleteFullSavings() async {
    try {
      _error = null;
      await _repository.deleteFullSavings();
      _goals.clear();
      _transactionsByGoal.clear();
      _totalSaved = 0.0;
      _totalTarget = 0.0;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
