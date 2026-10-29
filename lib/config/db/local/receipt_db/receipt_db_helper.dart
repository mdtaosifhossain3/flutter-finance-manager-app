import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../models/receiptModel/receipt_model.dart';
import '../../../../services/uid_service.dart';

/// Receipt photos and what was read from them, one row per transaction.
/// The photo files live in `<documents>/receipts/<uid>/`.
class ReceiptDbHelper {
  ReceiptDbHelper._();

  static final ReceiptDbHelper getInstance = ReceiptDbHelper._();

  Database? myDB;
  String? _currentUid;

  String get tableName {
    final uid = UidService.instance.getUidOrThrow();
    return 'receipts_$uid';
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
    String dbPath = join(appDir.path, 'receipts_$uid.db');

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE IF NOT EXISTS receipts_$uid (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          transaction_id INTEGER NOT NULL,
          image_path TEXT NOT NULL,
          image_hash TEXT NOT NULL,
          merchant TEXT,
          amount INTEGER NOT NULL,
          date TEXT NOT NULL,
          raw_text TEXT,
          created_at TEXT NOT NULL)''');
        await db.execute(
          'CREATE INDEX idx_receipts_tx_$uid ON receipts_$uid (transaction_id)',
        );
      },
    );
  }

  Future<void> closeDB() async {
    if (myDB != null) {
      await myDB!.close();
      myDB = null;
    }
  }

  /// Folder for this user's receipt photos.
  Future<Directory> imageDir() async {
    final uid = UidService.instance.getUidOrThrow();
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory(join(appDir.path, 'receipts', uid));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<List<ReceiptModel>> getAll() async {
    final db = await getDB();
    final rows = await db.query(tableName, orderBy: 'date DESC');
    return rows.map(ReceiptModel.fromMap).toList();
  }

  Future<ReceiptModel?> getByTransaction(int transactionId) async {
    final db = await getDB();
    final rows = await db.query(
      tableName,
      where: 'transaction_id = ?',
      whereArgs: [transactionId],
      limit: 1,
    );
    return rows.isEmpty ? null : ReceiptModel.fromMap(rows.first);
  }

  Future<int> insert(ReceiptModel receipt) async {
    final db = await getDB();
    return db.insert(tableName, receipt.toMap());
  }

  /// Removes the receipt of a deleted transaction and its photo.
  Future<void> deleteByTransaction(int transactionId) async {
    final receipt = await getByTransaction(transactionId);
    if (receipt == null) return;
    final db = await getDB();
    await db.delete(
      tableName,
      where: 'transaction_id = ?',
      whereArgs: [transactionId],
    );
    final file = File(receipt.imagePath);
    if (await file.exists()) await file.delete();
  }

  /// Clears every receipt and photo (used with "delete all transactions").
  Future<void> deleteAll() async {
    final db = await getDB();
    await db.delete(tableName);
    final dir = await imageDir();
    if (await dir.exists()) await dir.delete(recursive: true);
  }
}
