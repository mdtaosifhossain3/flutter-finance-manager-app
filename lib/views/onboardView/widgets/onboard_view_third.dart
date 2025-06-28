import 'package:flutter/material.dart';

class OnboardThird extends StatelessWidget {
  const OnboardThird({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/onboard3.png', // Place your illustration here
          height: 350,
        ),
        const SizedBox(height: 24),
         Text(
          'Analyze & Improve',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 12),
        const Text(
          'Get insights and reports to make smarter financial decisions.',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
        ),
      ],
    );
  }
}
