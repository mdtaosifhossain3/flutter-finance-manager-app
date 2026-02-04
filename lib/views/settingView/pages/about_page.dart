import 'package:finance_manager_app/config/app_name.dart';
import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/views/settingView/widgets/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final teamMembers = [
      {
        'name': "Mahamudur Rahman",
        'role': "Founder",
        'imagePath': "assets/images/alfa.jpeg",
        'socialLinks': {
          FontAwesomeIcons.linkedin:
              'https://www.linkedin.com/in/mahamudur-rahman-305542252/',
          FontAwesomeIcons.facebook: 'https://www.facebook.com/mr.alfa.12',
          Icons.email: 'mailto:mahamudurrahman2005@gmail.com',
        },
      },
      {
        'name': "MD Taosif Hossain",
        'role': "Co-Founder & Lead Developer",
        'imagePath': "assets/images/taosif.jpg",
        'socialLinks': {
          FontAwesomeIcons.linkedin:
              'https://www.linkedin.com/in/md-taosif-hossain-th/',
          FontAwesomeIcons.facebook:
              'https://www.facebook.com/taosifhossain4791/',
          Icons.email: 'mailto:mdtaosifhossain29@gmail.com',
        },
      },
      {
        'name': "Junayed Hasan",
        'role': "Customer Relationship Manager",
        'imagePath': "assets/images/neloy.jpg",
        'socialLinks': {
          FontAwesomeIcons.facebook:
              'https://www.facebook.com/junayed.hasan.800874',
          Icons.email: 'mailto:xunayedsafin880@gmail.com',
        },
      },
    ];

    return Scaffold(
      appBar: customAppBar(
        title: "about".tr,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo_foreground.png', // App Logo
                    height: 80,
                    width: 80,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    appName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: .7, // Adjusted for card height
              ),
              itemCount: teamMembers.length,
              itemBuilder: (context, index) {
                final member = teamMembers[index];
                return ProfileCard(
                  name: member['name'] as String,
                  role: member['role'] as String,
                  imagePath: member['imagePath'] as String,
                  socialLinks: member['socialLinks'] as Map<IconData, String>,
                );
              },
            ),
            const SizedBox(height: 32),
            Text(
              "about".tr,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
              ),
              child: Text(
                "aboutbody".tr,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.6),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                "© ${DateTime.now().year} Fluttbiz IT Solutions",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
