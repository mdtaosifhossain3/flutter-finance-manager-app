import 'package:finance_manager_app/views/mainView/main_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterViewModel {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController resetPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool showPassword = false;

  void togglePasswordVisibility() {
    showPassword = !showPassword;
  }

  void register(BuildContext context) {
    // Example: print login data
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
