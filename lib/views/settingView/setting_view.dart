import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/providers/authProvider/auth_provider.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/budget/budget_provider.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/providers/languageProvider/language_translator_provider.dart';
import 'package:finance_manager_app/providers/proProvider/pro_provider.dart';
import 'package:finance_manager_app/providers/theme_provider.dart';
import 'package:finance_manager_app/views/pricingView/pricing_view.dart';
import 'package:finance_manager_app/views/settingView/pages/about_page.dart';
import 'package:finance_manager_app/views/settingView/pages/faq_page.dart';
import 'package:finance_manager_app/views/settingView/pages/feedback_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _userName;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName');
      _userEmail = prefs.getString('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsSections = [
      {
        'title': 'appearance'.tr,
        'items': [
          {
            'key': 'appTheme'.tr,
            'icon': Icons.brightness_6,
            'color': AppColors.primaryBlue,
            'action': (BuildContext ctx) => _showThemeOptions(ctx),
          },
          {
            'key': 'appLanguage'.tr,
            'icon': Icons.language,
            'color': Colors.deepPurple,
            'action': (BuildContext ctx) => _showLanguageOptions(ctx),
          },
        ],
      },
      {
        'title': 'support'.tr,
        'items': [
          // {
          //   'key': 'shareApp'.tr,
          //   'icon': Icons.share,
          //   'color': AppColors.success,
          //   'action': (BuildContext ctx) {},
          // },
          // {
          //   'key': 'contactSupport'.tr,
          //   'icon': Icons.support_agent,
          //   'color': AppColors.primaryBlue,
          //   'action': (BuildContext ctx) {
          //     Get.to(ContactSupportPage());
          //   },
          // },
          {
            'key': 'faq'.tr,
            'icon': Icons.help_outline,
            'color': Colors.purple,
            'action': (BuildContext ctx) {
              Get.to(FAQPage());
            },
          },
          {
            'key': 'feedback'.tr,
            'icon': Icons.feedback_outlined,
            'color': Colors.teal,
            'action': (BuildContext ctx) {
              Get.to(FeedbackPage());
            },
          },
        ],
      },
      // {
      //   'title': "",
      //   'items': [
      //     {
      //       'key': 'about'.tr,
      //       'icon': Icons.info_outline,
      //       'color': Colors.grey,
      //       'action': (BuildContext ctx) {},
      //     },
      //     // {
      //     //   'key': 'termsPolicies'.tr,
      //     //   'icon': Icons.description_outlined,
      //     //   'color': Colors.indigo,
      //     //   'action': (BuildContext ctx) {},
      //     // },
      //   ],
      // },
      {
        'title': 'other'.tr,
        'items': [
          {
            'key': 'premium'.tr,
            'icon': Icons.workspace_premium,
            'color': Colors.amber,
            'action': (BuildContext ctx) {
              Get.to(() => const PricingView());
            },
          },
          {
            'key': 'about'.tr,
            'icon': Icons.info_outline,
            'color': Colors.grey,
            'action': (BuildContext ctx) {
              Get.to(AboutPage());
            },
          },
          {
            'key': 'resetApp'.tr,
            'icon': Icons.restore,
            'color': AppColors.error,
            'action': (BuildContext ctx) {
              _showResetConfirmationDialog(ctx);
            },
          },
          {
            'key': 'logout'.tr,
            'icon': Icons.logout,
            'color': AppColors.error,
            'action': (BuildContext ctx) {
              _showLogoutConfirmationDialog(ctx);
            },
          },
        ],
      },
    ];

    return Scaffold(
      appBar: customAppBar(title: "settings".tr),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            // Pro Status Card
            Consumer<ProProvider>(
              builder: (context, proProvider, child) {
                final isPro = proProvider.isPro;
                final isTrial = proProvider.isTrialActive;
                final daysLeft = isPro
                    ? proProvider.remainingSubscriptionDays
                    : proProvider.remainingTrialDays;

                // Status configuration
                final statusConfig = isPro
                    ? _StatusConfig(
                        label: 'pro_user'.tr,
                        icon: Icons.verified,
                        color: const Color(0xFFFFD700),
                        gradientColors: [
                          const Color(0xFFFFF9C4),
                          Theme.of(context).cardColor,
                        ],
                      )
                    : isTrial
                    ? _StatusConfig(
                        label: 'trial_active'.tr,
                        icon: Icons.hourglass_top,
                        color: AppColors.primaryPurple,
                        gradientColors: [
                          AppColors.primaryPurple.withValues(alpha: 0.15),
                          Theme.of(context).cardColor,
                        ],
                      )
                    : _StatusConfig(
                        label: 'free_user'.tr,
                        icon: Icons.person,
                        color: AppColors.primaryBlue,
                        gradientColors: [
                          AppColors.primaryBlue.withValues(alpha: 0.1),
                          Theme.of(context).cardColor,
                        ],
                      );

                return Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,

                    borderRadius: BorderRadius.circular(24),

                    border: Border.all(
                      color: statusConfig.color.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: isPro
                          ? null
                          : () => Get.to(() => const PricingView()),
                      borderRadius: BorderRadius.circular(24),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // User Info Row
                            Row(
                              children: [
                                _buildAvatar(statusConfig.color),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _userName ?? 'guest_user'.tr,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _userEmail ?? 'no_email_linked'.tr,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: AppColors.textSecondary,
                                              fontSize: 12,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Status Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).cardColor.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: statusConfig.color.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: statusConfig.color.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      statusConfig.icon,
                                      color: statusConfig.color,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          statusConfig.label,
                                          style: TextStyle(
                                            color: statusConfig.color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        if ((isPro || isTrial) && daysLeft > 0)
                                          Text(
                                            '$daysLeft ${'days_left'.tr}',
                                            style: TextStyle(
                                              color: statusConfig.color
                                                  .withValues(alpha: 0.8),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (!isPro)
                                    ElevatedButton(
                                      onPressed: () =>
                                          Get.to(() => const PricingView()),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: statusConfig.color,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'pro_button'.tr,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            // Settings Sections
            ...settingsSections.map((section) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      section['title'] as String,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ...(section['items'] as List<Map<String, dynamic>>)
                            .asMap()
                            .entries
                            .map((entry) {
                              final index = entry.key;
                              final item = entry.value;
                              final isLast =
                                  index ==
                                  (section['items'] as List).length - 1;

                              return _buildListItem(
                                title: item['key'],
                                icon: item['icon'],
                                color: item['color'],
                                onTap: (BuildContext ctx) =>
                                    item['action'](ctx),
                                isLast: isLast,
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(Color color) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
      ),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: color.withValues(alpha: 0.1),
        child: Text(
          _userName?.isNotEmpty == true ? _userName![0].toUpperCase() : 'U',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildListItem({
    required String title,
    required IconData icon,
    required Color color,
    required void Function(BuildContext) onTap,
    required bool isLast,
  }) {
    return InkWell(
      onTap: () => onTap(context),
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(isLast ? 0 : 12),
        bottom: Radius.circular(isLast ? 12 : 0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: Theme.of(
                      context,
                    ).dividerColor.withValues(alpha: 0.5),
                    width: 0.5,
                  ),
                ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary.withValues(alpha: 0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeOptions(BuildContext context) {
    final provider = context.read<ThemeProvider>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final current = provider.themeMode.toString().split('.').last;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Text(
                    'appTheme'.tr,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.light_mode),
                  title: Text('light_theme'.tr),
                  trailing: current == 'light'
                      ? Icon(Icons.check, color: AppColors.primaryBlue)
                      : null,
                  onTap: () {
                    provider.setTheme('Light');
                    Navigator.pop(ctx);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.dark_mode),
                  title: Text('dark_theme'.tr),
                  trailing: current == 'dark'
                      ? Icon(Icons.check, color: AppColors.primaryBlue)
                      : null,
                  onTap: () {
                    provider.setTheme('Dark');
                    Navigator.pop(ctx);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.brightness_auto),
                  title: Text('system_theme'.tr),
                  trailing: current == 'system'
                      ? Icon(Icons.check, color: AppColors.primaryBlue)
                      : null,
                  onTap: () {
                    provider.setTheme('System');
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguageOptions(BuildContext context) {
    final provider = context.read<LanguageTranslatorProvider>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final isBangla = provider.locale.languageCode == 'bn';
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Text(
                    'appLanguage'.tr,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
                  title: Text('english_lang'.tr),
                  trailing: isBangla
                      ? null
                      : Icon(Icons.check, color: AppColors.primaryBlue),
                  onTap: () {
                    provider.setLocale(const Locale('en', 'US'));
                    Navigator.pop(ctx);
                  },
                ),
                ListTile(
                  leading: const Text('🇧🇩', style: TextStyle(fontSize: 24)),
                  title: Text('bangla_lang'.tr),
                  trailing: isBangla
                      ? Icon(Icons.check, color: AppColors.primaryBlue)
                      : null,
                  onTap: () {
                    provider.setLocale(const Locale('bn', 'BD'));
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showResetConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'reset_confirmation_title'.tr,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.error,
          ),
        ),
        content: Text(
          'reset_confirmation_message'.tr,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'cancel'.tr,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx); // Close dialog first

              // 1. Delete Local Data
              await context.read<AddExpenseProvider>().deleteFullTransaction();
              if (!context.mounted) return;
              await context.read<BudgetProvider>().deleteFullBudget();

              // 2. Delete Cloud Data & Account
              // This will also clear SharedPreferences and navigate to Login
              if (context.mounted) {
                await context.read<AuthProvider>().deleteAccount();
              }
            },
            child: Text(
              'yes'.tr,
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'logout'.tr,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.error,
          ),
        ),
        content: Text(
          'logout_confirmation'.tr,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'cancel'.tr,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
            child: Text(
              'logout'.tr,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper class (add to your file)
class _StatusConfig {
  final String label;
  final IconData icon;
  final Color color;
  final List<Color> gradientColors;

  _StatusConfig({
    required this.label,
    required this.icon,
    required this.color,
    required this.gradientColors,
  });
}
