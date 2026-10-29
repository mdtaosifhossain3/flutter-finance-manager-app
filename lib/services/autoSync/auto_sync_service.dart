import 'package:finance_manager_app/services/parser/sms_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// A bank / wallet transaction the phone saw in a notification and that is
/// waiting for the user to add or ignore it.
class AutoSyncItem {
  final int id;
  final String text;

  /// Package of the app that showed the notification (SMS app or wallet).
  final String source;

  /// Notification title, usually the SMS sender ("bKash", "16216"…).
  final String sender;
  final int amount;
  final String kind;
  final String? party;
  final String? trxId;
  final DateTime postedAt;

  const AutoSyncItem({
    required this.id,
    required this.text,
    required this.source,
    required this.sender,
    required this.amount,
    required this.kind,
    this.party,
    this.trxId,
    required this.postedAt,
  });

  factory AutoSyncItem.fromMap(Map<dynamic, dynamic> m) => AutoSyncItem(
    id: (m['id'] as num).toInt(),
    text: (m['text'] as String?) ?? '',
    source: (m['source'] as String?) ?? '',
    sender: (m['sender'] as String?) ?? '',
    amount: int.tryParse('${m['amount']}') ?? 0,
    kind: (m['kind'] as String?) ?? '',
    party: m['party'] as String?,
    trxId: m['trxId'] as String?,
    postedAt: DateTime.fromMillisecondsSinceEpoch(
      (m['postedAt'] as num?)?.toInt() ?? 0,
    ),
  );

  /// The full parse used when saving, or null if the text can't be read.
  ParsedSms? get parsed => SmsParser.parse(text, now: postedAt);

  /// Translation key of the description, e.g. `sms_sent_to`.
  String get titleKey =>
      const {
        'cash_out': 'sms_cash_out',
        'cash_in': 'sms_cash_in',
        'atm': 'sms_atm',
        'add_money': 'sms_add_money',
        'recharge': 'sms_recharge',
        'bill': 'sms_bill',
        'received': 'sms_received_from',
        'sent': 'sms_sent_to',
        'payment': 'sms_payment_to',
      }[kind] ??
      'sms_debit';

  bool get isIncome => kind == 'received';
  bool get isTransfer =>
      const {'cash_out', 'cash_in', 'atm', 'add_money'}.contains(kind);
}

class AutoSyncStatus {
  /// The user turned Auto Sync on in the app.
  final bool enabled;

  /// Notification access granted in Android settings.
  final bool access;

  /// The app may post the "Add to expense?" notification.
  final bool notifications;

  const AutoSyncStatus({
    required this.enabled,
    required this.access,
    required this.notifications,
  });

  static const off = AutoSyncStatus(
    enabled: false,
    access: false,
    notifications: false,
  );

  /// Everything needed for pop-ups with the app closed.
  bool get working => enabled && access;
}

/// Talks to the Android notification listener (see
/// TransactionNotificationListener.kt). Android only; elsewhere every call
/// is a harmless no-op.
class AutoSyncService {
  static const _channel = MethodChannel('hishab_rakhi/auto_sync');

  static void Function(AutoSyncItem item)? _onDetected;
  static VoidCallback? _onOpenRequested;

  /// Bumped whenever the pending list may have changed.
  static final ValueNotifier<int> changes = ValueNotifier(0);

  /// Called by the main screen; the handlers run for events from Android.
  static void attach({
    required void Function(AutoSyncItem item) onDetected,
    required VoidCallback onOpenRequested,
  }) {
    _onDetected = onDetected;
    _onOpenRequested = onOpenRequested;
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onDetected':
          changes.value++;
          final args = call.arguments;
          if (args is Map) _onDetected?.call(AutoSyncItem.fromMap(args));
        case 'onPendingChanged':
          changes.value++;
        case 'onOpenRequested':
          _onOpenRequested?.call();
      }
      return null;
    });
    _invoke('setUiReady', true);
  }

  static void detach() {
    _invoke('setUiReady', false);
    _onDetected = null;
    _onOpenRequested = null;
  }

  static Future<T?> _invoke<T>(String method, [Object? args]) async {
    if (defaultTargetPlatform != TargetPlatform.android || kIsWeb) return null;
    try {
      return await _channel.invokeMethod<T>(method, args);
    } on MissingPluginException {
      return null;
    } catch (e) {
      debugPrint('AutoSyncService.$method: $e');
      return null;
    }
  }

  static Future<AutoSyncStatus> status() async {
    final m = await _invoke<Map<dynamic, dynamic>>('status');
    if (m == null) return AutoSyncStatus.off;
    return AutoSyncStatus(
      enabled: m['enabled'] == true,
      access: m['access'] == true,
      notifications: m['notifications'] == true,
    );
  }

  static Future<void> setEnabled(bool on) => _invoke('setEnabled', on);

  /// Language of the pop-up text: 'bn' or 'en'.
  static Future<void> setLanguage(String? code) =>
      _invoke('setLanguage', code == 'en' ? 'en' : 'bn');

  /// Opens Android's Notification access screen. False if it couldn't.
  static Future<bool> openAccessSettings() async =>
      await _invoke<bool>('openAccessSettings') ?? false;

  static Future<void> openAppSettings() => _invoke('openAppSettings');

  static Future<List<AutoSyncItem>> pending() async {
    final list = await _invoke<List<dynamic>>('pending') ?? const [];
    final items = [
      for (final m in list)
        if (m is Map) AutoSyncItem.fromMap(m),
    ];
    // Newest first.
    items.sort((a, b) => b.postedAt.compareTo(a.postedAt));
    return items;
  }

  static Future<void> remove(Iterable<int> ids) async {
    if (ids.isEmpty) return;
    await _invoke('remove', ids.toList());
    changes.value++;
  }

  /// The item the user tapped in a notification, once.
  static Future<int?> takeOpenRequest() async =>
      (await _invoke<num>('takeOpenRequest'))?.toInt();
}
