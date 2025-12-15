import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/config/routes/routes_name.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/proProvider/pro_provider.dart';
import 'package:finance_manager_app/services/otp/sent_otp_service.dart';
import 'package:finance_manager_app/services/otp/verify_otp_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PricingView extends StatefulWidget {
  const PricingView({super.key});

  @override
  State<PricingView> createState() => _PricingViewState();
}

class _PricingViewState extends State<PricingView> {
  int _selectedIndex = 3; // Default to Ultimate Plan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: "manage_plan".tr,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'choose_pricing_plan'.tr,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            _buildFeatureItem('set_reminder'.tr),
            _buildFeatureItem('monthly_weekly_reports'.tr),
            _buildFeatureItem('reports'.tr),
            _buildFeatureItem('set_budget'.tr),
            _buildFeatureItem('no_ads'.tr),
            const SizedBox(height: 30),
            _buildPlanCard(
              index: 0,
              title: 'starter_plan'.tr,
              credits: '900_credits'.tr,
              price: '45',
              duration: 'monthly'.tr,
              icon: Icons.star,
              color: const Color(0xFF6C5CE7),
            ),
            const SizedBox(height: 15),
            _buildPlanCard(
              index: 1,
              title: 'smart_plan'.tr,
              credits: '2700_credits'.tr,
              price: '115',
              duration: '3_months'.tr,
              icon: Icons.rocket_launch,
              color: const Color(0xFF4834D4), // Slightly darker blue/purple
            ),
            const SizedBox(height: 15),
            _buildPlanCard(
              index: 2,
              title: 'pro_plan'.tr,
              credits: '2700_credits_pro'
                  .tr, // Assuming same credits as smart but longer duration? Or maybe typo in prototype. Following prototype text.
              price: '200',
              duration: '6_months'.tr,
              icon: Icons.diamond,
              color: const Color(0xFFFF7675),
            ),
            const SizedBox(height: 15),
            _buildPlanCard(
              index: 3,
              title: 'ultimate_plan'.tr,
              credits: '27000_credits'.tr,
              price: '300',
              duration: '1_year'.tr,
              icon: Icons.workspace_premium, // Crown icon
              color: const Color(0xFF6C5CE7),
              isBestValue: true,
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final result = await InternetAddress.lookup('google.com');
                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                      if (context.mounted) {
                        _showPhoneNumberDialog(context);
                      }
                    }
                  } on SocketException catch (_) {
                    Get.snackbar(
                      'no_internet_connection'.tr,
                      'connect_internet_to_buy'.tr,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1877F2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'choose_plan'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Color(0xFF2ECC71),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required int index,
    required String title,
    required String credits,
    required String price,
    required String duration,
    required IconData icon,
    required Color color,
    bool isBestValue = false,
  }) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          credits,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'TK. $price',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        duration,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isBestValue)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                  ),
                  child: const Icon(Icons.star, size: 12, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showPhoneNumberDialog(BuildContext context) {
    final phoneController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.phone_android,
                          color: Colors.blue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'registration'.tr,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'mobile_verification'.tr,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Phone Input Field
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'enter_phone_hint'.tr,
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
                          color: Colors.blue,
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
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              // Show loading
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );

                              final result = await SendOTPService().sendOTP(
                                phoneController.text.trim(),
                              );

                              if (context.mounted) {
                                Navigator.pop(context); // Close loading
                                if (result['success'] == true &&
                                    result['status'] == 'S1000') {
                                  Navigator.pop(context); // Close Phone Dialog
                                  _showOTPDialog(
                                    context,
                                    phoneController.text.trim(),
                                  );
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   SnackBar(content: Text(result['message'])),
                                  // );
                                } else if (result['success'] == true &&
                                    result['status'] == 'E1351') {
                                  Navigator.pop(context); // Close Phone Dialog
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   SnackBar(content: Text(result['message'])),
                                  // );
                                  _showSuccessDialog(
                                    context,
                                    phoneController.text.trim(),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(result['message'])),
                                  );
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'send_code'.tr,
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

  void _showOTPDialog(BuildContext context, String phoneNumber) {
    final otpController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
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
                  // Header Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified_user,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'account_activation'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'enter_otp_desc'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // OTP Input Field
                  TextFormField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                    ),
                    maxLength: 6,
                    decoration: InputDecoration(
                      hintText: '------',
                      hintStyle: TextStyle(
                        color: Colors.grey[300],
                        letterSpacing: 8,
                      ),
                      counterText: '',
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
                          color: Colors.blue,
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_otp'.tr;
                      }
                      if (value.length != 6) {
                        return 'otp_must_be_6_digits'.tr;
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
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              // Show loading
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );

                              final result = await VerifyOTPService().verifyOTP(
                                otpController.text.trim(),
                              );

                              if (context.mounted) {
                                Navigator.pop(context); // Close loading
                                if (result['success'] == true) {
                                  Navigator.pop(context); // Close OTP Dialog
                                  _showSuccessDialog(context, phoneNumber);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(result['message'])),
                                  );
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'verify_number'.tr,
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

  void _showSuccessDialog(BuildContext context, String phoneNumber) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon with Animation Effect
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Success Title
                Text(
                  'number_verified_title'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'subscribe_instruction'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Purchase Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      int duration = 30; // Default monthly
                      String amount = "45";
                      if (_selectedIndex == 0) {
                        duration = 30;
                        amount = "45";
                      } else if (_selectedIndex == 1) {
                        duration = 90;
                        amount = "115";
                      } else if (_selectedIndex == 2) {
                        duration = 180;
                        amount = "200";
                      } else if (_selectedIndex == 3) {
                        duration = 365;
                        amount = "300";
                      }

                      try {
                        final response = await http.post(
                          Uri.parse(
                            "https://fluttbizitsolutions.com/api/fn_caas_api.php",
                          ),
                          headers: {"Content-Type": "application/json"},
                          body: jsonEncode({
                            "applicationId": "APP_133862",
                            "password": "e2bd482ff934439f3c993688e7ca875c",
                            "externalTrxId":
                                "${DateTime.now().millisecondsSinceEpoch}",
                            "subscriberId": "tel:88$phoneNumber",
                            "paymentInstrumentName": "Mobile Account",
                            "accountId": "88$phoneNumber",
                            "amount": 1,
                            "currency": "BDT",
                          }),
                        );

                        final data = jsonDecode(response.body);

                        if (data["statusCode"] == "1000") {
                          // Payment successful
                          if (!context.mounted) return;
                          await Provider.of<ProProvider>(
                            context,
                            listen: false,
                          ).enablePro(duration);

                          if (context.mounted) {
                            //Navigator.of(context).pop();
                            Get.toNamed(RoutesName.homeView);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('subscription_success_msg'.tr),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            Navigator.of(context).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  data["statusDetail"],
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,

                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        _handleError(e);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2ECC71),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'purchase_now_button'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Close Button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'cancel'.tr,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void _handleError(Object e) {
  String message = "An unknown error occurred";

  if (e is SocketException) {
    message = "No internet connection. Please check your network.";
  } else if (e is TimeoutException) {
    message = "Connection timed out. Please try again.";
  }

  Get.snackbar(
    "Error",
    message,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    duration: const Duration(seconds: 4),
  );
}
