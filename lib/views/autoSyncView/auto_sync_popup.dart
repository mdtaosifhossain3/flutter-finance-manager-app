import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/services/autoSync/auto_sync_service.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:finance_manager_app/views/smsImportView/sms_import_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

String autoSyncAmount(int v) =>
    '৳${HelperFunctions.convertToBanglaDigits('$v')}';

/// "Sent to 01712345678", "Cash out"…
String autoSyncLine(AutoSyncItem item) =>
    item.party == null ? item.titleKey.tr : '${item.titleKey.tr} ${item.party}';

/// Wallet name for the item: bKash, Nagad, Bank…
String autoSyncWallet(AutoSyncItem item) {
  final wallet = item.parsed?.wallet ?? 'bkash';
  return wallet == 'bankTransfer' || wallet == 'debitCard'
      ? 'auto_sync_bank'.tr
      : wallet.tr;
}

String autoSyncQuestion(AutoSyncItem item) => item.isTransfer
    ? 'auto_sync_ask_transfer'.tr
    : item.isIncome
    ? 'auto_sync_ask_income'.tr
    : 'auto_sync_ask_expense'.tr;

/// Opens the SMS review screen with these items parsed and ready to save.
Future<void> openAutoSyncItems(List<AutoSyncItem> items) async {
  if (items.isEmpty) return;
  await Get.to(
    () => SmsImportView(
      // One message per paragraph; the texts are single-line.
      initialText: items.map((i) => i.text).join('\n\n'),
      autoSyncIds: [for (final i in items) i.id],
    ),
  );
  AutoSyncService.changes.value++;
}

bool _popupOpen = false;

/// In-app "৳500 Sent to … Add to expense?" when the app is open.
Future<void> showAutoSyncPopup(AutoSyncItem item) async {
  // One at a time; any others wait in the Auto Sync list.
  if (_popupOpen) {
    Get.snackbar('auto_sync'.tr, 'auto_sync_more_waiting'.tr);
    return;
  }
  _popupOpen = true;
  try {
    final add = await Get.dialog<bool>(
      AlertDialog(
        icon: const Icon(
          Icons.notifications_active_outlined,
          color: AppColors.primaryBlue,
          size: 32,
        ),
        title: Text(
          'auto_sync_detected'.trParams({'wallet': autoSyncWallet(item)}),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              autoSyncAmount(item.amount),
              style: Get.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: item.isIncome ? AppColors.success : AppColors.error,
              ),
            ),
            const SizedBox(height: 4),
            Text(autoSyncLine(item), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(
              autoSyncQuestion(item),
              style: Get.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('auto_sync_ignore'.tr),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: Text('auto_sync_add'.tr),
          ),
        ],
      ),
    );
    // Tapping outside keeps it in the list for later.
    if (add == true) {
      await openAutoSyncItems([item]);
    } else if (add == false) {
      await AutoSyncService.remove([item.id]);
    }
  } finally {
    _popupOpen = false;
  }
}

/// Handles a tap on the "Add to expense?" notification.
Future<void> handleAutoSyncOpenRequest() async {
  final id = await AutoSyncService.takeOpenRequest();
  if (id == null) return;
  final items = await AutoSyncService.pending();
  final item = items.where((i) => i.id == id).firstOrNull;
  if (item != null) await openAutoSyncItems([item]);
}
