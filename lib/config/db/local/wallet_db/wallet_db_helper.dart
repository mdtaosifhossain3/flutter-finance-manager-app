import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../models/walletModel/wallet_models.dart';
import '../../../../services/uid_service.dart';

class WalletDbHelper {
  WalletDbHelper._();

  static final WalletDbHelper getInstance = WalletDbHelper._();

  Database? myDB;
  String? _currentUid;

  String get _uid => UidService.instance.getUidOrThrow();
  String get openingTable => 'wallet_opening_$_uid';
  String get transferTable => 'wallet_transfer_$_uid';

  Future<Database> getDB() async {
    final uid = _uid;

    // If UID changed, close current DB and open new one
    if (_currentUid != uid) {
      await closeDB();
      _currentUid = uid;
    }

    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    final uid = _uid;
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, 'wallet_$uid.db');

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE IF NOT EXISTS wallet_opening_$uid (
          method TEXT PRIMARY KEY,
          opening INTEGER NOT NULL DEFAULT 0)''');
        await db.execute('''CREATE TABLE IF NOT EXISTS wallet_transfer_$uid (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          from_method TEXT NOT NULL,
          to_method TEXT NOT NULL,
          amount INTEGER NOT NULL,
          fee INTEGER NOT NULL DEFAULT 0,
          fee_tx_id INTEGER,
          date TEXT NOT NULL,
          note TEXT NOT NULL DEFAULT '')''');
      },
    );
  }

  Future<void> closeDB() async {
    if (myDB != null) {
      await myDB!.close();
      myDB = null;
    }
  }

  Future<Map<String, int>> getOpenings() async {
    final db = await getDB();
    final rows = await db.query(openingTable);
    return {for (final r in rows) r['method'] as String: r['opening'] as int};
  }

  Future<void> setOpening(String method, int opening) async {
    final db = await getDB();
    await db.insert(openingTable, {
      'method': method,
      'opening': opening,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeWallet(String method) async {
    final db = await getDB();
    await db.delete(openingTable, where: 'method = ?', whereArgs: [method]);
  }

  Future<List<WalletTransfer>> getTransfers() async {
    final db = await getDB();
    final rows = await db.query(transferTable, orderBy: 'date DESC');
    return rows.map(WalletTransfer.fromMap).toList();
  }

  Future<int> addTransfer(WalletTransfer t) async {
    final db = await getDB();
    return db.insert(transferTable, t.toMap());
  }

  Future<void> deleteTransfer(int id) async {
    final db = await getDB();
    await db.delete(transferTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteFull() async {
    final db = await getDB();
    await db.delete(openingTable);
    await db.delete(transferTable);
  }
}
