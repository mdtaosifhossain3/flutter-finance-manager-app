import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:finance_manager_app/services/uid_service.dart';

class SavingsDBHelper {
  static const int dbVersion = 1;

  // Table names (will be prefixed with UID)
  static const String _savingsGoalsTableBase = 'savings_goals';
  static const String _savingsTransactionsTableBase = 'savings_transactions';

  // Savings Goals Table Columns
  static const String colId = 'id';
  static const String colName = 'name';
  static const String colTargetAmount = 'target_amount';
  static const String colCurrentAmount = 'current_amount';
  static const String colStartDate = 'start_date';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';

  // Savings Transactions Table Columns
  static const String colGoalId = 'goal_id';
  static const String colType = 'type';
  static const String colAmount = 'amount';
  static const String colNote = 'note';
  static const String colDate = 'date';
  static const String colTxCreatedAt = 'created_at';

  // Singleton instance
  static final SavingsDBHelper _instance = SavingsDBHelper._internal();

  factory SavingsDBHelper() {
    return _instance;
  }

  SavingsDBHelper._internal();

  static Database? _database;
  String? _currentUid;

  /// Get savings goals table name with UID
  String get savingsGoalsTable {
    final uid = UidService.instance.getUidOrThrow();
    return '${_savingsGoalsTableBase}_$uid';
  }

  /// Get savings transactions table name with UID
  String get savingsTransactionsTable {
    final uid = UidService.instance.getUidOrThrow();
    return '${_savingsTransactionsTableBase}_$uid';
  }

