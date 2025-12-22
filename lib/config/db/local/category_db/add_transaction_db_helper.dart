import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../models/categoryModel/transaction_model.dart';
import '../../../../services/uid_service.dart';

class AddTransactionDbHelper {
  AddTransactionDbHelper._();

  static final AddTransactionDbHelper getInstance = AddTransactionDbHelper._();

  Database? myDB;
  String? _currentUid;

  // Table column names
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

  /// Get table name with UID
  String get tableName {
    final uid = UidService.instance.getUidOrThrow();
    return 'transaction_data_$uid';
  }

  Future<Database> getDB() async {
    final uid = UidService.instance.getUidOrThrow();

    // If UID changed, close current DB and open new one
    if (_currentUid != uid) {
      await closeDB();
      _currentUid = uid;
    }

    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    final uid = UidService.instance.getUidOrThrow();
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, 'transaction_data_$uid.db');

    final db = await openDatabase(
      dbPath,
      version: 2,
      onCreate: (db, version) async {
        await _createTable(db, uid);
      },
    );

    return db;
  }

  /// Create the transaction table
  Future<void> _createTable(Database db, String uid) async {
    final table = 'transaction_data_$uid';
    await db.execute('''CREATE TABLE $table (
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
  }

  /// Close the database
  Future<void> closeDB() async {
    if (myDB != null) {
      await myDB!.close();
      myDB = null;
    }
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
      await db.rawDelete('DELETE FROM $tableName');
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting all transactions: $e");
      }
    }
  }
}
