import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../models/noteModel/note_model.dart';
import '../../../../services/uid_service.dart';

class NotesDbHelper {
  NotesDbHelper._();

  static final NotesDbHelper getInstance = NotesDbHelper._();

  Database? myDB;
  String? _currentUid;

  // Table column names
  final String id = 'id';
  final String content = 'content';
  final String createdAt = 'created_at';
  final String updatedAt = 'updated_at';

  /// Get table name with UID
  String get tableName {
    final uid = UidService.instance.getUidOrThrow();
    return 'notes_$uid';
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
    String dbPath = join(appDir.path, 'notes_$uid.db');

    final db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await _createTable(db, uid);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          final table = 'notes_$uid';
          try {
            await db.execute('ALTER TABLE $table ADD COLUMN image_path TEXT');
          } catch (e) {
            // Column might already exist
          }
        }
      },
    );

    return db;
  }

  /// Create the notes table
  Future<void> _createTable(Database db, String uid) async {
    final table = 'notes_$uid';
    await db.execute('''CREATE TABLE IF NOT EXISTS $table (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      content TEXT NOT NULL,
    image_path TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL)''');
  }

  /// Close the database
  Future<void> closeDB() async {
    if (myDB != null) {
      await myDB!.close();
      myDB = null;
    }
  }

  /// Insertion
  Future<bool> addNote(NoteModel note) async {
    var db = await getDB();
    int rowsEffected = await db.insert(tableName, note.toMap());
    return rowsEffected > 0;
  }

  /// Fetch All Data
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDB();
    List<Map<String, dynamic>> mData = await db.query(
      tableName,
      orderBy: '$createdAt DESC',
    );

    return mData;
  }

  /// Update
  Future<bool> updateNote({
    required int noteId,
    required NoteModel note,
  }) async {
    final db = await getDB();

    final rowsAffected = await db.update(
      tableName,
      note.toMapForUpdate(),
      where: '$id = ?',
      whereArgs: [noteId],
    );

    return rowsAffected > 0;
  }

  /// Delete one
  Future<int> deleteNote(int noteId) async {
    final db = await getDB();
    return await db.delete(tableName, where: "$id = ?", whereArgs: [noteId]);
  }

  /// Full delete - clears all rows safely
  Future<void> deleteFull() async {
    try {
      final db = await getDB();
      await db.rawDelete('DELETE FROM $tableName');
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting all notes: $e");
      }
    }
  }
}