  Future<Database> get database async {
    final uid = UidService.instance.getUidOrThrow();

    // If UID changed, close current DB and open new one
    if (_currentUid != uid) {
      await closeDB();
      _currentUid = uid;
    }

    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final uid = UidService.instance.getUidOrThrow();
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'savings_db_$uid.db');

    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: (db, version) async {
        await _createTables(db, uid);
      },
    );
  }

  /// Create savings tables
  Future<void> _createTables(Database db, String uid) async {
    final goalsTable = '${_savingsGoalsTableBase}_$uid';
    final txnTable = '${_savingsTransactionsTableBase}_$uid';

    // Create savings_goals table
    await db.execute('''
      CREATE TABLE $goalsTable (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colName TEXT NOT NULL,
        $colTargetAmount REAL NOT NULL,
        $colCurrentAmount REAL NOT NULL DEFAULT 0,
        $colStartDate TEXT NOT NULL,
        $colCreatedAt TEXT NOT NULL,
        $colUpdatedAt TEXT NOT NULL
      )
    ''');

    // Create savings_transactions table
    await db.execute('''
      CREATE TABLE $txnTable (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colGoalId INTEGER NOT NULL,
        $colType TEXT NOT NULL,
        $colAmount REAL NOT NULL,
        $colNote TEXT,
        $colDate TEXT NOT NULL,
        $colTxCreatedAt TEXT NOT NULL,
        FOREIGN KEY ($colGoalId) REFERENCES $goalsTable ($colId) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better query performance
    await db.execute('''
      CREATE INDEX idx_goal_id_$uid ON $txnTable ($colGoalId)
    ''');

    await db.execute('''
      CREATE INDEX idx_transaction_date_$uid ON $txnTable ($colDate)
    ''');

    await db.execute('''
      CREATE INDEX idx_goal_created_at_$uid ON $goalsTable ($colCreatedAt)
    ''');

    if (kDebugMode) {
      print('Created savings tables for UID: $uid');
    }
  }

  // ==================== SAVINGS GOALS CRUD ====================

  /// Create a new savings goal
  Future<int> createGoal({
    required String name,
    required double targetAmount,
    required String startDate,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    return await db.insert(savingsGoalsTable, {
      colName: name,
      colTargetAmount: targetAmount,
      colCurrentAmount: 0,
      colStartDate: startDate,
      colCreatedAt: now,
      colUpdatedAt: now,
    });
  }

  /// Get all savings goals
  Future<List<Map<String, dynamic>>> getAllGoals() async {
    final db = await database;
    return await db.query(savingsGoalsTable, orderBy: '$colCreatedAt DESC');
  }

  /// Get a specific goal by ID
  Future<Map<String, dynamic>?> getGoalById(int id) async {
    final db = await database;
    final result = await db.query(
      savingsGoalsTable,
      where: '$colId = ?',
      whereArgs: [id],
    );

    return result.isNotEmpty ? result.first : null;
  }

  /// Update a savings goal
  Future<int> updateGoal({
    required int id,
    required String name,
    required double targetAmount,
    required String startDate,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    return await db.update(
      savingsGoalsTable,
      {
        colName: name,
        colTargetAmount: targetAmount,
        colStartDate: startDate,
        colUpdatedAt: now,
      },
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  /// Update goal current amount
  Future<int> updateGoalCurrentAmount(int goalId, double currentAmount) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    return await db.update(
      savingsGoalsTable,
      {colCurrentAmount: currentAmount, colUpdatedAt: now},
      where: '$colId = ?',
      whereArgs: [goalId],
    );
  }

  /// Delete a savings goal (cascade delete transactions)
  Future<int> deleteGoal(int id) async {
    final db = await database;

    return await db.transaction((txn) async {
      // Delete all transactions for this goal
      await txn.delete(
        savingsTransactionsTable,
        where: '$colGoalId = ?',
        whereArgs: [id],
      );

      // Delete the goal
      return await txn.delete(
        savingsGoalsTable,
        where: '$colId = ?',
        whereArgs: [id],
      );
    });
  }

  // ==================== SAVINGS TRANSACTIONS CRUD ====================

  /// Add a transaction (add or remove amount)
  Future<int> addTransaction({
    required int goalId,
    required String type, // 'add' or 'remove'
    required double amount,
    required String date,
    String? note,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    return await db.transaction((txn) async {
      // Insert transaction
      final txnId = await txn.insert(savingsTransactionsTable, {
        colGoalId: goalId,
        colType: type,
        colAmount: amount,
        colNote: note,
        colDate: date,
        colTxCreatedAt: now,
      });

      // Update goal current amount
      final goal = await txn.query(
        savingsGoalsTable,
        where: '$colId = ?',
        whereArgs: [goalId],
      );

      if (goal.isNotEmpty) {
        double currentAmount = (goal.first[colCurrentAmount] as num).toDouble();

        if (type == 'add') {
          currentAmount += amount;
        } else if (type == 'remove') {
          currentAmount -= amount;
          // Ensure it doesn't go below 0
          if (currentAmount < 0) {
            currentAmount = 0;
          }
        }

        await txn.update(
          savingsGoalsTable,
          {colCurrentAmount: currentAmount, colUpdatedAt: now},
          where: '$colId = ?',
          whereArgs: [goalId],
        );
      }

      return txnId;
    });
  }

  /// Get transactions by goal ID
  Future<List<Map<String, dynamic>>> getTransactionsByGoal(int goalId) async {
    final db = await database;
    return await db.query(
      savingsTransactionsTable,
      where: '$colGoalId = ?',
      whereArgs: [goalId],
      orderBy: '$colDate DESC, $colTxCreatedAt DESC',
    );
  }

  /// Get a specific transaction by ID
  Future<Map<String, dynamic>?> getTransactionById(int id) async {
    final db = await database;
    final result = await db.query(
      savingsTransactionsTable,
      where: '$colId = ?',
      whereArgs: [id],
    );

    return result.isNotEmpty ? result.first : null;
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
    final db = await database;
    final now = DateTime.now().toIso8601String();

    return await db.transaction((txn) async {
      // Get old transaction
      final oldTxn = await txn.query(
        savingsTransactionsTable,
        where: '$colId = ?',
        whereArgs: [id],
      );

      if (oldTxn.isEmpty) return 0;

      final oldType = oldTxn.first[colType] as String;
      final oldAmount = (oldTxn.first[colAmount] as num).toDouble();

      // Get current goal amount
      final goal = await txn.query(
        savingsGoalsTable,
        where: '$colId = ?',
        whereArgs: [goalId],
      );

      if (goal.isEmpty) return 0;

      double currentAmount = (goal.first[colCurrentAmount] as num).toDouble();

      // Reverse old transaction
      if (oldType == 'add') {
        currentAmount -= oldAmount;
      } else if (oldType == 'remove') {
        currentAmount += oldAmount;
      }

      // Apply new transaction
      if (type == 'add') {
        currentAmount += newAmount;
      } else if (type == 'remove') {
        currentAmount -= newAmount;
        // Ensure it doesn't go below 0
        if (currentAmount < 0) {
          currentAmount = 0;
        }
      }

      // Update transaction
      await txn.update(
        savingsTransactionsTable,
        {colType: type, colAmount: newAmount, colDate: date, colNote: note},
        where: '$colId = ?',
        whereArgs: [id],
      );

      // Update goal current amount
      await txn.update(
        savingsGoalsTable,
        {colCurrentAmount: currentAmount, colUpdatedAt: now},
        where: '$colId = ?',
        whereArgs: [goalId],
      );

      return 1;
    });
  }

  /// Delete a transaction (reverse and recalculate)
  Future<int> deleteTransaction(int id) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    return await db.transaction((txn) async {
      // Get transaction to delete
      final txnToDelete = await txn.query(
        savingsTransactionsTable,
        where: '$colId = ?',
        whereArgs: [id],
      );

      if (txnToDelete.isEmpty) return 0;

      final goalId = txnToDelete.first[colGoalId] as int;
      final type = txnToDelete.first[colType] as String;
      final amount = (txnToDelete.first[colAmount] as num).toDouble();

      // Get current goal amount
      final goal = await txn.query(
        savingsGoalsTable,
        where: '$colId = ?',
        whereArgs: [goalId],
      );

      if (goal.isNotEmpty) {
        double currentAmount = (goal.first[colCurrentAmount] as num).toDouble();

        // Reverse the transaction
        if (type == 'add') {
          currentAmount -= amount;
        } else if (type == 'remove') {
          currentAmount += amount;
        }

        // Ensure it doesn't go below 0
        if (currentAmount < 0) {
          currentAmount = 0;
        }

        // Update goal current amount
        await txn.update(
          savingsGoalsTable,
          {colCurrentAmount: currentAmount, colUpdatedAt: now},
          where: '$colId = ?',
          whereArgs: [goalId],
        );
      }

      // Delete transaction
      return await txn.delete(
        savingsTransactionsTable,
        where: '$colId = ?',
        whereArgs: [id],
      );
    });
  }

  // ==================== UTILITY METHODS ====================

  /// Get total saved across all goals
  Future<double> getTotalSaved() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM($colCurrentAmount) as total FROM $savingsGoalsTable',
    );

    if (result.isNotEmpty && result.first['total'] != null) {
      return (result.first['total'] as num).toDouble();
    }
    return 0.0;
  }

  /// Get total target across all goals
  Future<double> getTotalTarget() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM($colTargetAmount) as total FROM $savingsGoalsTable',
    );

    if (result.isNotEmpty && result.first['total'] != null) {
      return (result.first['total'] as num).toDouble();
    }
    return 0.0;
  }

  /// Clear all data for current user (for testing/reset)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete(savingsTransactionsTable);
    await db.delete(savingsGoalsTable);
  }

  /// Delete all savings data (called on logout)
  Future<void> deleteFullSavings() async {
    try {
      final db = await database;
      await db.rawDelete('DELETE FROM $savingsTransactionsTable');
      await db.rawDelete('DELETE FROM $savingsGoalsTable');
      if (kDebugMode) {
        print('Cleared all savings data for user');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting all savings: $e");
      }
    }
  }

  /// Close database
  Future<void> closeDB() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
