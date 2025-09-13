import 'package:flutter/material.dart';

import '';
import '../myColors/app_colors.dart';

class AppThemes {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.darkMainBackground,
    cardColor: AppColors.darkCardBackground,
    dividerColor: AppColors.border,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryBlue,
      secondary: AppColors.secondaryBlue,
      surface: AppColors.darkCardBackground,
      onPrimary: AppColors.textPrimary,
      onSecondary: AppColors.textSecondary,
      onSurface: AppColors.textSecondary,
      error: AppColors.error,
    ),

    // textTheme: const TextTheme(
    //   bodyLarge: TextStyle(color: AppColors.textPrimary),
    //   bodyMedium: TextStyle(color: AppColors.textSecondary),
    //   bodySmall: TextStyle(color: AppColors.textMuted),
    // ),
      textTheme: const TextTheme(
        //------------------------ 20 24 30 ------------------------
        headlineSmall: TextStyle(
          fontSize: 20,
          color: AppColors.textMuted,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          color: AppColors.textSecondary,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          fontSize: 30,
          color:AppColors.textPrimary,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),

        //------------------------  12 14 15 ------------------------
        labelSmall: TextStyle(
          fontSize: 12,
          color: AppColors.textMuted,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        labelMedium: TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          fontSize: 15,
          color: AppColors.textPrimary,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),

        //------------------------ 16 ------------------------
        bodyMedium: TextStyle(
          fontSize: 16,
          color: AppColors.textSecondary,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
      )
  );


  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.lightMainBackground,
    cardColor: AppColors.lightCardBackground,
    dividerColor: AppColors.lightBorder,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryBlue,
      secondary: AppColors.secondaryBlue,
      surface: AppColors.lightCardBackground,
      onPrimary: AppColors.lightTextPrimary,
      onSecondary: AppColors.lightTextSecondary,
      onSurface: AppColors.lightTextSecondary,
      error: AppColors.error,
    ),

    // textTheme: const TextTheme(
    //   bodyLarge: TextStyle(color: AppColors.lightTextPrimary),
    //   bodyMedium: TextStyle(color: AppColors.lightTextSecondary),
    //   bodySmall: TextStyle(color: AppColors.lightTextMuted),
    // ),
    textTheme: const TextTheme(
      // -------------------------  20 24 30 -------------------------
      headlineSmall: TextStyle(
        fontSize: 20,
        color:  AppColors.lightTextMuted,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        color:  AppColors.lightTextSecondary,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: TextStyle(
        fontSize: 30,
        color: AppColors.lightTextPrimary,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
      ),

      //------------------------- 12 14 15 -------------------------
      labelSmall: TextStyle(
        fontSize: 12,
        color:  AppColors.lightTextMuted,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        color:  AppColors.lightTextSecondary,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        fontSize: 15,
        color:  AppColors.lightTextPrimary,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
      ),

      // -------------------------  16 -------------------------
      bodyMedium: TextStyle(
        fontSize: 16,
        color:  AppColors.lightTextSecondary,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}