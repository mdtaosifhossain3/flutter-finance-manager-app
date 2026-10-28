import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:finance_manager_app/services/analytics/analytics_service.dart';
import 'package:finance_manager_app/views/mainView/main_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Handles the deep link redirect from BDApps bKash subscription flow.
///
/// After the user completes/cancels bKash subscription in the browser,
/// BDApps redirects to [finzycash://bkash/callback?StatusCode=Sxxxx].
/// This service intercepts that URI and acts accordingly.
class BkashDeepLinkHandler {
  static final BkashDeepLinkHandler _instance =
      BkashDeepLinkHandler._internal();
  factory BkashDeepLinkHandler() => _instance;
  BkashDeepLinkHandler._internal();

  static BkashDeepLinkHandler get instance => _instance;

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;

  bool _initialized = false;

  /// Initialize the handler. Call once from [main.dart] after app builds.
  Future<void> initialize(BuildContext context) async {
    if (_initialized) return;
    _initialized = true;

    // Handle cold-start link (app was not running when link tapped)
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleUri(initialUri);
      }
    } catch (_) {}

    // Handle warm/hot link (app already running in background)
    _subscription = _appLinks.uriLinkStream.listen(_handleUri);
  }

  /// Cancel stream subscription
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _initialized = false;
  }

  void _handleUri(Uri uri) {
    // Only handle our bKash callback
    if (uri.scheme != 'finzycash' ||
        uri.host != 'bkash' ||
        !uri.path.startsWith('/callback')) {
      return;
    }

    debugPrint('=== bKash Deep Link Received ===');
    debugPrint('URI: $uri');

    final statusCode = uri.queryParameters['StatusCode'] ?? '';
    debugPrint('StatusCode: $statusCode');

    if (statusCode == 'S1000') {
      _onSuccess();
    } else {
      _onFailure(statusCode);
    }
  }

  Future<void> _onSuccess() async {
    await AnalyticsService.instance.logLogin(method: 'bKash');

    // Navigate to main app
    Get.offAll(() => const MainView());

    // Show success snackbar after navigation
    final navCtx = Get.context;
    if (navCtx != null && navCtx.mounted) {
      ScaffoldMessenger.of(navCtx).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'bKash subscription activated!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF2E7D32),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _onFailure(String statusCode) {
    debugPrint('bKash subscription failed. StatusCode: $statusCode');

    final ctx = Get.context;
    if (ctx != null && ctx.mounted) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _errorMessage(statusCode),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFC62828),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  String _errorMessage(String code) {
    switch (code) {
      case 'E1006':
        return 'bKash subscription cancelled.';
      case 'E1004':
        return 'Request timed out. Please try again.';
      case 'E1003':
        return 'Already subscribed via bKash.';
      default:
        return 'bKash subscription failed (Code: $code). Please try again.';
    }
  }
}
