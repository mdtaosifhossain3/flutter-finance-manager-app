import 'package:finance_manager_app/views/pricingView/subscription_plan.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class PremiumFeatureView extends StatelessWidget {
  const PremiumFeatureView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                  vertical: MediaQuery.of(context).size.height * 0.02,
                ),
                child: Column(
                  children: [
                    // Header Section
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF6366F1,
                            ).withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        FontAwesomeIcons.crown,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'go_premium'.tr,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'unlock_all_features'.tr,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),

                    // Features Card
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildFeatureItem(
                            icon: Icons.auto_awesome,
                            title: 'add_with_ai'.tr,
                            color: const Color(0xFF8B5CF6),
                            context: context,
                          ),
                          _buildFeatureItem(
                            icon: Icons.category,
                            title: 'smart_categorization'.tr,
                            color: const Color(0xFF3B82F6),
                            context: context,
                          ),
                          _buildFeatureItem(
                            icon: Icons.swap_horiz,
                            title: 'given_taken'.tr,
                            color: const Color(0xFF10B981),
                            context: context,
                          ),
                          _buildFeatureItem(
                            icon: Icons.account_balance_wallet,
                            title: 'set_budget'.tr,
                            color: const Color(0xFFF59E0B),
                            context: context,
                          ),
                          _buildFeatureItem(
                            icon: Icons.notifications_active,
                            title: 'set_reminder'.tr,
                            color: const Color(0xFFEF4444),
                            context: context,
                          ),
                          _buildFeatureItem(
                            icon: Icons.savings,
                            title: 'savings'.tr,
                            color: const Color(0xFF14B8A6),
                            context: context,
                          ),
                          _buildFeatureItem(
                            icon: Icons.note_alt,
                            title: 'note'.tr,
                            color: const Color(0xFF6366F1),
                            context: context,
                          ),
                          _buildFeatureItem(
                            icon: Icons.bar_chart,
                            title: 'monthly_weekly_reports'.tr,
                            color: const Color(0xFF06B6D4),
                            context: context,
                          ),
                          _buildFeatureItem(
                            icon: Icons.block,
                            title: 'no_ads'.tr,
                            color: const Color(0xFFF43F5E),
                            context: context,
                          ),
                          _buildFeatureItem(
                            icon: Icons.bolt,
                            title: 'unlimited_ai_credits'.tr,
                            color: const Color(0xFFEAB308),
                            context: context,
                          ),
                          _buildFeatureItem(
                            icon: Icons.headset_mic,
                            title: 'premium_support'.tr,
                            color: const Color(0xFFEC4899),
                            isLast: true,
                            context: context,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Buy Now Button
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle buy now action
                        Get.to(SubscriptionPlansScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'buy'.tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'cancel_anytime'.tr,
                    style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required Color color,
    bool isLast = false,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor, width: .11),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.bodyLarge),
          ),
          const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 24),
        ],
      ),
    );
  }
}
