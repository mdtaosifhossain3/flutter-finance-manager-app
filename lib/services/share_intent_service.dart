import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Text shared into the app from another app (Android "Share" → Hishab
/// Rakhi), held by MainActivity until taken.
class ShareIntentService {
  static const _channel = MethodChannel('hishab_rakhi/share');

  /// Returns the shared text once, then null until something new is shared.
  static Future<String?> takeSharedText() async {
    try {
      final text = await _channel.invokeMethod<String>('takeSharedText');
      return (text == null || text.trim().isEmpty) ? null : text;
    } on MissingPluginException {
      return null;
    } catch (e) {
      debugPrint('ShareIntentService: $e');
      return null;
    }
  }
}
