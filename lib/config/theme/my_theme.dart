import 'package:finance_manager_app/config/myColors/my_colors.dart';
import 'package:flutter/material.dart';

var darkTheme = ThemeData();
var lightTheme = ThemeData(
  brightness: Brightness.dark,
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

  // textTheme: const TextTheme(
  //   headlineLarge: TextStyle(
  //       fontSize: 32,
  //       color: MyColors.dPrimaryColor,
  //       fontFamily: 'Poppins',
  //       fontWeight: FontWeight.w800),
  //   headlineMedium: TextStyle(
  //       fontSize: 30,
  //       color: MyColors.dOnTextColor,
  //       fontFamily: 'Poppins',
  //       fontWeight: FontWeight.w700),
  //   headlineSmall: TextStyle(
  //       fontSize: 20,
  //       color: MyColors.dOnTextColor,
  //       fontFamily: 'Poppins',
  //       fontWeight: FontWeight.w600),
  //   labelLarge: TextStyle(
  //       fontSize: 16,
  //       color: MyColors.dOnTextColor,
  //       fontFamily: 'Poppins',
  //       fontWeight: FontWeight.w500),
  //   labelMedium: TextStyle(
  //       fontSize: 12,
  //       color: MyColors.dGreyColor,
  //       fontFamily: 'Poppins',
  //       fontWeight: FontWeight.w400),
  //   labelSmall: TextStyle(
  //       fontSize: 10,
  //       color: MyColors.dGreyColor,
  //       fontFamily: 'Poppins',
  //       fontWeight: FontWeight.w300),
  // )
);
