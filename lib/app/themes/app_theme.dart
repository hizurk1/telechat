import 'package:flutter/material.dart';

import 'app_color.dart';

class AppTheme {
  AppTheme._();

  static final appTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      elevation: 2,
      backgroundColor: AppColors.appBarBg,
      surfaceTintColor: AppColors.appBarBg,
    ),
    fontFamily: "Poppin",
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
    ),
  );
}
