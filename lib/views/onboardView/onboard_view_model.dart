import 'package:flutter/material.dart';

class OnboardViewModel {
  static PageController pageController = PageController();

  static void goToNextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }
}
