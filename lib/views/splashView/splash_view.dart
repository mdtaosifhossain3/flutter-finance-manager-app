import 'dart:async';

import 'package:finance_manager_app/config/routes/routes_name.dart';
import 'package:finance_manager_app/views/authView/login_view.dart';
import 'package:finance_manager_app/views/onboardView/onboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2),(){
      Get.offAll(OnboardView());
    });


  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder(child: Center(child: Text("Splash View")));
  }
}
