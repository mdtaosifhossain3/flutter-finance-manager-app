import 'package:finance_manager_app/views/mainView/main_view.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class ProfileSetupViewModel {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController moneyController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  bool showPassword = false;

  void setupProfile(BuildContext context) {
    // ScaffoldMessenger.of(
    //   context,
    // ).showSnackBar(SnackBar(content: Text('Login pressed for $email')));
    Get.to(MainView());
  }

  void dispose() {
    nameController.dispose();
    moneyController.dispose();
    countryController.dispose();
  }
}
