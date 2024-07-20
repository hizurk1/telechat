import 'package:flutter/material.dart';

import 'app_color.dart';

class AppTheme {
  AppTheme._();

  static final appTheme = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      elevation: 2,
      backgroundColor: AppColors.card,
      surfaceTintColor: AppColors.card,
    ),
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
    ),
  );
}
