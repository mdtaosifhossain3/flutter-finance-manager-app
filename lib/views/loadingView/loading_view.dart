import 'package:finance_manager_app/views/homeView/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Get.offAll(HomeView());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Lottie.asset(
          'assets/animations/MoneyBag.json',
          width: 200,
          height: 200,
          fit: BoxFit.fill,
          repeat: false, // Play once
          reverse: false, // Don't reverse
          animate: true, // Auto-play
          frameRate: FrameRate.max, // Max frame rate
          delegates: LottieDelegates(
            values: [
              // Customize colors, text, etc.
            ],
          ),
        ),
      ),
    );
  }
}
