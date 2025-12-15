import 'dart:async';
import 'dart:io';

import 'package:get/get_utils/src/extensions/export.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SendOTPService {
  // Helper function to extract values
  String _extractValue(String body, String key) {
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

  Future<Map<String, dynamic>> sendOTP(String mobile) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Prepare the request data
    Map<String, String> data = {'user_mobile': mobile};

    // Send HTTP POST request to the API
    try {
      final response = await http.post(
        Uri.parse('https://fluttbizitsolutions.com/api/fn_app_otp_sent.php'),
        body: data,
      );

      var body = response.body;
      final statusCode = _extractValue(body, 'Status code').trim();
      final result = statusCode.replaceAll(":", "").trim();

      if (result == "S1000") {
        final ref = _extractValue(body, 'Reference number');
        final refResult = ref.replaceAll(":", "").trim();
        sharedPreferences.setString("REFERENCE_NUMBER", refResult);
        return {
          'success': true,
          'status': 'S1000',
          'message': 'OTP sent successfully',
        };
      } else if (result == "E1351") {
        return {'success': true, 'status': 'E1351', 'message': 'Welcome Back!'};
      } else {
        return {
          'success': false,
          'message': 'Please Enter a valid Robi/Airtel Number',
        };
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
