import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../models/tempm/budgetModel/budget_category_model.dart';
import '../../../../models/tempm/budgetModel/budget_model.dart';


class AddBudgetDbHelper {
  static final AddBudgetDbHelper _instance = AddBudgetDbHelper._internal();
  factory AddBudgetDbHelper() => _instance;
  AddBudgetDbHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'budget_db.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Budgets table
        await db.execute('''
          CREATE TABLE budgets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            totalAmount INTEGER NOT NULL,
            startDate TEXT NOT NULL,
            endDate TEXT NOT NULL
          )
        ''');

        // Budget categories table
        await db.execute('''
          CREATE TABLE budget_categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            budgetId INTEGER NOT NULL,
            categoryName TEXT NOT NULL,
            allocatedAmount INTEGER NOT NULL,
            FOREIGN KEY (budgetId) REFERENCES budgets (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  // ------------------ Budget Methods ------------------

  Future<int> insertBudget(BudgetModel budget) async {
    final db = await database;
    return await db.insert('budgets', budget.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<BudgetModel>> getBudgets() async {
    final db = await database;
    final result = await db.query('budgets');
    return result.map((e) => BudgetModel.fromMap(e)).toList();
  }

  Future<int> deleteBudget(int id) async {
    final db = await database;
    return await db.delete('budgets', where: 'id = ?', whereArgs: [id]);
  }

  // ------------------ Budget Category Methods ------------------

  Future<int> insertBudgetCategory(BudgetCategoryModel category) async {
    final db = await database;
    return await db.insert('budget_categories', category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<BudgetCategoryModel>> getCategoriesByBudget(int budgetId) async {
    final db = await database;
    final result = await db.query(
      'budget_categories',
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
             c.id as categoryId, c.categoryName, c.allocatedAmount
      FROM budgets b
      LEFT JOIN budget_categories c
      ON b.id = c.budgetId
    ''');
    return result;
  }
}
