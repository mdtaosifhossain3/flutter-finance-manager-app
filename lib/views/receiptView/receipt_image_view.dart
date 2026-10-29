import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Full-screen, zoomable receipt photo.
class ReceiptImageView extends StatelessWidget {
  final String path;

  const ReceiptImageView({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    final file = File(path);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('receipt_view'.tr),
      ),
      body: Center(
        child: file.existsSync()
            ? InteractiveViewer(maxScale: 5, child: Image.file(file))
            : Text(
                'receipt_image_missing'.tr,
                style: const TextStyle(color: Colors.white70),
              ),
      ),
    );
  }
}
