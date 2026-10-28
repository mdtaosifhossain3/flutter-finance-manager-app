import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:finance_manager_app/services/uid_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for authentication flow.
/// Uses BDApps subscription-status API to determine if user is subscribed.
/// If statusCode == S1000 → user is subscribed (login).
/// Otherwise → user is not subscribed (redirect to registration/payment).
class PhoneAuthProvider extends ChangeNotifier {
  // ── Constants ────────────────────────────────────────────────────────────────
  static const String _statusApiUrl =
      'https://fluttbizitsolutions.com/api/bdapps_get_status.php';
  static const String _applicationId = 'APP_140124';
  static const String _password = 'a2e48f4c4513432d2ba1219fc68b9074';

  // ── Text controller ─────────────────────────────────────────────────────────
  final TextEditingController mobileController = TextEditingController();

  // ── Internal state ───────────────────────────────────────────────────────────
  bool _isLoading = false;
  String _errorMessage = '';
  String _mobileNumber = '';

  // ── Public getters ───────────────────────────────────────────────────────────
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get mobileNumber => _mobileNumber;

  @override
  void dispose() {
    mobileController.dispose();
    super.dispose();
  }

  // ── Private state helpers ────────────────────────────────────────────────────
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  void _setMobileNumber(String value) {
    _mobileNumber = value;
    notifyListeners();
  }

  // ── Validation ───────────────────────────────────────────────────────────────

  /// Returns null if valid, or a translated error string otherwise.
  String? validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'please_enter_number'.tr;
    }

    final clean = value.replaceAll(RegExp(r'[^\d]'), '');

    if (clean.length != 11) {
      return 'number_must_be_11_digits'.tr;
    }

    if (!clean.startsWith('01')) {
      return 'enter_valid_bd_number'.tr;
    }

    return null;
  }

  // ── Normalise ────────────────────────────────────────────────────────────────

  /// Strips non-digits and any leading 88 country code.
  String _normalizeMsisdn(String raw) {
    var clean = raw.replaceAll(RegExp(r'[^\d]'), '');
    if (clean.startsWith('8801') && clean.length == 13) {
      clean = clean.substring(2); // drop country code → 01XXXXXXXXX
    }
    return clean;
  }

  // ── BDApps Status Check ──────────────────────────────────────────────────────

  /// Calls the BDApps get-status API for the entered mobile number.
  ///
  /// Returns:
  ///   1  – statusCode S1000 → user is subscribed → proceed to login
  ///   0  – any other statusCode → user is not subscribed → send to register
  ///  -1  – network / server error
  Future<int> checkBdAppsStatus() async {
    _setErrorMessage('');

    final validationError = validateMobileNumber(mobileController.text);
    if (validationError != null) {
      _setErrorMessage(validationError);
      return -1;
    }

    _setLoading(true);

    try {
      final msisdn = _normalizeMsisdn(mobileController.text.trim());
      _setMobileNumber(mobileController.text.trim());

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('MOBILE_NUMBER', msisdn);

      // subscriberId must be in tel:880XXXXXXXXX format
      final subscriberId = 'tel:88$msisdn';

      debugPrint('=== BDApps Status Check ===');
      debugPrint('subscriberId: $subscriberId');

      final response = await http
          .post(
            Uri.parse(_statusApiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'applicationId': _applicationId,
              'password': _password,
              'subscriberId': subscriberId,
            }),
          )
          .timeout(const Duration(seconds: 15));

      debugPrint('HTTP ${response.statusCode}: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        // Response shape: { "httpCode": 200, "bdappsResponse": { "statusCode": "S1000", ... } }
        final bdappsResponse = json['bdappsResponse'];
        final statusCode = (bdappsResponse?['statusCode'] ?? '')
            .toString()
            .trim();
        final subscriptionStatus = (bdappsResponse?['subscriptionStatus'] ?? '')
            .toString()
            .trim();
        debugPrint('BDApps statusCode: $statusCode');
        if (statusCode == 'S1000' && subscriptionStatus != 'UNREGISTERED') {
          // User is subscribed — save credentials and mark as logged in
          await prefs.setString('USER_PHONE', msisdn);
          await prefs.setString('MOBILE_NUMBER', msisdn);
          await prefs.setBool('IS_SUBSCRIBED', true);
          await UidService.instance.setUid(msisdn);
          return 1;
        } else {
          // Not subscribed — user should register via bKash
          return 0;
        }
      } else {
        _setErrorMessage(
          '${'something_went_wrong'.tr} (${response.statusCode})',
        );
        return -1;
      }
    } on SocketException {
      _setErrorMessage('network_error'.tr);
      return -1;
    } on TimeoutException {
      _setErrorMessage('connection_timeout'.tr);
      return -1;
    } on FormatException {
      _setErrorMessage('Invalid response from server.');
      return -1;
    } catch (e) {
      debugPrint('checkBdAppsStatus error: $e');
      _setErrorMessage('something_went_wrong'.tr);
      return -1;
    } finally {
      _setLoading(false);
    }
  }

  // ── Utilities ────────────────────────────────────────────────────────────────

  /// Resets all form state.
  void clearForm() {
    mobileController.clear();
    _setMobileNumber('');
    _setErrorMessage('');
  }
}
