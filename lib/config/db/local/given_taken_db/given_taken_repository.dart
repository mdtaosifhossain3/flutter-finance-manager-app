import 'package:finance_manager_app/config/db/local/given_taken_db/given_taken_db_helper.dart';
import 'package:finance_manager_app/models/givenTakenModel/contact_lend_model.dart';
import 'package:finance_manager_app/models/givenTakenModel/lend_transaction_model.dart';

class GivenTakenRepository {
  final GivenTakenDbHelper _dbHelper = GivenTakenDbHelper();

  // ==================== CONTACTS ====================

  /// Create a new contact
  Future<int> createContact({
    required String name,
    String? phone,
    String? address,
    String? imagePath,
    int initialAmount = 0,
    String type = 'given',
  }) async {
    return await _dbHelper.createContact(
      name: name,
      phone: phone,
      address: address,
      imagePath: imagePath,
      initialAmount: initialAmount,
      type: type,
    );
  }

  /// Get all contacts
  Future<List<ContactLend>> getAllContacts() async {
    final maps = await _dbHelper.getAllContacts();
    return maps.map((map) => ContactLend.fromMap(map)).toList();
  }

  /// Get a specific contact by ID
  Future<ContactLend?> getContactById(int id) async {
    final map = await _dbHelper.getContactById(id);
    return map != null ? ContactLend.fromMap(map) : null;
  }

  /// Update a contact
  Future<int> updateContact({
    required int id,
    required String name,
    String? phone,
    String? address,
    String? imagePath,
  }) async {
    return await _dbHelper.updateContact(
      id: id,
      name: name,
      phone: phone,
      address: address,
      imagePath: imagePath,
    );
  }

  /// Delete a contact
  Future<int> deleteContact(int id) async {
    return await _dbHelper.deleteContact(id);
  }

  // ==================== TRANSACTIONS ====================

  /// Add a transaction
  Future<int> addTransaction({
    required int contactId,
    required String type,
    required int amount,
    required String date,
    String? note,
  }) async {
    return await _dbHelper.addTransaction(
      contactId: contactId,
      type: type,
      amount: amount,
      date: date,
      note: note,
    );
  }

  /// Get transactions by contact ID
  Future<List<LendTransaction>> getTransactionsByContact(int contactId) async {
    final maps = await _dbHelper.getTransactionsByContact(contactId);
    return maps.map((map) => LendTransaction.fromMap(map)).toList();
  }

  /// Get a specific transaction by ID
  Future<LendTransaction?> getTransactionById(int id) async {
    final map = await _dbHelper.getTransactionById(id);
    return map != null ? LendTransaction.fromMap(map) : null;
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
    return await _dbHelper.updateTransaction(
      id: id,
      contactId: contactId,
      type: type,
      amount: amount,
      date: date,
      note: note,
    );
  }

  /// Delete a transaction
  Future<int> deleteTransaction(int id, int contactId) async {
    return await _dbHelper.deleteTransaction(id, contactId);
  }

  /// Close database
  Future<void> closeDB() async {
    return await _dbHelper.closeDB();
  }
}
