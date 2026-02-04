import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/proProvider/pro_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:finance_manager_app/views/mainView/main_view.dart';
import 'package:provider/provider.dart';

enum _Plan { daily, monthly, ai }

class UnsubscirbeView extends StatelessWidget {
  const UnsubscirbeView({super.key});

  // plan options for dialog
  static const _dailyPassword = "3301cc4701133fbcf37b0199a68adc55";
  static const _monthlyPassword = "8e720471e31d322a083d29497b9237a7";
  static const _aiPassword = "696a49b245149723d1904ce593dea5eb";
  // plan options for dialog
  static const _dailyAppID = "APP_134794";
  static const _monthlyAppID = "APP_134793";
  static const _aiAppID = "APP_134919";

  Future<void> unsubscribe(
    BuildContext context,
    aplicatonID,
    password,
    subscriberId,
  ) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final res = await http
          .post(
            Uri.parse('https://fluttbizitsolutions.com/api/unsubcribe.php'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "applicationId": aplicatonID,
              "password": password,
              "version": "1.0",
              "action": 0,
              // subscriberId may be passed as a direct tel:8801... string
              "subscriberId": "tel:88$subscriberId",
            }),
          )
          .timeout(const Duration(seconds: 15));

      // Close loading
      if (context.mounted) Navigator.of(context).pop();

      final body = jsonDecode(res.body);
      final statusCode = body["statusCode"];

      if (statusCode == "E1356" || statusCode == "E1325") {
        Get.offAll(UnsubscirbeView());

        Get.snackbar(
          'error'.tr,
          'not_subscribed_error'.tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      Get.offAll(MainView());
      Get.snackbar(
        'success'.tr,
        'unsubscribe_success'.tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } on SocketException {
      if (context.mounted) Navigator.of(context).pop();
      Get.snackbar(
        'error'.tr,
        'Network Issue: Check your internet connection',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } on TimeoutException {
      if (context.mounted) Navigator.of(context).pop();
      Get.snackbar(
        'error'.tr,
        'Connection timed out. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();
      Get.snackbar(
        'error'.tr,
        'Error: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'unsubscribe'.tr,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'choose_plan'.tr, // Using existing key or generic title
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 30),
              _buildOptionCard(
                context,
                title: 'daily_plan'.tr,
                icon: Icons.calendar_today,
                color: Colors.blue,
                onTap: () => _showUnsubscribeDialog(context, _Plan.daily),
              ),
              const SizedBox(height: 20),
              _buildOptionCard(
                context,
                title: 'monthly_plan'.tr,
                icon: Icons.calendar_month,
                color: Colors.purple,
                onTap: () => _showUnsubscribeDialog(context, _Plan.monthly),
              ),
              const SizedBox(height: 20),
              _buildOptionCard(
                context,
                title: 'buy_more_ai_credits_plan'.tr,
                icon: Icons.smart_toy,
                color: Colors.orange,
                onTap: () => _showUnsubscribeDialog(context, _Plan.ai),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUnsubscribeDialog(BuildContext context, _Plan initialPlan) {
    final TextEditingController phoneController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    _Plan selected = initialPlan;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.unsubscribe,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    'unsubscribe'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    'enter_mobile_desc'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),

                  // Phone Input Field
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: '01XXXXXXXXX',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      prefixIcon: Icon(Icons.phone, color: Colors.grey[600]),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_number'.tr;
                      }
                      if (value.length != 11) {
                        return 'number_must_be_11_digits'.tr;
                      }
                      if (!value.startsWith("01")) {
                        return 'enter_valid_bd_number'.tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'cancel'.tr,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final phone = phoneController.text.trim();

                              // Build parameters
                              String id = _dailyAppID;
                              String password = _dailyPassword;

                              if (selected == _Plan.monthly) {
                                password = _monthlyPassword;
                              }
                              if (selected == _Plan.ai) password = _aiPassword;

                              if (selected == _Plan.monthly) id = _monthlyAppID;

                              if (selected == _Plan.ai) id = _aiAppID;

                              Navigator.of(context).pop();

                              unsubscribe(context, id, password, phone);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'unsubscribe'.tr,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool selected = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: selected
            ? color.withValues(alpha: 0.06)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? color : color.withValues(alpha: 0.3),
          width: selected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: selected
                        ? color.withValues(alpha: 0.16)
                        : color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
