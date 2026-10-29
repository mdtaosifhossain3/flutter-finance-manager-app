import 'dart:io';

import 'package:finance_manager_app/services/receipt/receipt_parser.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Reads receipt photos on the phone with ML Kit (offline, Latin script
/// only). Bangla and hand-written receipts come back weak and the user fills
/// in the values.
class ReceiptOcrService {
  /// On-device read. Never throws: a failed read is just an empty, weak result.
  static Future<ParsedReceipt> readOnDevice(File image) async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final result = await recognizer.processImage(
        InputImage.fromFilePath(image.path),
      );
      return ReceiptParser.parse(_linesInReadingOrder(result));
    } catch (_) {
      return ReceiptParser.parse('');
    } finally {
      await recognizer.close();
    }
  }

  /// ML Kit returns blocks column by column, which splits "Total" from its
  /// amount on two-column receipts. Rebuild rows by vertical position.
  static String _linesInReadingOrder(RecognizedText result) {
    final lines = [for (final b in result.blocks) ...b.lines]
      ..sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));
    final rows = <List<TextLine>>[];
    for (final line in lines) {
      final box = line.boundingBox;
      final row = rows.where((r) {
        final first = r.first.boundingBox;
        final overlap =
            (box.bottom < first.bottom ? box.bottom : first.bottom) -
            (box.top > first.top ? box.top : first.top);
        return overlap > box.height * 0.5;
      });
      if (row.isEmpty) {
        rows.add([line]);
      } else {
        row.first.add(line);
      }
    }
    return rows
        .map(
          (r) =>
              (r..sort(
                    (a, b) => a.boundingBox.left.compareTo(b.boundingBox.left),
                  ))
                  .map((l) => l.text)
                  .join(' '),
        )
        .join('\n');
  }
}
