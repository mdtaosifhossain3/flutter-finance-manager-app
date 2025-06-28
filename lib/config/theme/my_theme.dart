import 'package:finance_manager_app/config/myColors/my_colors.dart';
import 'package:flutter/material.dart';

/// This file contains the theme data for the Finance Manager app.
var lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  appBarTheme: AppBarTheme(
    backgroundColor: MyColors.carbbeanGreen,
    surfaceTintColor: MyColors.carbbeanGreen,
  ),
  colorScheme: const ColorScheme.light(
    primary: MyColors.carbbeanGreen,
    surface: MyColors.honeyDew,
    onSurface: MyColors.cyprus,
    onPrimary: MyColors.voidB,
    primaryContainer: MyColors.cyprus,
    onPrimaryContainer: MyColors.voidB,
  ),

  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 30,
      color: MyColors.fencGreen,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      color: MyColors.fencGreen,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      color: MyColors.fencGreen,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
    ),
    labelLarge: TextStyle(
      fontSize: 15,
      color: MyColors.fencGreen,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      color: MyColors.fencGreen,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      color: MyColors.fencGreen,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: MyColors.fencGreen,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w700,
    ),
  ),
);
// This file contains the dark theme data for the Finance Manager app.
// It is used to provide a consistent dark mode experience across the app.
// The dark theme is designed to be visually appealing and easy on the eyes in low-light conditions
// while maintaining the same color scheme as the light theme.
// The dark theme uses the same colors as the light theme, but with a darker background and
// adjusted text colors to ensure readability and accessibility.
// The text styles are also consistent with the light theme, ensuring a cohesive design language.

var darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  appBarTheme: AppBarTheme(
    backgroundColor: MyColors.fencGreen,
    surfaceTintColor: MyColors.fencGreen,
  ),
  colorScheme: const ColorScheme.dark(
    primary: MyColors.carbbeanGreen,
    surface: MyColors.fencGreen,
    onSurface: MyColors.honeyDew,
    onPrimary: MyColors.honeyDew,
    primaryContainer: MyColors.cyprus,
    onPrimaryContainer: MyColors.voidB,
  ),

  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 30,
      color: MyColors.lightGreen,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      color: MyColors.lightGreen,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      color: MyColors.lightGreen,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
    ),
    labelLarge: TextStyle(
      fontSize: 15,
      color: MyColors.lightGreen,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      color: MyColors.lightGreen,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      color: MyColors.lightGreen,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: MyColors.lightGreen,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
    ),
  ),
);
