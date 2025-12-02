import 'dart:io';
import 'package:finance_manager_app/views/authView/phnVerificationView/verify_otp_view.dart';
import 'package:finance_manager_app/views/mainView/main_view.dart';
import 'package:flutter/material.dart';
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

  Future<void> sendOTP(context, controller) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String mobile = controller.text.trim();

    // Prepare the request data
    Map<String, String> data = {'user_mobile': mobile};
    //Loading Effect
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [CircularProgressIndicator()],
          ),
        );
      },
    );
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

        //OTP Verification Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return VerifyOtpView();
            },
          ),
        );

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('OTP sent successfully')));
      } else if (result == "E1351") {
        Navigator.pop(context);
        //OTP Verification Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return const MainView();
            },
          ),
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Welcome Back!')));
      } else {
        print(response.body); // Error occurred
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please Enter a valid Robi/Airtel Number'),
          ),
        );
      }
    } on SocketException catch (e) {
      Navigator.pop(context);
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Network Issue ${e.toString()}')));
    } catch (e) {
      Navigator.pop(context);
      // Handle error in case of network issues
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
