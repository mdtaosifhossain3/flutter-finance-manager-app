import 'dart:async';
import 'dart:io';
import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/main.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../utils/helper_functions.dart'; // where generateEnglishCategory() lives

class WeeklyPdfGenerator {
  static Future<void> generateWeeklyReportPdf(DateTime selectedDate) async {
    final transactions = addExpenseProvider.transactionData;

    // ✅ Get start (Monday) and end (Sunday) of the week
    final startOfWeek = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    // ✅ Filter transactions for the selected week
    final weeklyTransactions = transactions
        .where(
          (t) =>
              t.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
              t.date.isBefore(endOfWeek.add(const Duration(days: 1))),
        )
        .toList();

    if (weeklyTransactions.isEmpty) {
      _showMessage('No transactions found for this week');
      return;
    }

    try {
      final pdf = _createPdf(weeklyTransactions, startOfWeek, endOfWeek);
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/weekly_summary.pdf");

      await file.writeAsBytes(await pdf.save());
      await OpenFilex.open(file.path); // 🔥 Opens with Drive/PDF Viewer/etc.
    } on SocketException {
      _showMessage('No Internet');
    } on TimeoutException {
      _showMessage('Time Out ');
    } catch (e) {
      print(e);
      _showMessage('Failed to generate weekly report: $e');
    }
  }

  static pw.Document _createPdf(
    List<TransactionModel> transactions,
    DateTime startOfWeek,
    DateTime endOfWeek,
  ) {
    final pdf = pw.Document();

    final totalIncome = _calculateTotal(transactions, TransactionType.income);
    final totalExpense = _calculateTotal(transactions, TransactionType.expense);
    final balance = totalIncome - totalExpense;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          _buildHeader(startOfWeek, endOfWeek),
          pw.SizedBox(height: 30),
          _buildSummary(totalIncome, totalExpense, balance),
          pw.SizedBox(height: 30),
          _buildTransactionTable(transactions),
        ],
      ),
    );

    return pdf;
  }

  static pw.Widget _buildHeader(DateTime start, DateTime end) {
    final dateRange =
        '${DateFormat('dd MMM').format(start)} - ${DateFormat('dd MMM yyyy').format(end)}';
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Weekly Financial Report',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey800,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          dateRange,
          style: pw.TextStyle(fontSize: 16, color: PdfColors.grey600),
        ),
        pw.Divider(thickness: 2, color: PdfColors.grey800),
      ],
    );
  }

  static pw.Widget _buildSummary(int income, int expense, int balance) {
    return pw.Container(
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
  }

  static pw.Widget _summaryItem(String label, int value, PdfColor color) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          '$value',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTransactionTable(List<TransactionModel> transactions) {
    return pw.Column(
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
          headers: ['Date', 'Category', 'Type', 'Amount', 'Method'],
          data: transactions
              .map(
                (t) => [
                  _formatDate(t.date),
                  HelperFunctions.generateEnglishCategory(t.categoryKey),
                  t.type == TransactionType.income ? 'Income' : 'Expense',
                  '${t.amount}',
                  t.paymentMethod,
                ],
              )
              .toList(),
          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 10,
            color: PdfColors.white,
          ),
          headerDecoration: pw.BoxDecoration(color: PdfColors.grey800),
          cellStyle: const pw.TextStyle(fontSize: 9),
          cellAlignment: pw.Alignment.centerLeft,
          cellHeight: 30,
          cellPadding: const pw.EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),
          columnWidths: {
            0: const pw.FixedColumnWidth(60),
            1: const pw.FlexColumnWidth(2.5),
            2: const pw.FlexColumnWidth(1.5),
            3: const pw.FixedColumnWidth(70),
            4: const pw.FlexColumnWidth(1.5),
          },
          oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey50),
        ),
      ],
    );
  }

  static Future<String> _savePdf(
    pw.Document pdf,
    DateTime start,
    DateTime end,
  ) async {
    final status = await Permission.storage.request();
    if (!status.isGranted) throw Exception('Storage permission denied');

    final downloadsDir = getExternalStorageDirectory();
    // if (!await downloadsDir.exists()) {
    //   await downloadsDir.create(recursive: true);
    // }

    final fileName =
        'Weekly_Report_${DateFormat('yyyy_MM_dd').format(start)}_${DateFormat('dd').format(end)}.pdf';
    final filePath = '$downloadsDir/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    return filePath;
  }

  static int _calculateTotal(
    List<TransactionModel> transactions,
    TransactionType type,
  ) {
    return transactions
        .where((t) => t.type == type)
        .fold<int>(0, (sum, t) => sum + t.amount);
  }

  static void _showMessage(String message, {bool isSuccess = false}) {
    Get.snackbar(
      backgroundColor: isSuccess ? Colors.green.shade700 : null,
      isSuccess ? "Success" : "Error",
      message,
    );
  }

  static String _formatDate(DateTime date) {
    return DateFormat('dd/MM').format(date);
  }

  Future<File> generateAndSavePdf() async {
    final pdf = pw.Document();

    // ✅ Save PDF to temporary directory
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/generated.pdf");

    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
