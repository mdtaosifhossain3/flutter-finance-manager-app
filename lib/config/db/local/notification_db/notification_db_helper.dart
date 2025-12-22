import 'package:finance_manager_app/models/notificationModel/notification_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../../../services/uid_service.dart';

class NotificationDbHelper {
  static final NotificationDbHelper _instance =
      NotificationDbHelper._internal();
  factory NotificationDbHelper() => _instance;
  NotificationDbHelper._internal();

  static Database? _db;
  String? _currentUid;

  /// Get table name with UID
  String get tableName {
    final uid = UidService.instance.getUidOrThrow();
    return 'notifications_$uid';
  }

  Future<Database> get database async {
    final uid = UidService.instance.getUidOrThrow();

    // If UID changed, close current DB and open new one
    if (_currentUid != uid) {
      await closeDB();
      _currentUid = uid;
    }

    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final uid = UidService.instance.getUidOrThrow();
    final path = join(await getDatabasesPath(), 'notifications_$uid.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createTable(db, uid);
      },
    );
  }

  /// Create the notifications table
  Future<void> _createTable(Database db, String uid) async {
    final table = 'notifications_$uid';
    await db.execute('''
      CREATE TABLE $table(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        body TEXT,
        date TEXT,
        isWeekly INTEGER
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

  Future<void> insertNotification(NotificationModel notification) async {
    final db = await database;
    await db.insert(
      tableName,
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NotificationModel>> getAllNotifications() async {
    final db = await database;
    final maps = await db.query(tableName, orderBy: 'date DESC');
    return maps.map((e) => NotificationModel.fromMap(e)).toList();
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete(tableName);
  }
}
