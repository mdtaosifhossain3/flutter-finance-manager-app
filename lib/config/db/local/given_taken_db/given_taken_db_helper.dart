import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:finance_manager_app/services/uid_service.dart';

class GivenTakenDbHelper {
  static const int dbVersion = 2;

  // Table names (base)
  static const String _contactsTableBase = 'contacts_lend';
  static const String _transactionsTableBase = 'lend_transactions';

  // Contacts Table Columns
  static const String colId = 'id';
  static const String colName = 'name';
  static const String colPhone = 'phone';
  static const String colAddress = 'address';
  static const String colTotalGiven = 'total_given';
  static const String colTotalTaken = 'total_taken';
  static const String colBalance = 'balance';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';
  static const String colImagePath = 'image_path';

  // Transactions Table Columns
  static const String colContactId = 'contact_id';
  static const String colType = 'type'; // 'given' or 'taken'
  static const String colAmount = 'amount';
  static const String colDate = 'date';
  static const String colNote = 'note';

  // Singleton instance
  static final GivenTakenDbHelper _instance = GivenTakenDbHelper._internal();

  factory GivenTakenDbHelper() {
    return _instance;
  }

  GivenTakenDbHelper._internal();

  static Database? _database;
  String? _currentUid;

  /// Get contacts table name with UID
  String get contactsTable {
    final uid = UidService.instance.getUidOrThrow();
    return '${_contactsTableBase}_$uid';
  }

  /// Get transactions table name with UID
  String get transactionsTable {
    final uid = UidService.instance.getUidOrThrow();
    return '${_transactionsTableBase}_$uid';
  }

