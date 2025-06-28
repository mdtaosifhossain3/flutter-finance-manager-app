import 'package:flutter/material.dart';

class LoginViewModel {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showPassword = false;

  void togglePasswordVisibility() {
    showPassword = !showPassword;
  }

  void login(BuildContext context) {
    // TODO: Add your DB or API login logic here
    final email = emailController.text.trim();
    final password = passwordController.text;
    // Example: print login data
    print('Login with: email=$email, password=$password');
    // Show a snackbar for demonstration
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Login pressed for $email')));
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
