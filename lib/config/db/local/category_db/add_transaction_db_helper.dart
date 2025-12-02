import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../models/categoryModel/transaction_model.dart';

class AddTransactionDbHelper {
  AddTransactionDbHelper._();

  static final AddTransactionDbHelper getInstance = AddTransactionDbHelper._();

  Database? myDB;

  // Table Data
  final String tableName = 'transaction_data';
  final String id = 'id';
  final String type = 'type';
  final String date = 'date';
  final String title = 'title';
  final String amount = 'amount';
  final String notes = 'notes';
  final String paymentMethod = 'paymentMethod';
  final String icon = 'icon';
  final String iconBgColor = 'iconBgColor';
  final String categoryKey = 'categoryKey';
  final String includeInTotal = 'includeInTotal';

  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, 'transaction_data.db');

    return await openDatabase(
      dbPath,
      version: 2, // Incremented version for schema change
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $tableName (
          $id INTEGER PRIMARY KEY AUTOINCREMENT,
          $type INTEGER NOT NULL,
          $date TEXT NOT NULL,
          $title TEXT NOT NULL,
          $amount INTEGER NOT NULL,
          $notes TEXT,
          $paymentMethod TEXT NOT NULL,
          $icon TEXT NOT NULL,
          $categoryKey TEXT NOT NULL,
          $iconBgColor INTEGER NOT NULL,
          $includeInTotal INTEGER NOT NULL DEFAULT 1)''');
      },
    );
  }

  ///insertion
  Future<bool> addItem(TransactionModel ex) async {
    var db = await getDB();
    int rowsEffected = await db.insert(tableName, ex.toMap());
    return rowsEffected > 0;
  }

  //Fetch All Data
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDB();
    List<Map<String, dynamic>> mData = await db.query(tableName);

    return mData;
  }

  // Fetch Data by Date Range
  Future<List<Map<String, dynamic>>> getTransactionsByDateRange(
    String startDate,
    String endDate,
  ) async {
    var db = await getDB();
    // Assuming date is stored as TEXT in ISO8601 format (YYYY-MM-DD...)
    // We can use string comparison for dates in this format.
    List<Map<String, dynamic>> mData = await db.query(
      tableName,
      where: '$date >= ? AND $date <= ?',
      whereArgs: [startDate, endDate],
      orderBy: '$date DESC', // Optional: sort by date descending
    );

    return mData;
  }

  //update
  Future<bool> updateItem({
    required int itemID,
    required TransactionModel tx,
  }) async {
    final db = await getDB();

    final rowsAffected = await db.update(
      tableName,
      tx.toMapForUpdate(),
      where: 'id = ?',
      whereArgs: [itemID],
    );

    return rowsAffected > 0;
  }

  // one delete
  Future<int> deleteItem(int itemId) async {
    final db = await getDB();
    return await db.delete(tableName, where: "id = ?", whereArgs: [itemId]);
  }

  //FUll delete
  // Full delete - clears all rows safely
  Future<void> deleteFull() async {
    try {
      final db = await getDB();

      // Check if table exists before deleting
      await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        $id INTEGER PRIMARY KEY AUTOINCREMENT,
        $type INTEGER NOT NULL,
        $date TEXT NOT NULL,
        $title TEXT NOT NULL,
        $amount INTEGER NOT NULL,
        $notes TEXT,
        $paymentMethod TEXT NOT NULL,
        $icon TEXT NOT NULL,
        $categoryKey TEXT NOT NULL,
        $iconBgColor INTEGER NOT NULL
      )
    ''');

      await db.rawDelete('DELETE FROM $tableName');
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting all transactions: $e");
      }
    }
  }
}
