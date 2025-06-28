import 'package:finance_manager_app/config/routes/routes_name.dart';
import 'package:finance_manager_app/views/authView/login_view.dart';
import 'package:finance_manager_app/views/authView/register_view.dart';
import 'package:finance_manager_app/views/splashView/splash_view.dart';
import 'package:get/get.dart';

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
    // GetPage(
    //   name: RoutesName.homeView,
    //   page: () => const HomeView(),
    //   transition: Transition.rightToLeft,
    // ),
    // GetPage(
    //   name: RoutesName.chatView,
    //   page: () => ChatView(),
    //   transition: Transition.rightToLeft,
    // ),
    // GetPage(
    //   name: RoutesName.welcomeView,
    //   page: () => const WelcomeView(),
    //   transition: Transition.rightToLeft,
    // ),
    // GetPage(
    //   name: RoutesName.profileView,
    //   page: () => ProfileView(),
    //   transition: Transition.rightToLeft,
    // ),
    // GetPage(
    //   name: RoutesName.contactView,
    //   page: () => ContactView(),
    //   transition: Transition.rightToLeft,
    // ),
  ];
}
