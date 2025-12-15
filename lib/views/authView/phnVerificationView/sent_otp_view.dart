// import 'package:finance_manager_app/config/myColors/app_colors.dart';

// import 'package:finance_manager_app/services/otp/sent_otp_service.dart';
// import 'package:finance_manager_app/views/authView/phnVerificationView/verify_otp_view.dart';
// import 'package:finance_manager_app/views/mainView/main_view.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';

// class SentOtpView extends StatefulWidget {
//   const SentOtpView({super.key});

//   @override
//   State<SentOtpView> createState() => _SentOtpViewState();
// }

// class _SentOtpViewState extends State<SentOtpView> {
//   final _formKey = GlobalKey<FormState>();
//   final _phoneController = TextEditingController();

//   @override
//   void dispose() {
//     _phoneController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.darkCardBackground,
//       appBar: AppBar(
//         title: Text(
//           "registration".tr,
//           style: TextStyle(
//             color: AppColors.textPrimary,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         backgroundColor: AppColors.primaryBlue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       "mobile_verification".tr,
//                       style: TextStyle(
//                         fontSize: 24,
//                         color: AppColors.textPrimary,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       "enter_phone_number_desc".tr,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//                     SizedBox(height: 30),
//                     TextFormField(
//                       controller: _phoneController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "please_enter_number".tr;
//                         }
//                         if (value.length != 11) {
//                           return "number_must_be_11_digits".tr;
//                         }
//                         if (!value.startsWith("01")) {
//                           return "enter_valid_bd_number".tr;
//                         }
//                         return null;
//                       },
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly,
//                         LengthLimitingTextInputFormatter(11),
//                       ],
//                       decoration: InputDecoration(
//                         hintText: "enter_phone_hint".tr,
//                         hintStyle: TextStyle(color: AppColors.textSecondary),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.border),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.primaryBlue),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         errorBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.redAccent),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         focusedErrorBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.redAccent),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         prefixIcon: Icon(Icons.phone_iphone),
//                       ),
//                       keyboardType: TextInputType.phone,
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primaryBlue,
//                           padding: EdgeInsets.symmetric(vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                         ),
//                         onPressed: () async {
//                           if (_formKey.currentState!.validate()) {
//                             showDialog(
//                               context: context,
//                               barrierDismissible: false,
//                               builder: (BuildContext context) {
//                                 return const Dialog(
//                                   backgroundColor: Colors.transparent,
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: [CircularProgressIndicator()],
//                                   ),
//                                 );
//                               },
//                             );

//                             final result = await SendOTPService().sendOTP(
//                               _phoneController.text.trim(),
//                             );

//                             if (context.mounted) {
//                               Navigator.pop(context); // Close loading dialog

//                               if (result['success'] == true) {
//                                 if (result['status'] == 'S1000') {
//                                   Get.to(
//                                     () => const VerifyOtpView(),
//                                   ); // Use Get.to instead of named route if preferred, or keep named
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(content: Text(result['message'])),
//                                   );
//                                 } else if (result['status'] == 'E1351') {
//                                   Get.offAll(() => const MainView());
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(content: Text(result['message'])),
//                                   );
//                                 }
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text(result['message'])),
//                                 );
//                               }
//                             }
//                           }
//                         },
//                         child: Text(
//                           "send_code".tr,
//                           style: TextStyle(
//                             color: AppColors.textPrimary,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       "otp_will_be_sent".tr,
//                       style: TextStyle(
//                         color: AppColors.textSecondary,
//                         fontSize: 14,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
