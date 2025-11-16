import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ReminderDbHelper {
  static late Database db;

  //init
  static Future<void> initDB() async {
    final dbPath = await getDatabasesPath();

    db = await openDatabase(
      join(dbPath, 'reminders.db'),

      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE reminders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        body TEXT,
        isActive INTEGER,
        remindersTime TEXT
      )''');
      },
      version: 1,
    );
  }

  //Get Reminders
  static Future<List<Map<String, dynamic>>> getReminders() async {
    return await db.query('reminders');
  }

  //Fetch by id. it can be null
  static Future<Map<String, dynamic>?> getRemindersByID(int id) async {
    final List<Map<String, dynamic>> results = await db.query(
      "reminders",
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
    return await db.insert('reminders', reminder);
  }

  //update Reminder
  static Future<int> updateReminder(
    int id,
    Map<String, dynamic> reminder,
  ) async {
    return await db.update(
      'reminders',
      reminder,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  //Delete Reminder

  static Future<int> deleteReminder(int id) async {
    return await db.delete('reminders', where: "id = ?", whereArgs: [id]);
  }

  //Toggle Reminder
  static Future<int> toggleReminder(int id, bool isActive) async {
    return await db.update(
      'reminders',
      {'isActive': isActive ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
