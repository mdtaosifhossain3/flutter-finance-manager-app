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
  bool notificationsEnabled = true;
  bool budgetAlertsEnabled = true;
  bool billRemindersEnabled = true;
  bool autoImportEnabled = false;
  bool appLockEnabled = true;
  String autoLockTimer = '5 minutes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "settings".tr),
      body: SafeArea(
        child: Column(
          children: [
            // _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).shadowColor.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // User Avatar
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surface,
                              child: Icon(
                                Icons.person,
                                size: 35,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // User Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Taosif Hossain",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        size: 16,
                                        color: AppColors.textMuted,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "01747211887",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelMedium,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ), //  _buildProfileCard(),
                    SizedBox(height: 24),
                    _buildGeneralSettings(),
                    SizedBox(height: 24),
                    _buildFinanceSettings(),
                    SizedBox(height: 24),
                    _buildPrivacySettings(),
                    SizedBox(height: 24),
                    _buildOtherSettings(),
                    SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSettings() {
    return _buildSection('generalAppSettings'.tr, [
      _buildDropdownSetting(
        'appTheme'.tr,
        context
            .watch<ThemeProvider>()
            .themeMode
            .toString()
            .split('.')
            .last
            .capitalize!,
        ['Light', 'Dark', 'System'],
        (value) => context.read<ThemeProvider>().setTheme(value!),
      ),
      _buildDropdownSetting(
        'appLanguage'.tr,
        context.watch<LanguageTranslatorProvider>().locale.languageCode == 'bn'
            ? 'Bangla'
            : 'English',
        ['Bangla', 'English'],
        (value) {
          if (value == null) return;
          context.read<LanguageTranslatorProvider>().setLocale(
            value == 'Bangla' ? Locale('bn', 'BD') : Locale('en', 'US'),
          );
        },
      ),
      _buildSwitchSetting(
        'notifications'.tr,
        'notificationsDescription'.tr,
        notificationsEnabled,
        (value) => setState(() => notificationsEnabled = value),
      ),
      _buildSwitchSetting(
        'budgetAlerts'.tr,
        'budgetAlertsDescription'.tr,
        budgetAlertsEnabled,
        (value) => setState(() => budgetAlertsEnabled = value),
      ),
      _buildSwitchSetting(
        'billReminders'.tr,
        'billRemindersDescription'.tr,
        billRemindersEnabled,
        (value) => setState(() => billRemindersEnabled = value),
      ),
      _buildActionSetting('logout'.tr, Icons.logout, AppColors.error, () {}),
    ]);
  }

  Widget _buildFinanceSettings() {
    return _buildSection('financeSpecificSettings'.tr, [
      _buildClickableSetting(
        'defaultAccount'.tr,
        'defaultAccountDescription'.tr,
        'mainWallet'.tr,
        () {},
      ),
      _buildSwitchSetting(
        'automaticTransactionImport'.tr,
        'automaticTransactionImportDescription'.tr,
        autoImportEnabled,
        (value) => setState(() => autoImportEnabled = value),
      ),
    ]);
  }

  Widget _buildPrivacySettings() {
    return _buildSection('privacySecurity'.tr, [
      _buildSwitchSetting(
        'appLock'.tr,
        'appLockDescription'.tr,
        appLockEnabled,
        (value) => setState(() => appLockEnabled = value),
      ),
      _buildDropdownSetting(
        'autoLockTimer'.tr,
        autoLockTimer,
        ['1 minute', '5 minutes', '15 minutes', '30 minutes', 'never'],
        (value) => setState(() => autoLockTimer = value!),
      ),
      _buildActionSetting(
        'clearLocalData'.tr,
        Icons.delete_outline,
        AppColors.warning,
        () {},
      ),
      _buildActionSetting('resetApp'.tr, Icons.restore, AppColors.error, () {}),
      _buildActionSetting(
        'exportData'.tr,
        Icons.file_download,
        AppColors.primaryBlue,
        () {},
      ),
    ]);
  }

  Widget _buildOtherSettings() {
    return _buildSection('otherSettings'.tr, [
      _buildActionSetting(
        'rateUs'.tr,
        Icons.star_outline,
        AppColors.warning,
        () {},
      ),
      _buildActionSetting('shareApp'.tr, Icons.share, AppColors.success, () {}),
      _buildActionSetting(
        'contactSupport'.tr,
        Icons.support_agent,
        AppColors.primaryBlue,
        () {},
      ),
      _buildActionSetting('faq'.tr, Icons.help_outline, Colors.purple, () {}),
      _buildActionSetting('about'.tr, Icons.info_outline, Colors.grey, () {}),
      _buildActionSetting(
        'feedback'.tr,
        Icons.feedback_outlined,
        Colors.teal,
        () {},
      ),
      _buildActionSetting(
        'termsPolicies'.tr,
        Icons.description_outlined,
        Colors.indigo,
        () {},
      ),
      _buildClickableSetting(
        'versionInfo'.tr,
        'versionInfoDescription'.tr,
        'v1.0.2 (Build 45)',
        () {},
      ),
    ]);
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children.asMap().entries.map((entry) {
              int index = entry.key;
              Widget child = entry.value;
              return Column(
                children: [
                  child,
                  if (index < children.length - 1)
                    Divider(height: 1, color: Theme.of(context).dividerColor),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchSetting(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      subtitle: Text(
        subtitle,
        style: Theme.of(
          context,
        ).textTheme.bodySmall!.copyWith(color: AppColors.textSecondary),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primaryBlue,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildDropdownSetting(
    String title,
    String value,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return ListTile(
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        underline: SizedBox(),
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option, style: TextStyle(fontSize: 14)),
          );
        }).toList(),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildActionSetting(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: color, size: 24),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.textSecondary,
        size: 16,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildClickableSetting(
    String title,
    String subtitle,
    String value,
    VoidCallback onTap,
  ) {
    return ListTile(
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      subtitle: Text(
        subtitle,
        style: Theme.of(
          context,
        ).textTheme.bodySmall!.copyWith(color: AppColors.textSecondary),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.textSecondary,
            size: 16,
          ),
        ],
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
