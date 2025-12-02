import 'package:finance_manager_app/views/splashView/splash_view_model.dart';
import 'package:flutter/material.dart';

import '../../config/app_name.dart';

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
      body: Stack(
        alignment: AlignmentGeometry.center,
        children: [
          Center(
            child: Image.asset("assets/images/a.png", width: 88, height: 88),
          ),

          Positioned(
            bottom: 40,
            child: Text(
              appName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
