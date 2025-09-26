import 'package:finance_manager_app/config/routes/routes_name.dart';
import 'package:finance_manager_app/views/authView/forgetPasswordView/forget_password_view.dart';
import 'package:finance_manager_app/views/authView/loginView/login_view.dart';
import 'package:finance_manager_app/views/authView/registerView/register_view.dart';
import 'package:finance_manager_app/views/authView/resetPasswordView/reset_password_view.dart';
import 'package:finance_manager_app/views/homeView/home_view.dart';
import 'package:finance_manager_app/views/splashView/splash_view.dart';
import 'package:get/get.dart';

import '../../globalWidgets/notificationView/notification_view.dart';

class Routes {
  static var views = [
    GetPage(
      name: RoutesName.splashView,
      page: () => const SplashView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.registerView,
      page: () => const RegisterView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.loginView,
      page: () => const LoginView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.forgetPasswordView,
      page: () => const ForgetPasswordView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.resetPasswordView,
      page: () => ResetPasswordView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.homeView,
      page: () =>  HomeView(),
      transition: Transition.rightToLeft,
    ),


    GetPage(
      name: RoutesName.notificationView,
      page: () => NotificationView(),
      transition: Transition.rightToLeft,
    ),
  ];
}
