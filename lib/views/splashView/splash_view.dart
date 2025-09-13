import 'package:finance_manager_app/views/splashView/splash_view_model.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
   SplashViewModel.redirectToOnboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Image.asset(
          "assets/images/Vector.png",
          width: 99,

        ),
      ),
    );
  }
}
