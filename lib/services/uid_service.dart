import 'package:shared_preferences/shared_preferences.dart';

/// Singleton service to manage user UID access across the app
/// Provides cached UID retrieval for database operations
class UidService {
  UidService._();

  static final UidService instance = UidService._();

  String? _cachedUid;

  /// Initialize the UID service by loading UID from SharedPreferences
  /// Should be called early in app startup
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedUid = prefs.getString('user_uid');
  }

  /// Get the current user's UID
  /// Returns null if user is not logged in
  String? get uid => _cachedUid;

  /// Update the cached UID (call this after login/register)
  Future<void> setUid(String uid) async {
    _cachedUid = uid;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_uid', uid);
  }

  /// Clear the cached UID (call this after logout)
  Future<void> clearUid() async {
    _cachedUid = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_uid');
  }

  /// Check if user is logged in
  bool get isLoggedIn => _cachedUid != null && _cachedUid!.isNotEmpty;

  /// Get UID or throw exception if not available
  /// Use this in database helpers to ensure UID is always available
  String getUidOrThrow() {
    if (_cachedUid == null || _cachedUid!.isEmpty) {
      throw Exception('User UID not available. User must be logged in.');
    }
    return _cachedUid!;
  }
}
