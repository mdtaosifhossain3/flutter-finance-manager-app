import '../../../../models/noteModel/note_model.dart';
import 'notes_db_helper.dart';

class NotesRepository {
  final NotesDbHelper _dbHelper = NotesDbHelper.getInstance;

  /// Add a new note
  Future<bool> addNote(NoteModel note) async {
    return await _dbHelper.addNote(note);
  }

  /// Get all notes sorted by created_at DESC
  Future<List<NoteModel>> getAllNotes() async {
    final noteMaps = await _dbHelper.getAllNotes();
    return noteMaps.map((map) => NoteModel.fromMap(map)).toList();
  }

  /// Update an existing note
  Future<bool> updateNote(int id, NoteModel note) async {
    return await _dbHelper.updateNote(noteId: id, note: note);
  }

  /// Delete a note
  Future<int> deleteNote(int id) async {
    return await _dbHelper.deleteNote(id);
  }

  /// Clear all notes (for testing/reset)
  Future<void> clearAllNotes() async {
    return await _dbHelper.deleteFull();
  }

  /// Close database
  Future<void> closeDB() async {
    return await _dbHelper.closeDB();
  }
}
