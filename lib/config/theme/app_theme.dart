import 'package:flutter/material.dart';

import '../myColors/app_colors.dart';

class AppThemes {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.darkMainBackground,
    cardColor: AppColors.darkCardBackground,
    dividerColor: AppColors.border,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkMainBackground,
      surfaceTintColor: AppColors.darkMainBackground,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
      ),
    ),

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryBlue,
      secondary: AppColors.secondaryBlue,
      surface: AppColors.darkSecondaryBackground,
      onPrimary: AppColors.textPrimary,
      onSecondary: AppColors.textSecondary,
      onSurface: AppColors.textSecondary,
      error: AppColors.error,
      outline: AppColors.border,
    ),


    textTheme: const TextTheme(
      // ---------------- HEADLINES ----------------
      headlineLarge: TextStyle( // Main page titles
        fontSize: 30,
        fontWeight: FontWeight.w700,
        fontFamily: 'Poppins',
        color: AppColors.textPrimary,
      ),
      headlineMedium: TextStyle( // Section titles
        fontSize: 24,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: AppColors.textPrimary,
      ),
      headlineSmall: TextStyle( // Card / widget titles
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: AppColors.textPrimary,
      ),

      // ---------------- TITLES ----------------
      titleLarge: TextStyle( // AppBar / Dialog titles
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: AppColors.textPrimary,
      ),
      titleMedium: TextStyle( // Emphasis body titles
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: AppColors.textPrimary,
      ),
      titleSmall: TextStyle( // Small titles in lists
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: AppColors.textSecondary,
      ),

      // ---------------- BODY ----------------
      bodyLarge: TextStyle( // Main paragraphs / balances
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle( // Secondary body
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
        color: AppColors.textSecondary,
      ),
      bodySmall: TextStyle( // Muted info / captions
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
        color: AppColors.textMuted,
      ),

      // ---------------- LABELS ----------------
      labelLarge: TextStyle( // Buttons
        fontSize: 15,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: AppColors.textPrimary,
      ),
      labelMedium: TextStyle( // Chips, input labels
        fontSize: 13,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: AppColors.textSecondary,
      ),
      labelSmall: TextStyle( // Very small tags
        fontSize: 11,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
        color: AppColors.textMuted,
      ),
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.lightMainBackground,
    cardColor: AppColors.lightCardBackground,
    dividerColor: AppColors.lightBorder,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightMainBackground,
      surfaceTintColor: AppColors.lightMainBackground,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
      titleTextStyle: const TextStyle(
        color: AppColors.lightTextPrimary,
        fontSize: 20,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
      ),
    ),

    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryBlue,
      secondary: AppColors.secondaryBlue,
      surface: AppColors.lightSecondaryBackground,
      onPrimary: AppColors.lightTextPrimary,
      onSecondary: AppColors.lightTextSecondary,
      onSurface: AppColors.lightTextSecondary,
      error: AppColors.error,
      outline: AppColors.lightBorder,
    ),

    // textTheme: const TextTheme(
    //   bodyLarge: TextStyle(color: AppColors.lightTextPrimary),
    //   bodyMedium: TextStyle(color: AppColors.lightTextSecondary),
    //   bodySmall: TextStyle(color: AppColors.lightTextMuted),
    // ),
    textTheme: const TextTheme(
      // ---------------- HEADLINES ----------------
      headlineLarge: TextStyle( // Main page titles
        fontSize: 30,
        fontWeight: FontWeight.w700,
        fontFamily: 'Poppins',
        color: AppColors.lightTextPrimary,
      ),
      headlineMedium: TextStyle( // Section titles
        fontSize: 24,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: AppColors.lightTextPrimary,
      ),
      headlineSmall: TextStyle( // Card / widget titles
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: AppColors.lightTextPrimary,
      ),

      // ---------------- TITLES ----------------
      titleLarge: TextStyle( // AppBar / Dialog titles
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: AppColors.lightTextPrimary,
      ),
      titleMedium: TextStyle( // Emphasis body titles
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: AppColors.lightTextPrimary,
      ),
      titleSmall: TextStyle( // Small titles in lists
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: AppColors.lightTextSecondary,
      ),

      // ---------------- BODY ----------------
      bodyLarge: TextStyle( // Main paragraphs / balances
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
        color: AppColors.lightTextPrimary,
      ),
      bodyMedium: TextStyle( // Secondary body
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
        color: AppColors.lightTextSecondary,
      ),
      bodySmall: TextStyle( // Muted info / captions
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
        color: AppColors.lightTextMuted,
      ),

      // ---------------- LABELS ----------------
      labelLarge: TextStyle( // Buttons
        fontSize: 15,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: AppColors.lightTextPrimary,
      ),
      labelMedium: TextStyle( // Chips, input labels
        fontSize: 13,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: AppColors.lightTextSecondary,
      ),
      labelSmall: TextStyle( // Very small tags
        fontSize: 11,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
        color: AppColors.lightTextMuted,
      ),
    )
  );
}
