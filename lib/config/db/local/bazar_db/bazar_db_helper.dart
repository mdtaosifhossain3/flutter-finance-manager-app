import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../models/bazarModel/bazar_item_model.dart';
import '../../../../services/uid_service.dart';

class BazarDbHelper {
  BazarDbHelper._();

  static final BazarDbHelper getInstance = BazarDbHelper._();

  Database? myDB;
  String? _currentUid;

  String get tableName {
    final uid = UidService.instance.getUidOrThrow();
    return 'bazar_$uid';
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
    String dbPath = join(appDir.path, 'bazar_$uid.db');

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE IF NOT EXISTS bazar_$uid (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          quantity TEXT NOT NULL DEFAULT '',
          last_price INTEGER NOT NULL DEFAULT 0,
          previous_price INTEGER NOT NULL DEFAULT 0,
          current_price INTEGER,
          updated_at TEXT NOT NULL)''');
      },
    );
  }

  Future<void> closeDB() async {
    if (myDB != null) {
      await myDB!.close();
      myDB = null;
    }
  }

  Future<List<BazarItem>> getAllItems() async {
    final db = await getDB();
    final rows = await db.query(tableName, orderBy: 'name COLLATE NOCASE');
    return rows.map(BazarItem.fromMap).toList();
  }

  Future<int> addItem(BazarItem item) async {
    final db = await getDB();
    return db.insert(tableName, item.toMap());
  }

  Future<void> updateItem(BazarItem item) async {
    final db = await getDB();
    await db.update(
      tableName,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteItem(int id) async {
    final db = await getDB();
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  /// Ends a shopping trip: each bought item's price becomes its last price
  /// and the item is unticked for next time.
  Future<void> finishTrip() async {
    final db = await getDB();
    await db.rawUpdate(
      '''UPDATE $tableName SET
        previous_price = last_price,
        last_price = current_price,
        current_price = NULL,
        updated_at = ?
      WHERE current_price IS NOT NULL''',
      [DateTime.now().toIso8601String()],
    );
  }

  Future<void> deleteFull() async {
    final db = await getDB();
    await db.delete(tableName);
  }
}
