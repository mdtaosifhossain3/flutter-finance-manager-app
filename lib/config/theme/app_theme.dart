import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../myColors/app_colors.dart';

class AppThemes {
  static ThemeData getTheme(Brightness brightness, String langCode) {
    final bool isDark = brightness == Brightness.dark;
    final String? fontFamily = langCode == 'bn'
        ? GoogleFonts.notoSansBengali().fontFamily
        : GoogleFonts.poppins().fontFamily;

    final Color primaryColor = AppColors.primaryBlue;
    final Color scaffoldBackgroundColor = isDark
        ? AppColors.darkMainBackground
        : AppColors.lightMainBackground;
    final Color cardColor = isDark
        ? AppColors.darkCardBackground
        : AppColors.lightCardBackground;
    final Color dividerColor = isDark
        ? AppColors.border
        : AppColors.lightBorder;

    final Color textPrimary = isDark
        ? AppColors.textPrimary
        : AppColors.lightTextPrimary;
    final Color textSecondary = isDark
        ? AppColors.textSecondary
        : AppColors.lightTextSecondary;
    final Color textMuted = isDark
        ? AppColors.textMuted
        : AppColors.lightTextMuted;

    return ThemeData(
      brightness: brightness,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      cardColor: cardColor,
      dividerColor: dividerColor,
      fontFamily: fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackgroundColor,
        surfaceTintColor: scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
      ),
      colorScheme: isDark
          ? const ColorScheme.dark(
              primary: AppColors.primaryBlue,
              secondary: AppColors.secondaryBlue,
              surface: AppColors.darkSecondaryBackground,
              onPrimary: AppColors.textPrimary,
              onSecondary: AppColors.textSecondary,
              onTertiary: AppColors.textMuted,
              onSurface: AppColors.textSecondary,
              error: AppColors.error,
              outline: AppColors.border,
            )
          : const ColorScheme.light(
              primary: AppColors.primaryBlue,
              secondary: AppColors.secondaryBlue,
              surface: AppColors.lightSecondaryBackground,
              onPrimary: AppColors.lightTextPrimary,
              onSecondary: AppColors.lightTextSecondary,
              onSurface: AppColors.lightTextSecondary,
              error: AppColors.error,
              outline: AppColors.lightBorder,
            ),
      textTheme: TextTheme(
        // ---------------- HEADLINES ----------------
        headlineLarge: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          fontFamily: fontFamily,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          fontFamily: fontFamily,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          fontFamily: fontFamily,
        ),

        // ---------------- TITLES ----------------
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          fontFamily: fontFamily,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
          fontFamily: fontFamily,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textSecondary,
          fontFamily: fontFamily,
        ),

        // ---------------- BODY ----------------
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          fontFamily: fontFamily,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          fontFamily: fontFamily,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textMuted,
          fontFamily: fontFamily,
        ),

        // ---------------- LABELS ----------------
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          fontFamily: fontFamily,
        ),
        labelMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: textSecondary,
          fontFamily: fontFamily,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: textMuted,
          fontFamily: fontFamily,
        ),
      ),
    );
  }
}
