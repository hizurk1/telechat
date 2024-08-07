import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/themes.dart';

extension TextStyleExt on TextStyle {
  TextStyle get sub => copyWith(color: AppColors.textGrey);

  TextStyle get dark => copyWith(color: Colors.grey.shade700);

  TextStyle get white => copyWith(color: Colors.white);

  TextStyle get bg => copyWith(color: AppColors.background);

  TextStyle get primary => copyWith(color: AppColors.primary);

  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);

  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  TextStyle get normal => copyWith(fontWeight: FontWeight.w400);
}

class AppTextStyle {
  AppTextStyle._();

  static const TextStyle defaultText = TextStyle(
    color: AppColors.white,
    fontFamily: "Poppin",
    fontWeight: FontWeight.normal,
  );

  //! Header
  /// fontSize: 36 [bold]
  static final TextStyle headingXL = defaultText.copyWith(fontSize: 36.sp).bold;

  /// fontSize: 34 [bold]
  static final TextStyle headingL = defaultText.copyWith(fontSize: 34.sp).bold;

  /// fontSize: 32 [w500]
  static final TextStyle headingM = defaultText.copyWith(fontSize: 32.sp).medium;

  /// fontSize: 30 [normal]
  static final TextStyle headingS = defaultText.copyWith(fontSize: 30.sp);

  //! Title
  /// fontSize: 28 [bold]
  static final TextStyle titleL = defaultText.copyWith(fontSize: 28.sp).bold;

  /// fontSize: 24 [w500]
  static final TextStyle titleM = defaultText.copyWith(fontSize: 24.sp).medium;

  /// fontSize: 20 [normal]
  static final TextStyle titleS = defaultText.copyWith(fontSize: 20.sp);

  //! Body
  /// fontSize: 18 [normal]
  static final TextStyle bodyL = defaultText.copyWith(fontSize: 18.sp);

  /// fontSize: 16 [normal]
  static final TextStyle bodyM = defaultText.copyWith(fontSize: 16.sp);

  /// fontSize: 14 [normal]
  static final TextStyle bodyS = defaultText.copyWith(fontSize: 14.sp);

  //! Caption
  /// fontSize: 13 [w300]
  static final TextStyle caption = defaultText.copyWith(fontSize: 13.sp);

  //! Label
  /// fontSize: 12 [bold]
  static final TextStyle labelL = defaultText.copyWith(fontSize: 12.sp);

  /// fontSize: 11 [w500]
  static final TextStyle labelM = defaultText.copyWith(fontSize: 11.sp).medium;

  /// fontSize: 10 [normal]
  static final TextStyle labelS = defaultText.copyWith(fontSize: 10.sp);

  /// fontSize: 10 [normal]
  static final TextStyle labelXS = defaultText.copyWith(fontSize: 9.sp);
}
