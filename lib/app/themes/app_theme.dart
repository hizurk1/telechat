import 'package:flutter/material.dart';

import 'app_color.dart';

class AppTheme {
  AppTheme._();

  static final appTheme = ThemeData(
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
    ),
  );
}
