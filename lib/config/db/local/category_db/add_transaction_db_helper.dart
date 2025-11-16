import 'dart:io';

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
  final String iconCodePoint = 'iconCodePoint';
  final String iconFontFamily = 'iconFontFamily';
  final String iconBgColor = 'iconBgColor';
  final String categoryKey = 'categoryKey';

  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, 'transaction_data.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $tableName (
          $id INTEGER PRIMARY KEY AUTOINCREMENT,
          $type INTEGER NOT NULL,
          $date TEXT NOT NULL,
          $title TEXT NOT NULL,
          $amount INTEGER NOT NULL,
          $notes TEXT,
          $paymentMethod TEXT NOT NULL,
          $iconCodePoint INTEGER NOT NULL,
          $iconFontFamily TEXT NOT NULL,
          $categoryKey TEXT NOT NULL,
          $iconBgColor INTEGER NOT NULL)''');
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

  //delete
  Future<int> deleteItem(int itemId) async {
    final db = await getDB();
    return await db.delete(tableName, where: "id = ?", whereArgs: [itemId]);
  }
}
