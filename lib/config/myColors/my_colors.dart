import 'package:flutter/material.dart';

class MyColors {
  MyColors._();

  static const Color honeyDew = Color(0xffF1FFF3);
  static const Color lightGreen = Color(0xffDFF7E2);
  static const Color carbbeanGreen = Color(0xff00D09E);
  static const Color cyprus = Color(0xff0E3E3E);
  static const Color fencGreen = Color(0xff052224);
  static const Color voidB = Color(0xff031314);
  static const Color lightBlue = Color(0xff6DB6FE);
  static const Color vividBlue = Color(0xff3299FF);
  static const Color oceanBlue = Color(0xff0068FF);
  static const Color vividRed = Color(0xffFF3B3B);
  static const Color darkRed = Color(0xffE50000);
  static const Color greyColor = Colors.grey;
  static const Color whiteColor = Colors.white;

  //Progress Bar Colors
  static Color bgProgressBar = Colors.black.withValues(alpha: 0.2);
  static Color bgProgressBarIndicator = Colors.white.withValues(alpha: 0.3);

  //Popup Dialogue Colors
  static const Color popupBg = Colors.transparent;

  // White Colors with Alpha
  static final Color whiteWithAlpha15 = Colors.white.withValues(alpha: 0.15);
  static final Color whiteWithAlpha20 = Colors.white.withValues(alpha: 0.20);
  static final Color whiteWithAlpha30 = Colors.white.withValues(alpha: 0.30);

  //Analysis Page Colors
  static const Color analysisBackground = Color(0xFF00C896);
  static const Color analysisPeriodBg = Color(0xFFF0F9F7);
  static const Color analysisChartGreen = Color(0xFF00C896);
  static const Color analysisBorderColor = Color(0xFFF0F9F7);

  // Card Colors
  static const Color cardBackground = Colors.white;
  static const Color cardShadow = Color(0x1A000000); // black with 10% opacity

  // Text Colors
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;
  static final Color textHint = Colors.grey[600]!;

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color errorColor = Colors.red;
  static const Color warning = Color(0xFFFFA000);

  // Background Colors
  static const Color scaffoldBackground = Colors.white;
  static const Color surfaceBackground = Color(0xFFF5F5F5);

  // Button Colors
  static const Color buttonPrimary = carbbeanGreen;
  static const Color buttonSecondary = lightGreen;
  static final Color buttonDisabled = Colors.grey[300]!;
}
