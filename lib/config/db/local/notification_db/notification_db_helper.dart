import 'package:finance_manager_app/models/notificationModel/notification_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotificationDbHelper {
  static final NotificationDbHelper _instance =
      NotificationDbHelper._internal();
  factory NotificationDbHelper() => _instance;
  NotificationDbHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'notifications.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notifications(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            body TEXT,
            date TEXT,
            isWeekly INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertNotification(NotificationModel notification) async {
    final db = await database;
    await db.insert(
      'notifications',
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NotificationModel>> getAllNotifications() async {
    final db = await database;
    final maps = await db.query('notifications', orderBy: 'date DESC');
    return maps.map((e) => NotificationModel.fromMap(e)).toList();
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete('notifications');
  }
}