  Future<Database> get database async {
    final uid = UidService.instance.getUidOrThrow();

    // If UID changed, close current DB and open new one
    if (_currentUid != uid) {
      await closeDB();
      _currentUid = uid;
    }

    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final uid = UidService.instance.getUidOrThrow();
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'given_taken_$uid.db');

    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: (db, version) async {
        await _createTables(db, uid);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          final contacts = '${_contactsTableBase}_$uid';
          await db.execute(
            'ALTER TABLE $contacts ADD COLUMN $colImagePath TEXT',
          );
        }
      },
    );
  }

  /// Create given-taken tables
  Future<void> _createTables(Database db, String uid) async {
    final contacts = '${_contactsTableBase}_$uid';
    final transactions = '${_transactionsTableBase}_$uid';

    // Create contacts_lend table
    await db.execute('''
      CREATE TABLE $contacts (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colName TEXT NOT NULL,
        $colPhone TEXT,
        $colAddress TEXT,
        $colTotalGiven INTEGER DEFAULT 0,
        $colTotalTaken INTEGER DEFAULT 0,
        $colBalance INTEGER DEFAULT 0,
        $colCreatedAt TEXT NOT NULL,
        $colUpdatedAt TEXT NOT NULL,
        $colImagePath TEXT
      )
    ''');

    // Create lend_transactions table
    await db.execute('''
      CREATE TABLE $transactions (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colContactId INTEGER NOT NULL,
        $colType TEXT NOT NULL,
        $colAmount INTEGER NOT NULL,
        $colDate TEXT NOT NULL,
        $colNote TEXT,
        $colCreatedAt TEXT NOT NULL,
        FOREIGN KEY ($colContactId) REFERENCES $contacts ($colId) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better query performance
    await db.execute('''
      CREATE INDEX idx_contact_id_$uid ON $transactions ($colContactId)
    ''');

    await db.execute('''
      CREATE INDEX idx_transaction_date_$uid ON $transactions ($colDate)
    ''');

    if (kDebugMode) {
      print('Created given-taken tables for UID: $uid');
    }
  }

  /// Close database
  Future<void> closeDB() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  // ==================== CONTACTS CRUD ====================

  /// Create a new contact
  Future<int> createContact({
    required String name,
    String? phone,
    String? address,
    String? imagePath,
    int initialAmount = 0,
    String type = 'given', // 'given' or 'taken'
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    return await db.transaction((txn) async {
      // Insert contact
      final contactId = await txn.insert(contactsTable, {
        colName: name,
        colPhone: phone,
        colAddress: address,
        colImagePath: imagePath,
        colTotalGiven: type == 'given' ? initialAmount : 0,
        colTotalTaken: type == 'taken' ? initialAmount : 0,
        colBalance: type == 'given' ? initialAmount : -initialAmount,
        colCreatedAt: now,
        colUpdatedAt: now,
      });

      // If initial amount > 0, add a transaction
      if (initialAmount > 0) {
        await txn.insert(transactionsTable, {
          colContactId: contactId,
          colType: type,
          colAmount: initialAmount,
          colDate: now,
          colNote: '',
          colCreatedAt: now,
        });
      }

      return contactId;
    });
  }

  /// Get all contacts
  Future<List<Map<String, dynamic>>> getAllContacts() async {
    final db = await database;
    return await db.query(contactsTable, orderBy: '$colUpdatedAt DESC');
  }

  /// Get a specific contact by ID
  Future<Map<String, dynamic>?> getContactById(int id) async {
    final db = await database;
    final result = await db.query(
      contactsTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Update a contact
  Future<int> updateContact({
    required int id,
    required String name,
    String? phone,
    String? address,
    String? imagePath,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    return await db.update(
      contactsTable,
      {
        colName: name,
        colPhone: phone,
        colAddress: address,
        colImagePath: imagePath,
        colUpdatedAt: now,
      },
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  /// Delete a contact (cascade delete transactions)
  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete(contactsTable, where: '$colId = ?', whereArgs: [id]);
  }

  // ==================== TRANSACTIONS CRUD ====================

  /// Add a transaction
  Future<int> addTransaction({
    required int contactId,
    required String type, // 'given' or 'taken'
    required int amount,
    required String date,
    String? note,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    return await db.transaction((txn) async {
      // Insert transaction
      final txnId = await txn.insert(transactionsTable, {
        colContactId: contactId,
        colType: type,
        colAmount: amount,
        colDate: date,
        colNote: note,
        colCreatedAt: now,
      });

      // Update contact totals and balance
      await _updateContactBalance(txn, contactId);

      return txnId;
    });
  }

  /// Get transactions by contact ID
  Future<List<Map<String, dynamic>>> getTransactionsByContact(
    int contactId,
  ) async {
    final db = await database;
    return await db.query(
      transactionsTable,
      where: '$colContactId = ?',
      whereArgs: [contactId],
      orderBy: '$colDate DESC, $colCreatedAt DESC',
    );
  }

  /// Get a specific transaction by ID
  Future<Map<String, dynamic>?> getTransactionById(int id) async {
    final db = await database;
    final result = await db.query(
      transactionsTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Update a transaction
  Future<int> updateTransaction({
    required int id,
    required int contactId,
    required String type,
    required int amount,
    required String date,
    String? note,
  }) async {
    final db = await database;

    return await db.transaction((txn) async {
      // Update transaction
      final count = await txn.update(
        transactionsTable,
        {colType: type, colAmount: amount, colDate: date, colNote: note},
        where: '$colId = ?',
        whereArgs: [id],
      );

      // Update contact totals and balance
      await _updateContactBalance(txn, contactId);

      return count;
    });
  }

  /// Delete a transaction
  Future<int> deleteTransaction(int id, int contactId) async {
    final db = await database;

    return await db.transaction((txn) async {
      // Delete transaction
      final count = await txn.delete(
        transactionsTable,
        where: '$colId = ?',
        whereArgs: [id],
      );

      // Update contact totals and balance
      await _updateContactBalance(txn, contactId);

      return count;
    });
  }

  /// Helper to recalculate and update contact balance
  Future<void> _updateContactBalance(Transaction txn, int contactId) async {
    final now = DateTime.now().toIso8601String();

    // Sum all 'given' transactions
    final givenResult = await txn.rawQuery(
      'SELECT SUM($colAmount) as total FROM $transactionsTable WHERE $colContactId = ? AND $colType = ?',
      [contactId, 'given'],
    );
    final totalGiven = (givenResult.first['total'] as num?)?.toInt() ?? 0;

    // Sum all 'taken' transactions
    final takenResult = await txn.rawQuery(
      'SELECT SUM($colAmount) as total FROM $transactionsTable WHERE $colContactId = ? AND $colType = ?',
      [contactId, 'taken'],
    );
    final totalTaken = (takenResult.first['total'] as num?)?.toInt() ?? 0;

    final balance = totalGiven - totalTaken;

    await txn.update(
      contactsTable,
      {
        colTotalGiven: totalGiven,
        colTotalTaken: totalTaken,
        colBalance: balance,
        colUpdatedAt: now,
      },
      where: '$colId = ?',
      whereArgs: [contactId],
    );
  }

  /// Delete all data for the current user
  Future<void> deleteFullData() async {
    final db = await database;
    await db.delete(transactionsTable);
    await db.delete(contactsTable);
  }
}
