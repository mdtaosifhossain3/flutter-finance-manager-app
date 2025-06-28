import 'package:flutter/material.dart';

class OnboardSecond extends StatelessWidget {
  const OnboardSecond({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/onboard2.png', // Place your illustration here
          height: 350,
        ),
        const SizedBox(height: 24),
         Text(
          'Set Budgets Easily',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 12),
        const Text(
          'Create and manage budgets to achieve your financial goals.',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
        ),
      ],
    );
  }
}
