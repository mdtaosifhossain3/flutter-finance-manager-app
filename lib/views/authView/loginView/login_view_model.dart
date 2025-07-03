import 'package:finance_manager_app/views/mainView/main_view.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';

class LoginViewModel {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showPassword = false;

  void togglePasswordVisibility() {
    showPassword = !showPassword;
  }

  void login(BuildContext context) {
    final email = emailController.text.trim();
    final password = passwordController.text;
    // ScaffoldMessenger.of(
    //   context,
    // ).showSnackBar(SnackBar(content: Text('Login pressed for $email')));
    Get.to(MainView());
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
