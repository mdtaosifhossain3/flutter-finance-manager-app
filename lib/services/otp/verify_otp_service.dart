import 'dart:io';
import 'package:finance_manager_app/views/mainView/main_view.dart';
import 'package:flutter/material.dart';

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

  Future<void> verifyOTP(context, otpController) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final referenceNumber = sharedPreferences.getString("REFERENCE_NUMBER");
    String mobile = otpController.text.trim();

    // Prepare the request data
    Map<String, String> data = {"referenceNo": referenceNumber!, "otp": mobile};
    //Loading Effect
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [CircularProgressIndicator(color: Colors.black)],
          ),
        );
      },
    );
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return const MainView();
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully Subscribed')),
        );
      } else {
        Navigator.pop(context);
        // print(response.body); // Error occurred
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Enter a valid OTP')));
      }
    } on SocketException {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Time Out')));
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
