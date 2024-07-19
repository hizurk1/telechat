import 'package:flutter/material.dart';

import 'app_color.dart';

class AppTheme {
  AppTheme._();

  static final appTheme = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      elevation: 2,
      backgroundColor: AppColors.appBarBg,
      surfaceTintColor: AppColors.appBarBg,
    ),
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
    ),
  );
}
