import 'package:shared_preferences/shared_preferences.dart';

class ProTapService {
  static const String _key = "proTapCount";

  // Load stored count
  static Future<int> getTapCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 0;
  }

  // Increase count
  static Future<int> incrementTap() async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt(_key) ?? 0;
    current++;
    await prefs.setInt(_key, current);
    return current;
  }

  // Reset count (optional)
  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_key);
  }
}
