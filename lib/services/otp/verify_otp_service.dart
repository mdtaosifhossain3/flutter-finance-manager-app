import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VerifyOTPService {
  // Helper function to extract values
  String extractValue(String body, String key) {
    final startIndex = body.indexOf(key);
    if (startIndex != -1) {
      final substring = body.substring(startIndex);
      final endIndex = substring.indexOf('\n');
      if (endIndex != -1) {
        return substring.substring(key.length, endIndex).trim();
      }
      return substring.substring(key.length).trim();
    }
    return '';
  }

  Future<Map<String, dynamic>> verifyOTP(String otp) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final referenceNumber = sharedPreferences.getString("REFERENCE_NUMBER");

    // Prepare the request data
    Map<String, String> data = {"referenceNo": referenceNumber!, "otp": otp};

    // Send HTTP POST request to the API
    try {
      final response = await http.post(
        Uri.parse('https://fluttbizitsolutions.com/api/fn_app_otp_verify.php'),
        body: data,
      );

      var body = response.body;
      final statusCode = extractValue(body, 'Status code').trim();
      final result = statusCode.replaceAll(":", "").trim();
      if (result == "S1000") {
        return {'success': true, 'message': 'Successfully Subscribed'};
      } else {
        return {'success': false, 'message': 'Enter a valid OTP'};
      }
    } on SocketException {
      return {'success': false, 'message': 'no_internet_connection'.tr};
    } on TimeoutException {
      return {'success': false, 'message': 'connection_timeout'.tr};
    } catch (e) {
      return {'success': false, 'message': 'something_went_wrong'.tr};
    }
  }
}
