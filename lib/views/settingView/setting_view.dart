import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/language_translator_provider.dart';
import 'package:finance_manager_app/providers/theme_provider.dart';
import 'package:finance_manager_app/views/UserprofileView/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
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
                    _buildProfileCard(),
                    SizedBox(height: 24),
                    _buildGeneralSettings(),
                    SizedBox(height: 24),
                    _buildFinanceSettings(),
                    SizedBox(height: 24),
                    _buildPrivacySettings(),
                    SizedBox(height: 24),
                    _buildOtherSettings(),
                    SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return GestureDetector(
      onTap: () => Get.to(ProfileView()),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daniel Travis',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '+1 (555) 123-4567',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            //   Icon(Icons.edit, color: Colors.grey[400], size: 20),
            Icon(Icons.arrow_forward_ios, color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSettings() {
    print(
      'Building General Settings with theme: ${context.watch<ThemeProvider>().themeMode.toString().split('.').last.capitalize!}',
    );
    return _buildSection('🔧 General App Settings', [
      _buildDropdownSetting(
        'App Theme',
        context
            .watch<ThemeProvider>()
            .themeMode
            .toString()
            .split('.')
            .last
            .capitalize!,
        ['Light', 'Dark', 'System'],
        (value) => setState(() {
          context.read<ThemeProvider>().setTheme(value!);
        }),
      ),
      _buildDropdownSetting(
        'App Language',
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
        'Notifications',
        'Reminders, budget alerts, bill due dates',
        notificationsEnabled,
        (value) => setState(() => notificationsEnabled = value),
      ),
      _buildSwitchSetting(
        'Budget Alerts',
        'Get notified when approaching budget limits',
        budgetAlertsEnabled,
        (value) => setState(() => budgetAlertsEnabled = value),
      ),
      _buildSwitchSetting(
        'Bill Reminders',
        'Notify before bill due dates',
        billRemindersEnabled,
        (value) => setState(() => billRemindersEnabled = value),
      ),
      _buildActionSetting('Logout', Icons.logout, AppColors.error, () {}),
    ]);
  }

  Widget _buildFinanceSettings() {
    return _buildSection('💰 Finance-Specific Settings', [
      _buildClickableSetting(
        'Default Account',
        'Choose which wallet/account opens by default',
        'Main Wallet',
        () {},
      ),
      _buildSwitchSetting(
        'Automatic Transaction Import',
        'Sync transactions from bank/CSV files',
        autoImportEnabled,
        (value) => setState(() => autoImportEnabled = value),
      ),
    ]);
  }

  Widget _buildPrivacySettings() {
    return _buildSection('🔒 Privacy & Security', [
      _buildSwitchSetting(
        'App Lock',
        'PIN, fingerprint, or FaceID protection',
        appLockEnabled,
        (value) => setState(() => appLockEnabled = value),
      ),
      _buildDropdownSetting(
        'Auto-Lock Timer',
        autoLockTimer,
        ['1 minute', '5 minutes', '15 minutes', '30 minutes', 'Never'],
        (value) => setState(() => autoLockTimer = value!),
      ),
      _buildActionSetting(
        'Clear Local Data',
        Icons.delete_outline,
        AppColors.warning,
        () {},
      ),
      _buildActionSetting('Reset App', Icons.restore, AppColors.error, () {}),
      _buildActionSetting(
        'Export Data',
        Icons.file_download,
        AppColors.primaryBlue,
        () {},
      ),
    ]);
  }

  Widget _buildOtherSettings() {
    return _buildSection('🌐 Other Settings', [
      _buildActionSetting(
        'Rate Us',
        Icons.star_outline,
        AppColors.warning,
        () {},
      ),
      _buildActionSetting('Share App', Icons.share, AppColors.success, () {}),
      _buildActionSetting(
        'Contact Support',
        Icons.support_agent,
        AppColors.primaryBlue,
        () {},
      ),
      _buildActionSetting('FAQ', Icons.help_outline, Colors.purple, () {}),
      _buildActionSetting('About', Icons.info_outline, Colors.grey, () {}),
      _buildActionSetting(
        'Feedback',
        Icons.feedback_outlined,
        Colors.teal,
        () {},
      ),
      _buildActionSetting(
        'Terms & Policies',
        Icons.description_outlined,
        Colors.indigo,
        () {},
      ),
      _buildClickableSetting(
        'Version Info',
        'Build version and update checker',
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
                color: Theme.of(context).shadowColor.withOpacity(0.05),
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
