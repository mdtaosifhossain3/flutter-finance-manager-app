import 'package:finance_manager_app/config/app_name.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: "about".tr,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(appName, style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 20),

            Text("aboutbody".tr, style: TextStyle(fontSize: 16)),

            SizedBox(height: 20),

            const SizedBox(height: 8),
            Text("dev".tr),
            const SizedBox(height: 5),
            Text("companyName".tr),
          ],
        ),
      ),
    );
  }
}
