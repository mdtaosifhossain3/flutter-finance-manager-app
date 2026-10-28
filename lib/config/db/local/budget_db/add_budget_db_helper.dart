import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../models/budgetModel/budget_category_model.dart';
import '../../../../models/budgetModel/budget_model.dart';
import '../../../../services/uid_service.dart';

class AddBudgetDbHelper {
  static final AddBudgetDbHelper _instance = AddBudgetDbHelper._internal();
  factory AddBudgetDbHelper() => _instance;
  AddBudgetDbHelper._internal();

  static Database? _db;
  String? _currentUid;

  /// Get budgets table name with UID
  String get budgetsTable {
    final uid = UidService.instance.getUidOrThrow();
    return 'budgets_$uid';
  }

  /// Get budget categories table name with UID
  String get categoriesTable {
    final uid = UidService.instance.getUidOrThrow();
    return 'budget_categories_$uid';
  }

  Future<Database> get database async {
    final uid = UidService.instance.getUidOrThrow();

    // If UID changed, close current DB and open new one
    if (_currentUid != uid) {
      await closeDB();
      _currentUid = uid;
    }

    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final uid = UidService.instance.getUidOrThrow();
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'budget_db_$uid.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createTables(db, uid);
      },
    );
  }

  /// Create budget tables
  Future<void> _createTables(Database db, String uid) async {
    final budgets = 'budgets_$uid';
    final categories = 'budget_categories_$uid';

    // Budgets table
    await db.execute('''
      CREATE TABLE $budgets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        totalAmount INTEGER NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT NOT NULL
      )
    ''');

    // Budget categories table
    await db.execute('''
      CREATE TABLE $categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        budgetId INTEGER NOT NULL,
        categoryName TEXT NOT NULL,
        spent INTEGER NOT NULL,
        icon TEXT NOT NULL,
        iconBgColor INTEGER NOT NULL,
        FOREIGN KEY (budgetId) REFERENCES $budgets (id) ON DELETE CASCADE
      )
    ''');
  }

  /// Close the database
  Future<void> closeDB() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }

  // ------------------ Budget Methods ------------------
  Future<int> insertBudget(BudgetModel budget) async {
    final db = await database;
    return await db.insert(
      budgetsTable,
      budget.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BudgetModel>> getBudgets() async {
    final db = await database;
    final result = await db.query(budgetsTable);
    return result.map((e) => BudgetModel.fromMap(e)).toList();
  }

  Future<int> deleteBudget(int id) async {
    final db = await database;
    return await db.delete(budgetsTable, where: 'id = ?', whereArgs: [id]);
  }

  // ------------------ Budget Category Methods ------------------
  Future<int> insertBudgetCategory(BudgetCategoryModel category) async {
    final db = await database;
    return await db.insert(
      categoriesTable,
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BudgetCategoryModel>> getCategoriesByBudget(int budgetId) async {
    final db = await database;
    final result = await db.query(
      categoriesTable,
      where: 'budgetId = ?',
      whereArgs: [budgetId],
    );
    return result.map((e) => BudgetCategoryModel.fromMap(e)).toList();
  }

  // ------------------ Fetch Budgets with Categories ------------------
  Future<List<Map<String, dynamic>>> getBudgetsWithCategories() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT b.id as budgetId, b.title, b.totalAmount, b.startDate, b.endDate,
             c.id as categoryId, c.categoryName
      FROM $budgetsTable b
      LEFT JOIN $categoriesTable c
      ON b.id = c.budgetId
    ''');
    return result;
  }

  // Add amount to spent
  Future<bool> addToCategorySpent({
    required int categoryId,
    required int amountToAdd,
  }) async {
    final db = await database;

    final result = await db.query(
      categoriesTable,
      columns: ['spent'],
      where: 'id = ?',
      whereArgs: [categoryId],
    );

    if (result.isEmpty) return false;

    final currentSpent = result.first['spent'] as int;
    final newSpent = currentSpent + amountToAdd;

    final rowsAffected = await db.update(
      categoriesTable,
      {'spent': newSpent},
      where: 'id = ?',
      whereArgs: [categoryId],
    );

    return rowsAffected > 0;
  }

  // Subtract amount from spent
  Future<bool> subtractFromCategorySpent({
    required int categoryId,
    required int amountToSubtract,
  }) async {
    final db = await database;

    final result = await db.query(
      categoriesTable,
      columns: ['spent'],
      where: 'id = ?',
      whereArgs: [categoryId],
    );

    if (result.isEmpty) return false;

    final currentSpent = result.first['spent'] as int;
    final newSpent = (currentSpent - amountToSubtract)
        .clamp(0, double.infinity)
        .toInt();

    final rowsAffected = await db.update(
      categoriesTable,
      {'spent': newSpent},
      where: 'id = ?',
      whereArgs: [categoryId],
    );

    return rowsAffected > 0;
  }

  // Delete category
  Future<int> deleteCategory(int categoryId) async {
    final db = await database;
    return await db.delete(
      categoriesTable,
      where: 'id = ?',
      whereArgs: [categoryId],
    );
  }

  // Add new category to existing budget
  Future<int> addCategoryToExistingBudget({
    required int budgetId,
    required String categoryName,
    required int spent,
    required String icon,
    required int iconBgColor,
  }) async {
    final db = await database;

    // Make sure the budget exists
    final budgetExists = await db.query(
      budgetsTable,
      where: 'id = ?',
      whereArgs: [budgetId],
    );

    if (budgetExists.isEmpty) {
      throw Exception('Budget with ID $budgetId not found');
    }

    // Create the category
    final category = {
      'budgetId': budgetId,
      'categoryName': categoryName,
      'spent': spent,
      'icon': icon,
      'iconBgColor': iconBgColor,
    };

    return await db.insert(
      categoriesTable,
      category,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update (add to) allocated amount of an existing category
  Future<bool> updateCategoryAmount({
    required int categoryId,
    required int amountToAdd,
  }) async {
    final db = await database;

    // Fetch current allocatedAmount
    final result = await db.query(
      categoriesTable,
      columns: ['spent'],
      where: 'id = ?',
      whereArgs: [categoryId],
    );

    if (result.isEmpty) return false;

    final currentAmount = result.first['spent'] as int;
    final newAmount = currentAmount + amountToAdd;

    final rowsAffected = await db.update(
      categoriesTable,
      {'spent': newAmount},
      where: 'id = ?',
      whereArgs: [categoryId],
    );

    return rowsAffected > 0;
  }

  Future<void> deleteFullBudget() async {
    try {
      final db = await database;
      await db.rawDelete('DELETE FROM $budgetsTable');
      await db.rawDelete('DELETE FROM $categoriesTable');
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting all budgets: $e");
      }
    }
  }

  Future<int> updateCategorySpent(int categoryId, int newSpent) async {
    final db = await database;
    return await db.update(
      categoriesTable,
      {'spent': newSpent},
      where: 'id = ?',
      whereArgs: [categoryId],
    );
  }
}
