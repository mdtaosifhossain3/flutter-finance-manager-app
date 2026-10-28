import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  AnalyticsService._internal();
  static final AnalyticsService instance = AnalyticsService._internal();

  final FacebookAppEvents _facebookAppEvents = FacebookAppEvents();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      await _facebookAppEvents.setAutoLogAppEventsEnabled(true);
      _initialized = true;
      debugPrint("Facebook App Events initialized");
    } catch (e) {
      debugPrint("Facebook App Events init failed: $e");
    }
  }

  bool get isInitialized => _initialized;

  Future<void> logLogin({String method = 'Mobile'}) async {
    try {
      await _facebookAppEvents.logEvent(
        name: 'login',
        parameters: {'method': method},
      );
      debugPrint("Logged Login Event: $method");
    } catch (e) {
      debugPrint("Failed to log Login Event: $e");
    }
  }

  Future<void> logRegistration({
    required double valueToSum,
    required String currency,
  }) async {
    try {
      await _facebookAppEvents.logEvent(
        name: 'fb_mobile_complete_registration',
        parameters: {
          'method': "Mobile",
          'fb_currency': currency,
          '_valueToSum': valueToSum,
        },
        valueToSum: valueToSum,
      );
      debugPrint(
        "Logged Registration Event: Value: $valueToSum, Currency: $currency",
      );
    } catch (e) {
      debugPrint("Failed to log Registration Event: $e");
    }
  }
}
