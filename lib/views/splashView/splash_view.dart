import 'package:finance_manager_app/config/myColors/app_colors.dart';
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
      backgroundColor: AppColors.darkMainBackground,

      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text(appName, style: TextStyle(fontSize: 34))],
        ),
      ),
    );
  }
}
