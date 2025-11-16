import 'package:finance_manager_app/config/routes/routes_name.dart';
import 'package:get/get.dart';

class SplashViewModel {
  static redirectToOnboard() {
    Future.delayed(Duration(seconds: 3), () {
      Get.offAllNamed(RoutesName.mainView);
    });
  }
}
