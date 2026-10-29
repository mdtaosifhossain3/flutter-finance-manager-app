import 'dart:convert';
import 'dart:io';

import 'package:finance_manager_app/config/db/local/category_db/add_transaction_db_helper.dart';
import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Exports every transaction as a CSV file that opens in Excel or Google
/// Sheets, then opens the share sheet.
class CsvExportService {
  static Future<void> exportAllTransactions() async {
    try {
      final rows = await AddTransactionDbHelper.getInstance.getAllNotes();
      final txs = rows.map(TransactionModel.fromMap).toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      if (txs.isEmpty) {
        Get.snackbar('export_csv'.tr, 'export_csv_empty'.tr);
        return;
      }

      final file = await writeCsv(txs);
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: 'export_csv'.tr),
      );
    } catch (e) {
      Get.snackbar('error'.tr, '${'export_csv_failed'.tr}: $e');
    }
  }

  static Future<File> writeCsv(List<TransactionModel> txs) async {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final buffer = StringBuffer()
      ..writeln(
        const [
          'Date',
          'Type',
          'Category',
          'Title',
          'Amount (BDT)',
          'Payment method',
          'Notes',
        ].join(','),
      );
    for (final t in txs) {
      buffer.writeln(
        [
          dateFormat.format(t.date),
          t.type == TransactionType.expense ? 'Expense' : 'Income',
          t.categoryKey.tr,
          t.title,
          '${t.type == TransactionType.expense ? -t.amount : t.amount}',
          t.paymentMethod.tr,
          t.notes ?? '',
        ].map(_escape).join(','),
      );
    }

    final dir = await getTemporaryDirectory();
    final stamp = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final file = File('${dir.path}/hishab_rakhi_transactions_$stamp.csv');
    // The BOM makes Excel read the file as UTF-8, so Bangla text shows up.
    await file.writeAsBytes([0xEF, 0xBB, 0xBF, ...utf8.encode('$buffer')]);
    return file;
  }

  static String _escape(String value) {
    if (value.contains(RegExp(r'[",\n\r]'))) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
