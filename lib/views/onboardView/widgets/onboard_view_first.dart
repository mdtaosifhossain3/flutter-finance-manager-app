import 'package:flutter/material.dart';

class OnboardFirst extends StatelessWidget {
  const OnboardFirst({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/onboard1.png', // Place your illustration here
          height: 350,
        ),
        const SizedBox(height: 24),
         Text(
          'Track Your Expenses',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 12),
        const Text(
          'Monitor your daily spending and stay in control of your finances.',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
        ),
      ],
    );
  }
}
