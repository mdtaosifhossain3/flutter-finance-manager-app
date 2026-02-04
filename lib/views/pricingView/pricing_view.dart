// import 'package:finance_manager_app/config/myColors/app_colors.dart';
// import 'package:finance_manager_app/config/routes/routes_name.dart';
// import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class PricingView extends StatefulWidget {
//   const PricingView({super.key});

//   @override
//   State<PricingView> createState() => _PricingViewState();
// }

// class _PricingViewState extends State<PricingView> {
//   int _selectedIndex = 3; // Default to Ultimate Plan

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: customAppBar(
//         title: "manage_plan".tr,
//         leading: IconButton(
//           onPressed: () => Get.back(),
//           icon: const Icon(Icons.arrow_back),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(
//           horizontal: MediaQuery.of(context).size.width * 0.04,
//           vertical: 10,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'choose_pricing_plan'.tr,
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//             const SizedBox(height: 20),
//             _buildFeatureItem('add_with_ai'.tr),
//             _buildFeatureItem('smart_categorization'.tr),
//             _buildFeatureItem('given_taken'.tr),
//             _buildFeatureItem('set_budget'.tr),
//             _buildFeatureItem('set_reminder'.tr),
//             _buildFeatureItem('savings'.tr),
//             _buildFeatureItem('note'.tr),
//             _buildFeatureItem('monthly_weekly_reports'.tr),
//             _buildFeatureItem('no_ads'.tr),
//             _buildFeatureItem('unlimited_ai_credits'.tr),
//             _buildFeatureItem('premium_support'.tr),
//             const SizedBox(height: 30),
//             _buildPlanCard(
//               index: 0,
//               title: 'starter_plan'.tr,
//               credits: '900_credits'.tr,
//               price: '45',
//               duration: 'monthly'.tr,
//               icon: Icons.star,
//               color: const Color(0xFF6C5CE7),
//             ),
//             const SizedBox(height: 15),
//             _buildPlanCard(
//               index: 1,
//               title: 'smart_plan'.tr,
//               credits: '2700_credits'.tr,
//               price: '115',
//               duration: '3_months'.tr,
//               icon: Icons.rocket_launch,
//               color: const Color(0xFF4834D4), // Slightly darker blue/purple
//             ),
//             const SizedBox(height: 15),
//             _buildPlanCard(
//               index: 2,
//               title: 'pro_plan'.tr,
//               credits: '5500_credits_pro'.tr,
//               price: '200',
//               duration: '6_months'.tr,
//               icon: Icons.diamond,
//               color: const Color(0xFFFF7675),
//             ),
//             const SizedBox(height: 15),
//             _buildPlanCard(
//               index: 3,
//               title: 'ultimate_plan'.tr,
//               credits: '11000_credits'.tr,
//               price: '300',
//               duration: '1_year'.tr,
//               icon: Icons.workspace_premium, // Crown icon
//               color: const Color(0xFF6C5CE7),
//               isBestValue: true,
//             ),

//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               height: 55,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   Get.toNamed(RoutesName.checkOutView);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF1877F2),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   elevation: 0,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'choose_plan'.tr,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     const Icon(Icons.arrow_forward, color: Colors.white),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFeatureItem(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(2),
//             decoration: const BoxDecoration(
//               color: Color(0xFF2ECC71),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.check, size: 14, color: Colors.white),
//           ),
//           const SizedBox(width: 12),
//           Text(
//             text,
//             style: Theme.of(
//               context,
//             ).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPlanCard({
//     required int index,
//     required String title,
//     required String credits,
//     required String price,
//     required String duration,
//     required IconData icon,
//     required Color color,
//     bool isBestValue = false,
//   }) {
//     final isSelected = _selectedIndex == index;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedIndex = index;
//         });
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isSelected
//                 ? AppColors.primaryBlue
//                 : AppColors.border.withValues(alpha: 0.1),
//             width: isSelected ? 2 : 1,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withValues(alpha: 0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: color,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(icon, color: Colors.white, size: 28),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           title,
//                           style: Theme.of(context).textTheme.bodyLarge!
//                               .copyWith(fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           credits,
//                           style: Theme.of(context).textTheme.bodySmall,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         'TK. $price',
//                         style: Theme.of(context).textTheme.titleLarge,
//                       ),
//                       Text(
//                         duration,
//                         style: Theme.of(context).textTheme.labelMedium,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             if (isBestValue)
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 4,
//                   ),
//                   decoration: const BoxDecoration(
//                     color: AppColors.primaryBlue,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(14),
//                       bottomRight: Radius.circular(14),
//                     ),
//                   ),
//                   child: const Icon(Icons.star, size: 12, color: Colors.white),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
