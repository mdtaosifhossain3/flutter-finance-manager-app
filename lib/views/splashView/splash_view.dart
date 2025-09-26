
import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/views/splashView/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:finance_manager_app/views/homeView/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
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

      body: Center(child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: [

        Text("Money Tracker",style: TextStyle(fontSize: 34,),)
      ],),));
  }
}
