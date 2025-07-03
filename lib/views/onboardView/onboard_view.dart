import 'package:finance_manager_app/config/myColors/my_colors.dart';
import 'package:finance_manager_app/config/routes/routes_name.dart';
import 'package:finance_manager_app/views/onboardView/onboard_view_model.dart';
import 'package:finance_manager_app/views/onboardView/widgets/onboard_view_first.dart';
import 'package:finance_manager_app/views/onboardView/widgets/onboard_view_second.dart';
import 'package:finance_manager_app/views/onboardView/widgets/onboard_view_third.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardView extends StatefulWidget {
  const OnboardView({super.key});

  @override
  State<OnboardView> createState() => _OnboardViewState();
}

class _OnboardViewState extends State<OnboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: OnboardViewModel.pageController,
                    children: const [
                      OnboardFirst(),
                      OnboardSecond(),
                      OnboardThird(),
                    ],
                  ),
                ),
                SizedBox(height: 5.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.carbbeanGreen,
                    foregroundColor: Colors.white,
                    minimumSize: Size(MediaQuery.of(context).size.width, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  onPressed: () => Get.offAllNamed(RoutesName.loginView),
                  child: Text("Get Started", style: TextStyle(fontSize: 16)),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Get.offAllNamed(RoutesName.loginView),
                      child: Text(
                        "Skip",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MyColors.carbbeanGreen,
                        ),
                      ),
                    ),
                    SmoothPageIndicator(
                      controller: OnboardViewModel.pageController,
                      count: 3,
                      effect: const WormEffect(
                        dotColor: Colors.grey,
                        activeDotColor: MyColors.carbbeanGreen,
                      ),
                    ),
                    TextButton(
                      onPressed: () => OnboardViewModel.goToNextPage(),
                      child: Text(
                        "Next",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MyColors.carbbeanGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
