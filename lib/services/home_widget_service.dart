import 'package:finance_manager_app/config/db/local/category_db/add_transaction_db_helper.dart';
import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';

/// Writes today's and this month's numbers for the Android home screen
/// widget (TransactionWidget.kt) and asks it to redraw.
class HomeWidgetService {
  static const _qualifiedName =
      'com.finzycash.expensebudgetmanager.TransactionWidget';

  /// What the user tapped on the widget.
  static const addUri = 'hishabrakhi://add';
  static const voiceUri = 'hishabrakhi://voice';

  static Future<void> refresh() async {
    if (defaultTargetPlatform != TargetPlatform.android || kIsWeb) return;
    try {
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, 1);
      final end = DateTime(now.year, now.month + 1, 1);
      final rows = await AddTransactionDbHelper.getInstance
          .getTransactionsByDateRange(
            start.toIso8601String(),
            end.toIso8601String(),
          );
      final txs = rows.map(TransactionModel.fromMap).toList();

      var today = 0, month = 0, income = 0;
      for (final t in txs) {
        if (t.type == TransactionType.expense) {
          month += t.amount;
          if (t.date.day == now.day) today += t.amount;
        } else if (t.includeInTotal) {
          income += t.amount;
        }
      }

      String taka(int v) =>
          '${v < 0 ? '-' : ''}৳${HelperFunctions.convertToBanglaDigits('${v.abs()}')}';

      final data = <String, String>{
        'w_title': 'app_title_widget'.tr,
        'w_today_label': 'widget_today'.tr,
        'w_today': taka(today),
        'w_month_label': 'widget_this_month'.tr,
        'w_month': taka(month),
        'w_left': income > 0
            ? 'widget_month_left'.trParams({'amount': taka(income - month)})
            : '',
        'w_add_label': 'widget_add'.tr,
      };
      for (final e in data.entries) {
        await HomeWidget.saveWidgetData<String>(e.key, e.value);
      }
      await HomeWidget.updateWidget(qualifiedAndroidName: _qualifiedName);
    } catch (e) {
      debugPrint('HomeWidgetService.refresh: $e');
    }
  }

  static Future<Uri?> launchedFrom() async {
    try {
      return await HomeWidget.initiallyLaunchedFromHomeWidget();
    } catch (_) {
      return null;
    }
  }

  static Stream<Uri?> get clicks => HomeWidget.widgetClicked;
}
