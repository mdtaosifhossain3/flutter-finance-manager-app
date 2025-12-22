import 'package:flutter/foundation.dart';
import '../../config/db/local/notes_db/notes_repository.dart';
import '../../models/noteModel/note_model.dart';

class NotesProvider with ChangeNotifier {
  final NotesRepository _repository = NotesRepository();

  // State variables
  List<NoteModel> _notes = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<NoteModel> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ==================== LIFECYCLE ====================

  /// Load all notes
  Future<void> loadNotes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notes = await _repository.getAllNotes();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // ==================== NOTES CRUD ====================

  /// Add a new note
  Future<bool> addNote(NoteModel note) async {
    try {
      _error = null;
      final success = await _repository.addNote(note);

      if (success) {
        // Reload notes after creation
        await loadNotes();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Get a specific note by ID
  NoteModel? getNoteById(int id) {
    try {
      return _notes.firstWhere((n) => n.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Update a note
  Future<bool> updateNote(int id, NoteModel note) async {
    try {
      _error = null;
      final success = await _repository.updateNote(id, note);

      if (success) {
        // Reload notes after update
        await loadNotes();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Delete a note
  Future<int> deleteNote(int id) async {
    try {
      _error = null;
      final result = await _repository.deleteNote(id);

      if (result > 0) {
        // Remove from local list
        _notes.removeWhere((n) => n.id == id);
        notifyListeners();
      }
      return result;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // ==================== UTILITY METHODS ====================

  /// Clear all notes (for testing/reset)
  Future<void> clearAllNotes() async {
    try {
      _error = null;
      await _repository.clearAllNotes();
      _notes.clear();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
