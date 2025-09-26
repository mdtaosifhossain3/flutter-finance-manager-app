import 'package:finance_manager_app/views/mainView/main_view.dart';
import 'package:finance_manager_app/views/welcomeView/welcome_view.dart';
import 'package:get/get.dart';

class SplashViewModel {
  static redirectToOnboard() {
    Future.delayed(Duration(seconds: 3), () {
      Get.offAll(WelcomeView());
    });
  }
}
