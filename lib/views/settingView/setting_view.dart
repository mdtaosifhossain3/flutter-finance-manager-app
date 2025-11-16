import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/languageProvider/language_translator_provider.dart';
import 'package:finance_manager_app/providers/theme_provider.dart';
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
    final items = <Map<String, dynamic>>[
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
      {
        'key': 'shareApp'.tr,
        'icon': Icons.share,
        'color': AppColors.success,
        'action': (BuildContext ctx) {},
      },
      {
        'key': 'contactSupport'.tr,
        'icon': Icons.support_agent,
        'color': AppColors.primaryBlue,
        'action': (BuildContext ctx) {},
      },
      {
        'key': 'faq'.tr,
        'icon': Icons.help_outline,
        'color': Colors.purple,
        'action': (BuildContext ctx) {},
      },
      {
        'key': 'about'.tr,
        'icon': Icons.info_outline,
        'color': Colors.grey,
        'action': (BuildContext ctx) {},
      },
      {
        'key': 'feedback'.tr,
        'icon': Icons.feedback_outlined,
        'color': Colors.teal,
        'action': (BuildContext ctx) {},
      },
      {
        'key': 'termsPolicies'.tr,
        'icon': Icons.description_outlined,
        'color': Colors.indigo,
        'action': (BuildContext ctx) {},
      },

      {
        'key': 'resetApp'.tr,
        'icon': Icons.restore,
        'color': AppColors.error,
        'action': (BuildContext ctx) {},
      },
      {
        'key': 'logout'.tr,
        'icon': Icons.logout,
        'color': AppColors.error,
        'action': (BuildContext ctx) {},
      },
    ];

    return Scaffold(
      appBar: customAppBar(title: "settings".tr),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // determine columns responsively
            int crossAxisCount = 2;
            final w = constraints.maxWidth;
            if (w > 900) {
              crossAxisCount = 4;
            } else if (w > 600) {
              crossAxisCount = 3;
            } else {
              crossAxisCount = 2;
            }

            return Column(
              children: [
                // compact profile row
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Card(
                    elevation: 0.8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                                width: 1.2,
                              ),
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            child: Center(
                              child: Text(
                                'TH',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lets Fluttbiz',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '12123314',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 72),
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                side: BorderSide(
                                  color: Theme.of(context).dividerColor,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                // navigate to edit profile or show dialog
                              },
                              label: const Text(
                                'Free User',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // grid of settings
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.04,
                      vertical: 8,
                    ),
                    child: GridView.builder(
                      itemCount: items.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 10,
                        childAspectRatio: 2.5,
                      ),
                      itemBuilder: (context, index) {
                        final it = items[index];
                        return _buildGridItem(
                          title: it['key'],
                          icon: it['icon'],
                          color: it['color'],
                          onTap: (BuildContext ctx) => it['action'](ctx),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 60),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGridItem({
    required String title,
    required IconData icon,
    required Color color,
    required void Function(BuildContext) onTap,
  }) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),

        onTap: () => onTap(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showThemeOptions(BuildContext context) {
    final provider = context.read<ThemeProvider>();
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        final current = provider.themeMode.toString().split('.').last;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Light'),
                trailing: current == 'light' ? Icon(Icons.check) : null,
                onTap: () {
                  provider.setTheme('Light');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: Text('Dark'),
                trailing: current == 'dark' ? Icon(Icons.check) : null,
                onTap: () {
                  provider.setTheme('Dark');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: Text('System'),
                trailing: current == 'system' ? Icon(Icons.check) : null,
                onTap: () {
                  provider.setTheme('System');
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageOptions(BuildContext context) {
    final provider = context.read<LanguageTranslatorProvider>();
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        final isBangla = provider.locale.languageCode == 'bn';
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('English'),
                trailing: isBangla ? null : Icon(Icons.check),
                onTap: () {
                  provider.setLocale(Locale('en', 'US'));
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: Text('Bangla'),
                trailing: isBangla ? Icon(Icons.check) : null,
                onTap: () {
                  provider.setLocale(Locale('bn', 'BD'));
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
