import 'dart:convert';
import 'dart:math' as math;
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

/// BDApps bKash Subscription SDK Service
/// Reference: https://bdappsandroid.com/bdapps_bkash.html
///
/// Per the BDApps bKash flow update, passing &msisdn=01XXXXXXXXX&paymentOption=bKash
/// in the authorization URL skips the intermediate payment selection screen and
/// lands the user directly on the bKash PGW (Payment Gateway) page.
class BkashSubscriptionService {
  static const String _authEndpoint =
      'https://user.bdapps.com/sdk/subscription/authorize';

  // Payment option is always bKash — hardcoded, no Robi/Airtel.
  static const String _paymentOption = 'bKash';

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Generates a unique 15-digit request ID (YYMMDDHHmmss + 3 random digits).
  static String generateRequestId() {
    final now = DateTime.now().toUtc();
    final base =
        '${(now.year % 100).toString().padLeft(2, '0')}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}'
        '${now.second.toString().padLeft(2, '0')}'; // 12 digits
    final random = (100 + math.Random().nextInt(900)).toString(); // 3 digits
    return '$base$random'; // exactly 15 digits
  }

  /// Formats a DateTime as BDApps-compatible ISO-8601 UTC string with milliseconds.
  static String formatRequestTime(DateTime utcTime) {
    return '${utcTime.year.toString().padLeft(4, '0')}'
        '-${utcTime.month.toString().padLeft(2, '0')}'
        '-${utcTime.day.toString().padLeft(2, '0')}'
        'T${utcTime.hour.toString().padLeft(2, '0')}'
        ':${utcTime.minute.toString().padLeft(2, '0')}'
        ':${utcTime.second.toString().padLeft(2, '0')}'
        '.${utcTime.millisecond.toString().padLeft(3, '0')}Z';
  }

  /// SHA-512 signature: SHA512(apiKey + "|" + requestTime + "|" + apiSecret).
  static String generateSignature({
    required String apiKey,
    required String requestTime,
    required String apiSecret,
  }) {
    final source = '$apiKey|$requestTime|$apiSecret';
    return sha512.convert(utf8.encode(source)).toString().toLowerCase();
  }

  /// Normalizes a BD mobile number to 11-digit format (01XXXXXXXXX).
  /// Strips non-digits and removes leading '+88' / '88' prefixes.
  static String normalizeMsisdn(String raw) {
    var clean = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.startsWith('8801') && clean.length == 13) {
      clean = clean.substring(2); // drop country code
    }
    return clean;
  }

  // ── Core ───────────────────────────────────────────────────────────────────

  /// Builds the BDApps bKash authorization URL.
  ///
  /// [msisdn] is **required** — the user's bKash-registered 11-digit mobile
  /// number (e.g. 01899001122). Together with the hardcoded paymentOption=bKash
  /// it lands the user directly on the bKash PGW page, skipping all
  /// intermediate screens.
  ///
  /// NOTE: Call this freshly every time — never cache the result. The
  /// requestTime is only valid for ~10 minutes server-side.
  static Uri buildAuthorizationUri({
    required String msisdn,
    String? apiKey,
    String? apiSecret,
    String? redirectUrl,
  }) {
    final key =
        (apiKey ?? dotenv.env['BDAPPS_BKASH_API_KEY'] ?? 'YOUR_BDAPPS_API_KEY')
            .trim();
    final secret =
        (apiSecret ??
                dotenv.env['BDAPPS_BKASH_API_SECRET'] ??
                'YOUR_BDAPPS_API_SECRET')
            .trim();
    final redirect =
        (redirectUrl ??
                dotenv.env['BDAPPS_BKASH_REDIRECT_URL'] ??
                'https://bdappsandroid.com/subscription-return')
            .trim();

    final now = DateTime.now().toUtc();
    final requestId = generateRequestId();
    final requestTime = formatRequestTime(now);
    final signature = generateSignature(
      apiKey: key,
      requestTime: requestTime,
      apiSecret: secret,
    );

    final normalizedMsisdn = normalizeMsisdn(msisdn);

    final queryParams = <String, String>{
      'apiKey': key,
      'requestId': requestId,
      'requestTime': requestTime,
      'signature': signature,
      'redirectUrl': redirect,
      // Direct bKash PGW — skips the payment-method selection layer entirely.
      'msisdn': normalizedMsisdn,
      'paymentOption': _paymentOption,
    };

    final uri = Uri.parse(_authEndpoint).replace(queryParameters: queryParams);

    debugPrint('=== BDApps bKash Auth ===');
    debugPrint('msisdn       : $normalizedMsisdn');
    debugPrint('paymentOption: $_paymentOption');
    debugPrint('requestId    : $requestId');
    debugPrint('requestTime  : $requestTime');
    debugPrint('Full URI     : $uri');

    return uri;
  }

  /// Launches the bKash PGW authorization page in the device browser.
  ///
  /// [msisdn] is **required**. The user is sent straight to the bKash PGW
  /// screen — no intermediate payment-option selector.
  static Future<bool> launchSubscription({
    required String msisdn,
    String? apiKey,
    String? apiSecret,
    String? redirectUrl,
  }) async {
    try {
      final uri = buildAuthorizationUri(
        msisdn: msisdn,
        apiKey: apiKey,
        apiSecret: apiSecret,
        redirectUrl: redirectUrl,
      );

      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error launching bKash subscription: $e');
      return false;
    }
  }
}
