import 'dart:io';

import 'package:finance_manager_app/config/db/local/category_db/add_transaction_db_helper.dart';
import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

enum ReportKind { weekly, monthly }

/// A finished week (Monday to Sunday) or calendar month.
/// [start] is inclusive, [end] is exclusive.
class ReportPeriod {
  final ReportKind kind;
  final DateTime start;
  final DateTime end;

  const ReportPeriod._(this.kind, this.start, this.end);

  /// The Monday-to-Sunday week before the one containing [ref].
  factory ReportPeriod.lastWeek(DateTime ref) {
    final thisMonday = DateTime(
      ref.year,
      ref.month,
      ref.day - (ref.weekday - 1),
    );
    return ReportPeriod._(
      ReportKind.weekly,
      DateTime(thisMonday.year, thisMonday.month, thisMonday.day - 7),
      thisMonday,
    );
  }

  /// The calendar month before the one containing [ref].
  factory ReportPeriod.lastMonth(DateTime ref) => ReportPeriod._(
    ReportKind.monthly,
    DateTime(ref.year, ref.month - 1, 1),
    DateTime(ref.year, ref.month, 1),
  );

  factory ReportPeriod.previous(ReportKind kind, DateTime ref) =>
      kind == ReportKind.weekly
      ? ReportPeriod.lastWeek(ref)
      : ReportPeriod.lastMonth(ref);

  /// Last moment inside the period, for the inclusive database query.
  DateTime get lastMoment => end.subtract(const Duration(microseconds: 1));

  String get title => kind == ReportKind.weekly
      ? 'Weekly Financial Report'
      : 'Monthly Financial Report';

  String get label => kind == ReportKind.weekly
      ? '${DateFormat('dd MMM').format(start)} - '
            '${DateFormat('dd MMM yyyy').format(lastMoment)}'
      : DateFormat('MMMM yyyy').format(start);

  String get fileName =>
      '${kind.name}_report_${DateFormat('yyyy-MM-dd').format(start)}.pdf';

  Future<List<TransactionModel>> loadTransactions(
    AddTransactionDbHelper db,
  ) async {
    final rows = await db.getTransactionsByDateRange(
      start.toIso8601String(),
      lastMoment.toIso8601String(),
    );
    return rows.map(TransactionModel.fromMap).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }
}

/// Builds the weekly / monthly PDF, saves it on the device and opens it.
class ReportPdfService {
  static bool _busy = false;

  /// Creates the report for [period] and opens it. If no PDF app is
  /// installed, the share sheet opens instead so the file can still be saved
  /// (Files, Drive, Downloads ...).
  static Future<void> open(BuildContext context, ReportPeriod period) async {
    if (_busy) return; // a second tap while the first report is being built
    _busy = true;

    final db = context.read<AddExpenseProvider>().addTransactionDbHelper;
    final navigator = Navigator.of(context, rootNavigator: true);
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    String? message;
    File? file;
    try {
      final transactions = await period.loadTransactions(db);
      if (transactions.isEmpty) {
        message = 'report_no_transactions';
      } else {
        final bytes = await _buildPdf(transactions, period).save();
        final dir = Directory(
          '${(await getApplicationDocumentsDirectory()).path}/reports',
        );
        await dir.create(recursive: true);
        file = File('${dir.path}/${period.fileName}');
        await file.writeAsBytes(bytes, flush: true);
      }
    } catch (e) {
      debugPrint('ReportPdfService: $e');
      message = 'report_failed';
    } finally {
      navigator.pop(); // loading indicator
      _busy = false;
    }

    if (message != null) {
      _showMessage(message.tr);
      return;
    }

    final opened = await OpenFilex.open(file!.path, type: 'application/pdf');
    if (opened.type != ResultType.done) {
      _showMessage('report_no_viewer'.tr);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/pdf')],
          subject: '${period.title} - ${period.label}',
        ),
      );
    }
  }

  static void _showMessage(String text) {
    Get.snackbar(
      '',
      text,
      titleText: const SizedBox.shrink(),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  // ---------------------------------------------------------------------------
  // PDF

  static final _money = NumberFormat.decimalPattern('en_IN');

  static pw.Document _buildPdf(
    List<TransactionModel> transactions,
    ReportPeriod period,
  ) {
    var income = 0, expense = 0;
    for (final t in transactions) {
      if (t.type == TransactionType.income) {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }
    final balance = income - expense;

    return pw.Document()..addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          _header(period),
          pw.SizedBox(height: 30),
          _summary(income, expense, balance),
          pw.SizedBox(height: 30),
          _table(transactions),
        ],
      ),
    );
  }

  static pw.Widget _header(ReportPeriod period) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        period.title,
        style: pw.TextStyle(
          fontSize: 24,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.grey800,
        ),
      ),
      pw.SizedBox(height: 8),
      pw.Text(
        period.label,
        style: const pw.TextStyle(fontSize: 16, color: PdfColors.grey600),
      ),
      pw.Divider(thickness: 2, color: PdfColors.grey800),
    ],
  );

  static pw.Widget _summary(int income, int expense, int balance) =>
      pw.Container(
        padding: const pw.EdgeInsets.all(20),
        decoration: pw.BoxDecoration(
          color: PdfColors.grey100,
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
            _summaryItem('Total Income', income, PdfColors.green700),
            _summaryItem('Total Expense', expense, PdfColors.red700),
            _summaryItem(
              'Net Balance',
              balance,
              balance >= 0 ? PdfColors.blue700 : PdfColors.orange700,
            ),
          ],
        ),
      );

  static pw.Widget _summaryItem(String label, int value, PdfColor color) =>
      pw.Column(
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Tk ${_money.format(value)}',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
          ),
        ],
      );

  static pw.Widget _table(List<TransactionModel> transactions) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        'Transaction Details',
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.grey800,
        ),
      ),
      pw.SizedBox(height: 12),
      pw.TableHelper.fromTextArray(
        headers: ['Date', 'Category', 'Type', 'Amount (Tk)', 'Method'],
        data: [
          for (final t in transactions)
            [
              DateFormat('dd/MM').format(t.date),
              HelperFunctions.giveCategoryName(t.categoryKey),
              t.type == TransactionType.income ? 'Income' : 'Expense',
              _money.format(t.amount),
              t.paymentMethod,
            ],
        ],
        headerStyle: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 10,
          color: PdfColors.white,
        ),
        headerDecoration: const pw.BoxDecoration(color: PdfColors.grey800),
        cellStyle: const pw.TextStyle(fontSize: 9),
        cellAlignment: pw.Alignment.centerLeft,
        cellAlignments: {3: pw.Alignment.centerRight},
        cellHeight: 30,
        cellPadding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        columnWidths: {
          0: const pw.FixedColumnWidth(50),
          1: const pw.FlexColumnWidth(2.5),
          2: const pw.FlexColumnWidth(1.5),
          3: const pw.FixedColumnWidth(80),
          4: const pw.FlexColumnWidth(1.5),
        },
        oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey50),
      ),
    ],
  );
}
