import 'package:finance_manager_app/config/routes/routes_name.dart';
import 'package:finance_manager_app/views/budgetView/pages/add_budget_view.dart';
import 'package:finance_manager_app/views/categoryView/category_view.dart';
import 'package:finance_manager_app/views/categoryView/pages/transaction_form_view.dart';
import 'package:finance_manager_app/views/homeView/home_view.dart';
import 'package:finance_manager_app/views/mainView/main_view.dart';
import 'package:finance_manager_app/views/notificationView/notification_view.dart';
import 'package:finance_manager_app/views/reportView/report_view.dart';
import 'package:finance_manager_app/views/settingView/setting_view.dart';
import 'package:finance_manager_app/views/splashView/splash_view.dart';
import 'package:get/get.dart';

import '../../views/budgetView/budget_view.dart';
import '../../views/reportView/pages/expenses_view.dart';
import 'package:finance_manager_app/views/authView/auth/login_view.dart';
import 'package:finance_manager_app/views/authView/auth/register_view.dart';
import 'package:finance_manager_app/views/authView/auth/reset_password.dart';

class Routes {
  static var views = [
    GetPage(
      name: RoutesName.splashView,
      page: () => const SplashView(),
      transition: Transition.rightToLeft,
    ),
    // GetPage(
    //   name: RoutesName.welcomeView,
    //   page: () => const WelcomeView(),
    //   transition: Transition.rightToLeft,
    // ),
    // GetPage(
    //   name: RoutesName.otepVerifyView,
    //   page: () => const VerifyOtpView(),
    //   transition: Transition.rightToLeft,
    // ),
    GetPage(
      name: RoutesName.loginView,
      page: () => const LoginView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.registerView,
      page: () => const RegisterView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.resetPasswordView,
      page: () => const ResetPasswordView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.mainView,
      page: () => MainView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.homeView,
      page: () => HomeView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.notificationView,
      page: () => NotificationCenterPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.reportView,
      page: () => ReportView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.expenseView,
      page: () => ExpensesView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.categoryView,
      page: () => CategoryView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.transactionView,
      page: () => TransactionFormPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.budgetView,
      page: () => BudgetView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.addBudgetView,
      page: () => AddBudgetView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.settingView,
      page: () => SettingsPage(),
      transition: Transition.rightToLeft,
    ),
  ];
}
