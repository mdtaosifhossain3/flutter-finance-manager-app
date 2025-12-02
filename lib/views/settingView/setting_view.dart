import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/budget/budget_provider.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/providers/languageProvider/language_translator_provider.dart';
import 'package:finance_manager_app/providers/theme_provider.dart';
import 'package:finance_manager_app/views/settingView/pages/about_page.dart';
import 'package:finance_manager_app/views/settingView/pages/faq_page.dart';
import 'package:finance_manager_app/views/settingView/pages/feedback_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
          // {
          //   'key': 'logout'.tr,
          //   'icon': Icons.logout,
          //   'color': AppColors.error,
          //   'action': (BuildContext ctx) {},
          // },
        ],
      },
    ];

    return Scaffold(
      appBar: customAppBar(title: "settings".tr),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            // Header Card
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            //   child: Container(
            //     width: double.infinity,
            //     decoration: BoxDecoration(
            //       gradient: LinearGradient(
            //         begin: Alignment.topLeft,
            //         end: Alignment.bottomRight,
            //         colors: [
            //           AppColors.primaryBlue.withValues(alpha: 0.9),
            //           AppColors.primaryPurple.withValues(alpha: 0.7),
            //         ],
            //       ),
            //       borderRadius: BorderRadius.circular(16),
            //       boxShadow: [
            //         BoxShadow(
            //           color: AppColors.primaryBlue.withValues(alpha: 0.3),
            //           blurRadius: 12,
            //           offset: const Offset(0, 4),
            //         ),
            //       ],
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.all(24),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             'preferences'.tr,
            //             style: Theme.of(context).textTheme.headlineSmall
            //                 ?.copyWith(
            //                   color: Colors.white,
            //                   fontWeight: FontWeight.w700,
            //                 ),
            //           ),
            //           const SizedBox(height: 8),
            //           Text(
            //             'manage_app_settings'.tr,
            //             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            //               color: Colors.white70,
            //               height: 1.4,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

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
                  title: const Text('Light'),
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
                  title: const Text('Dark'),
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
                  title: const Text('System'),
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
                  title: const Text('English'),
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
                  title: const Text('বাংলা'),
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
            onPressed: () {
              context.read<AddExpenseProvider>().deleteFullTransaction();
              context.read<BudgetProvider>().deleteFullBudget();

              Navigator.pop(ctx);
              Get.snackbar(
                'successTitle'.tr,
                'resetDescription'
                    .tr, // Reusing a success message or add a new one if needed. 'budgetDeletedSuccess' is "Budget Deleted Successfully", maybe not perfect but close. Or just generic success.
                // Actually, let's use a generic success or just rely on the provider if it shows one.
                // The provider usually handles logic.
                // Let's check what deleteFullTransaction does.
                backgroundColor: AppColors.success,
                colorText: Colors.white,
              );
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
}
