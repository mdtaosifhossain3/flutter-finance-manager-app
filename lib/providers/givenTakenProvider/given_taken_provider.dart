import 'package:flutter/foundation.dart';
import 'package:finance_manager_app/config/db/local/given_taken_db/given_taken_repository.dart';
import 'package:finance_manager_app/models/givenTakenModel/contact_lend_model.dart';
import 'package:finance_manager_app/models/givenTakenModel/lend_transaction_model.dart';

class GivenTakenProvider with ChangeNotifier {
  final GivenTakenRepository _repository = GivenTakenRepository();

  // State variables
  List<ContactLend> _contacts = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ContactLend> get contacts => _contacts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Total amount the user will get (positive balance)
  int get totalWillGet {
    return _contacts
        .where((c) => c.balance > 0)
        .fold(0, (sum, c) => sum + c.balance);
  }

  /// Total amount the user needs to pay (negative balance)
  int get totalNeedToPay {
    return _contacts
        .where((c) => c.balance < 0)
        .fold(0, (sum, c) => sum + c.balance.abs());
  }

  // ==================== CONTACTS ====================

  /// Load all contacts
  Future<void> loadContacts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _contacts = await _repository.getAllContacts();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create a new contact
  Future<int> createContact({
    required String name,
    String? phone,
    String? address,
    String? imagePath,
    int initialAmount = 0,
    String type = 'given',
  }) async {
    try {
      final id = await _repository.createContact(
        name: name,
        phone: phone,
        address: address,
        imagePath: imagePath,
        initialAmount: initialAmount,
        type: type,
      );
      await loadContacts();
      return id;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Update a contact
  Future<void> updateContact({
    required int id,
    required String name,
    String? phone,
    String? address,
    String? imagePath,
  }) async {
    try {
      await _repository.updateContact(
        id: id,
        name: name,
        phone: phone,
        address: address,
        imagePath: imagePath,
      );
      await loadContacts();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Delete a contact
  Future<void> deleteContact(int id) async {
    try {
      await _repository.deleteContact(id);
      _contacts.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
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
    try {
      final id = await _repository.addTransaction(
        contactId: contactId,
        type: type,
        amount: amount,
        date: date,
        note: note,
      );
      await loadContacts(); // Reload to update contact balance
      return id;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Get transactions for a contact
  Future<List<LendTransaction>> getTransactionsByContact(int contactId) async {
    try {
      return await _repository.getTransactionsByContact(contactId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Update a transaction
  Future<void> updateTransaction({
    required int id,
    required int contactId,
    required String type,
    required int amount,
    required String date,
    String? note,
  }) async {
    try {
      await _repository.updateTransaction(
        id: id,
        contactId: contactId,
        type: type,
        amount: amount,
        date: date,
        note: note,
      );
      await loadContacts();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Delete a transaction
  Future<void> deleteTransaction(int id, int contactId) async {
    try {
      await _repository.deleteTransaction(id, contactId);
      await loadContacts();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Delete all data for the current user
  Future<void> deleteFullData() async {
    try {
      await _repository.deleteFullData();
      _contacts.clear();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
