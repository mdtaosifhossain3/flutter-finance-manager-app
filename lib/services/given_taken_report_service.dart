import 'dart:io';
import 'package:finance_manager_app/models/givenTakenModel/contact_lend_model.dart';
import 'package:finance_manager_app/models/givenTakenModel/lend_transaction_model.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:open_filex/open_filex.dart';
import 'package:bijoy_helper/bijoy_helper.dart' as BijoyHelper;

class GivenTakenReportService {
  static Future<void> generateAndHandleReport({
    required ContactLend contact,
    required List<LendTransaction> transactions,
    required bool isShare,
  }) async {
    final pdf = pw.Document();
    final langCode = Get.locale?.languageCode ?? 'en';

    // Load fonts
    final banglaFontData = await rootBundle.load(
      "assets/fonts/SutonnyMJ-Regular.ttf",
    );
    final englishFontData = await rootBundle.load(
      "assets/fonts/Poppins-Regular.ttf",
    );
    final banglaFont = pw.Font.ttf(banglaFontData);
    final englishFont = pw.Font.ttf(englishFontData);
    final theme = pw.ThemeData.withFont(
      base: langCode == "bn" ? banglaFont : englishFont,
      bold: langCode == "bn" ? banglaFont : englishFont,
      fontFallback: [englishFont],
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        build: (pw.Context context) {
          return [
            _buildHeader(contact, theme, langCode, banglaFont, englishFont),
            pw.SizedBox(height: 20),
            _buildSummary(contact, theme, langCode),
            pw.SizedBox(height: 20),
            _buildTransactionsTable(transactions, theme, langCode),
            pw.SizedBox(height: 20),
            _buildFooter(theme, langCode),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final fileName =
        "Given_Taken_Report_${contact.name}_${DateTime.now().millisecondsSinceEpoch}.pdf";
    final file = File("${output.path}/$fileName");
    await file.writeAsBytes(await pdf.save());

    if (isShare) {
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: 'given_taken_report'.tr),
      );
    } else {
      await OpenFilex.open(file.path);
    }
  }

  static uniCodetoBijoy(String text) {
    return BijoyHelper.unicodeToBijoy(text);
  }

  static pw.Widget _buildHeader(
    ContactLend contact,
    pw.ThemeData theme,
    String langCode,
    pw.Font banglaFont,
    pw.Font englishFont,
  ) {
    final hasBangla = RegExp(r'[\u0980-\u09FF]').hasMatch(contact.name);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          langCode == "bn" ? uniCodetoBijoy('হিসাব রাখি') : "Hishab Rakhi",
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          uniCodetoBijoy('given_taken_report'.tr),
          style: const pw.TextStyle(fontSize: 18),
        ),
        pw.Divider(),
        pw.SizedBox(height: 8),
        pw.RichText(
          text: pw.TextSpan(
            children: [
              pw.TextSpan(
                text: uniCodetoBijoy('${'person_name'.tr}: '),
                style: pw.TextStyle(font: banglaFont),
              ),
              pw.TextSpan(
                text: hasBangla ? uniCodetoBijoy(contact.name) : contact.name,
                style: pw.TextStyle(font: hasBangla ? banglaFont : englishFont),
              ),
            ],
          ),
        ),
        if (contact.phone != null && contact.phone!.isNotEmpty)
          pw.Text(
            uniCodetoBijoy(
              '${'phone_number'.tr}: ${HelperFunctions.convertToBanglaDigits(contact.phone!)}',
            ),
          ),
        pw.Text(
          uniCodetoBijoy(
            '${'date'.tr}: ${HelperFunctions.convertToBanglaDigits(DateFormat('dd/MM/yyyy').format(DateTime.now()))}',
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildSummary(
    ContactLend contact,
    pw.ThemeData theme,
    String langCode,
  ) {
    final isPositive = contact.balance >= 0;
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(uniCodetoBijoy('given'.tr)),
              pw.Text(
                uniCodetoBijoy(
                  HelperFunctions.convertToBanglaDigits(
                    contact.totalGiven.toString(),
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(uniCodetoBijoy('taken'.tr)),
              pw.Text(
                uniCodetoBijoy(
                  HelperFunctions.convertToBanglaDigits(
                    contact.totalTaken.toString(),
                  ),
                ),
              ),
            ],
          ),
          pw.Divider(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                uniCodetoBijoy('net_balance'.tr),
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                uniCodetoBijoy(
                  HelperFunctions.convertToBanglaDigits(
                    contact.balance.abs().toString(),
                  ),
                ),
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: isPositive ? PdfColors.green : PdfColors.red,
                ),
              ),
            ],
          ),
          pw.Text(
            uniCodetoBijoy(
              isPositive ? 'you_will_get'.tr : 'you_need_to_pay'.tr,
            ),
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTransactionsTable(
    List<LendTransaction> transactions,
    pw.ThemeData theme,
    String langCode,
  ) {
    final headers = [
      uniCodetoBijoy('date'.tr),
      uniCodetoBijoy('type'.tr),
      uniCodetoBijoy('amount'.tr),
    ];
    final data = transactions.map((tx) {
      return [
        uniCodetoBijoy(
          HelperFunctions.convertToBanglaDigits(
            DateFormat('dd/MM/yyyy').format(DateTime.parse(tx.date)),
          ),
        ),
        uniCodetoBijoy(tx.type == 'given' ? 'given'.tr : 'taken'.tr),
        uniCodetoBijoy(
          HelperFunctions.convertToBanglaDigits(tx.amount.toString()),
        ),
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
      },
    );
  }

  static pw.Widget _buildFooter(pw.ThemeData theme, String langCode) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Text(
        uniCodetoBijoy(
          langCode == 'bn'
              ? 'হিসাব রাখি অ্যাপ দ্বারা তৈরি'
              : 'Generated by Hishab Rakhi App',
        ),
        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
      ),
    );
  }
}
