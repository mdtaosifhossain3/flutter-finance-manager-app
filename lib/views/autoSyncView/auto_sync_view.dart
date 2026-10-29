import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/services/autoSync/auto_sync_service.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:finance_manager_app/views/autoSyncView/auto_sync_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

/// Turn Auto Sync on, see what it still needs, and review detected
/// transactions.
class AutoSyncView extends StatefulWidget {
  const AutoSyncView({super.key});

  @override
  State<AutoSyncView> createState() => _AutoSyncViewState();
}

class _AutoSyncViewState extends State<AutoSyncView>
    with WidgetsBindingObserver {
  AutoSyncStatus _status = AutoSyncStatus.off;
  List<AutoSyncItem> _pending = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AutoSyncService.changes.addListener(_refresh);
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AutoSyncService.changes.removeListener(_refresh);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Back from Android settings: show what the user changed.
    if (state == AppLifecycleState.resumed) _refresh();
  }

  Future<void> _refresh() async {
    final status = await AutoSyncService.status();
    final pending = await AutoSyncService.pending();
    if (!mounted) return;
    setState(() {
      _status = status;
      _pending = pending;
      _loading = false;
    });
  }

  Future<void> _toggle(bool on) async {
    if (!on) {
      await AutoSyncService.setEnabled(false);
      await _refresh();
      return;
    }
    // Prominent disclosure before touching any permission.
    final agreed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('auto_sync_disclosure_title'.tr),
        content: SingleChildScrollView(
          child: Text('auto_sync_disclosure_body'.tr),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('auto_sync_no_thanks'.tr),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: Text('auto_sync_agree'.tr),
          ),
        ],
      ),
    );
    if (agreed != true) return;

    await AutoSyncService.setLanguage(Get.locale?.languageCode);
    await AutoSyncService.setEnabled(true);
    await _askNotifications();
    final status = await AutoSyncService.status();
    if (!status.access) await _openAccess();
    await _refresh();
  }

  Future<void> _askNotifications() async {
    final current = await Permission.notification.status;
    if (current.isGranted) return;
    final result = await Permission.notification.request();
    if (result.isPermanentlyDenied) await AutoSyncService.openAppSettings();
  }

  Future<void> _openAccess() async {
    final opened = await AutoSyncService.openAccessSettings();
    if (!opened) {
      Get.snackbar('auto_sync'.tr, 'auto_sync_open_settings_failed'.tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: customAppBar(
        title: 'auto_sync'.tr,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _intro(textTheme),
                  const SizedBox(height: 16),
                  Card(
                    margin: EdgeInsets.zero,
                    child: SwitchListTile(
                      value: _status.enabled,
                      onChanged: _toggle,
                      title: Text('auto_sync_enable'.tr),
                      subtitle: Text(
                        _status.working
                            ? 'auto_sync_on'.tr
                            : _status.enabled
                            ? 'auto_sync_needs_access'.tr
                            : 'auto_sync_off'.tr,
                        style: TextStyle(
                          color: _status.working
                              ? AppColors.success
                              : _status.enabled
                              ? AppColors.warning
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  if (_status.enabled) ...[
                    const SizedBox(height: 16),
                    _sectionTitle('auto_sync_setup'.tr, textTheme),
                    _statusTile(
                      icon: Icons.notifications_none_rounded,
                      title: 'auto_sync_access'.tr,
                      subtitle: _status.access
                          ? 'auto_sync_access_ok'.tr
                          : 'auto_sync_access_help'.tr,
                      ok: _status.access,
                      onFix: _openAccess,
                    ),
                    _statusTile(
                      icon: Icons.notification_important_outlined,
                      title: 'auto_sync_popups'.tr,
                      subtitle: _status.notifications
                          ? 'auto_sync_popups_ok'.tr
                          : 'auto_sync_popups_help'.tr,
                      ok: _status.notifications,
                      onFix: () async {
                        await _askNotifications();
                        await _refresh();
                      },
                    ),
                    _statusTile(
                      icon: Icons.battery_charging_full_rounded,
                      title: 'auto_sync_battery'.tr,
                      subtitle: 'auto_sync_battery_help'.tr,
                      ok: null,
                      onFix: AutoSyncService.openAppSettings,
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _sectionTitle(
                          'auto_sync_pending'.trParams({
                            'count': HelperFunctions.convertToBanglaDigits(
                              '${_pending.length}',
                            ),
                          }),
                          textTheme,
                        ),
                      ),
                      if (_pending.length > 1)
                        TextButton(
                          onPressed: () => openAutoSyncItems(_pending),
                          child: Text('auto_sync_review_all'.tr),
                        ),
                    ],
                  ),
                  if (_pending.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'auto_sync_none'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  else
                    for (final item in _pending) _pendingCard(item, textTheme),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'auto_sync_privacy'.tr,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _intro(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.sync_rounded,
            color: AppColors.primaryBlue,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'auto_sync_title'.tr,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text('auto_sync_desc'.tr, style: textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text, TextTheme textTheme) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
    ),
  );

  /// [ok]: true = done, false = needs action, null = advice only.
  Widget _statusTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool? ok,
    required VoidCallback onFix,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        isThreeLine: ok != true,
        trailing: ok == true
            ? const Icon(Icons.check_circle, color: AppColors.success)
            : TextButton(
                onPressed: onFix,
                child: Text(
                  ok == false ? 'auto_sync_allow'.tr : 'auto_sync_open'.tr,
                ),
              ),
      ),
    );
  }

  Widget _pendingCard(AutoSyncItem item, TextTheme textTheme) {
    final color = item.isIncome
        ? AppColors.success
        : item.isTransfer
        ? AppColors.primaryBlue
        : AppColors.error;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    autoSyncLine(item),
                    style: textTheme.bodyLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  autoSyncAmount(item.amount),
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${autoSyncWallet(item)}  •  ${HelperFunctions.getFormattedDateTime(item.postedAt)}',
              style: textTheme.bodySmall,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => AutoSyncService.remove([item.id]),
                  child: Text('auto_sync_ignore'.tr),
                ),
                const SizedBox(width: 4),
                ElevatedButton(
                  onPressed: () => openAutoSyncItems([item]),
                  child: Text('auto_sync_add'.tr),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
