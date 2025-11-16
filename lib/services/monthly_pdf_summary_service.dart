import 'dart:async';
import 'dart:io';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import '../../config/enums/enums.dart';

class MonthlyPdfGenerator {
  static Future<void> generateMonthlyReportPdf(DateTime month, context) async {
    final addExpenseProvider = Provider.of<AddExpenseProvider>(
      context,
      listen: false,
    );
    final transactions = addExpenseProvider.transactionData;
    // ✅ Filter only transactions for the selected month
    final monthlyTransactions = transactions
        .where((t) => t.date.year == month.year && t.date.month == month.month)
        .toList();

    if (monthlyTransactions.isEmpty) {
      _showMessage('No transactions found for this month');
      return;
    }

    try {
      final pdf = _createPdf(monthlyTransactions, month);
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/monthly_summary.pdf");
      await file.writeAsBytes(await pdf.save());
      await OpenFilex.open(file.path); // 🔥 Opens with Drive/PDF Viewer/etc.
    } on SocketException {
      _showMessage("No Internet");
    } on TimeoutException {
      _showMessage("Time Out");
    } catch (e) {
      _showMessage('Failed to generate report: $e');
    }
  }

  static pw.Document _createPdf(
    List<TransactionModel> transactions,
    DateTime month,
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
          _buildHeader(month),
          pw.SizedBox(height: 30),
          _buildSummary(totalIncome, totalExpense, balance),
          pw.SizedBox(height: 30),
          _buildTransactionTable(transactions),
        ],
      ),
    );

    return pdf;
  }

  static pw.Widget _buildHeader(DateTime month) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Monthly Financial Report',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey800,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          '${_monthName(month.month)} ${month.year}',
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
                  HelperFunctions.giveCategoryName(t.categoryKey),
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

  static String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }
}
