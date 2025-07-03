import 'package:finance_manager_app/config/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewModel _viewModel = LoginViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF6FCF9),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo or illustration
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFF19D3AE).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 48,
                      color: Color(0xFF19D3AE),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Color(0xFF222B45),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Login to manage your finances smartly',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _viewModel.emailController,
                    decoration: InputDecoration(
                      hintText: 'Email or Username',
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: Color(0xFF19D3AE),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Color(0xFF19D3AE),
                          width: 1.2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF19D3AE),
                          width: 1.2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _viewModel.passwordController,
                    obscureText: !_viewModel.showPassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF19D3AE),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Color(0xFF19D3AE),
                          width: 1.2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF19D3AE),
                          width: 1.2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _viewModel.showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _viewModel.togglePasswordVisibility();
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed(RoutesName.forgetPasswordView);
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF19D3AE),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF19D3AE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 2,
                      ),
                      onPressed: () {
                        _viewModel.login(context);
                      },
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'or',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.facebook,
                          size: 28,
                          color: Color(0xFF19D3AE),
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.g_mobiledata,
                          size: 28,
                          color: Color(0xFF19D3AE),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(RoutesName.registerView);
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF19D3AE),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
