import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../models/recurringModel/recurring_item_model.dart';
import '../../../../services/uid_service.dart';

class RecurringDbHelper {
  RecurringDbHelper._();

  static final RecurringDbHelper getInstance = RecurringDbHelper._();

  Database? myDB;
  String? _currentUid;

  String get tableName {
    final uid = UidService.instance.getUidOrThrow();
    return 'recurring_$uid';
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
    String dbPath = join(appDir.path, 'recurring_$uid.db');

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE IF NOT EXISTS recurring_$uid (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          amount INTEGER NOT NULL,
          is_income INTEGER NOT NULL DEFAULT 0,
          category_key TEXT NOT NULL,
          payment_method TEXT NOT NULL,
          frequency TEXT NOT NULL,
          day INTEGER NOT NULL,
          next_date TEXT NOT NULL,
          auto_add INTEGER NOT NULL DEFAULT 0)''');
      },
    );
  }

  Future<void> closeDB() async {
    if (myDB != null) {
      await myDB!.close();
      myDB = null;
    }
  }

  Future<List<RecurringItem>> getAll() async {
    final db = await getDB();
    final rows = await db.query(tableName, orderBy: 'next_date');
    return rows.map(RecurringItem.fromMap).toList();
  }

  Future<int> insert(RecurringItem item) async {
    final db = await getDB();
    return db.insert(tableName, item.toMap());
  }

  Future<void> update(RecurringItem item) async {
    final db = await getDB();
    await db.update(
      tableName,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await getDB();
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteFull() async {
    final db = await getDB();
    await db.delete(tableName);
  }
}
