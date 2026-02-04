import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../services/uid_service.dart';

class ReminderDbHelper {
  static Database? db;
  static String? _currentUid;

  /// Get table name with UID
  static String get tableName {
    final uid = UidService.instance.getUidOrThrow();
    return 'reminders_$uid';
  }

  //init
  static Future<void> initDB() async {
    final uid = UidService.instance.getUidOrThrow();

    // If UID changed, close current DB and open new one
    if (_currentUid != uid) {
      await closeDB();
      _currentUid = uid;
    }

    if (db != null) return;

    final dbPath = await getDatabasesPath();

    db = await openDatabase(
      join(dbPath, 'reminders_$uid.db'),
      onCreate: (db, version) async {
        await _createTable(db, uid);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE $tableName ADD COLUMN isRepeating INTEGER DEFAULT 0',
          );
        }
      },
      version: 2,
    );
  }

  /// Create the reminders table
  static Future<void> _createTable(Database db, String uid) async {
    final table = 'reminders_$uid';
    await db.execute('''
      CREATE TABLE $table(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        body TEXT,
        isActive INTEGER,
        remindersTime TEXT,
        isRepeating INTEGER DEFAULT 0
      )''');
  }

  /// Close the database
  static Future<void> closeDB() async {
    if (db != null) {
      await db!.close();
      db = null;
    }
  }

  //Get Reminders
  static Future<List<Map<String, dynamic>>> getReminders() async {
    if (db == null) await initDB();
    return await db!.query(tableName);
  }

  //Fetch by id. it can be null
  static Future<Map<String, dynamic>?> getRemindersByID(int id) async {
    if (db == null) await initDB();
    final List<Map<String, dynamic>> results = await db!.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  //Add Reminder
  static Future<int> addReminder(Map<String, dynamic> reminder) async {
    if (db == null) await initDB();
    return await db!.insert(tableName, reminder);
  }

  //update Reminder
  static Future<int> updateReminder(
    int id,
    Map<String, dynamic> reminder,
  ) async {
    if (db == null) await initDB();
    return await db!.update(
      tableName,
      reminder,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  //Delete Reminder

  static Future<int> deleteReminder(int id) async {
    if (db == null) await initDB();
    return await db!.delete(tableName, where: "id = ?", whereArgs: [id]);
  }

  //Toggle Reminder
  static Future<int> toggleReminder(int id, bool isActive) async {
    if (db == null) await initDB();
    return await db!.update(
      tableName,
      {'isActive': isActive ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Full delete - clears all rows safely
  static Future<void> deleteFull() async {
    try {
      await initDB();
      await db!.rawDelete('DELETE FROM $tableName');
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting all notes: $e");
      }
    }
  }
}
