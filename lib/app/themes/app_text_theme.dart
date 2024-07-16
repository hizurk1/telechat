import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/themes.dart';

extension TextStyleExt on TextStyle {
  TextStyle get sub => copyWith(color: Colors.grey);

  TextStyle get dark => copyWith(color: Colors.grey.shade700);

  TextStyle get white => copyWith(color: Colors.white);

  TextStyle get bg => copyWith(color: AppColors.background);

}

class AppTextStyle {
  AppTextStyle._();

  //! Header
  /// fontSize: 36 [bold]
  static final TextStyle headingXL = TextStyle(
    fontSize: 36.sp,
    fontWeight: FontWeight.bold,
  );

  /// fontSize: 34 [bold]
  static final TextStyle headingL = TextStyle(
    fontSize: 34.sp,
    fontWeight: FontWeight.bold,
  );

  /// fontSize: 32 [w500]
  static final TextStyle headingM = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w500,
  );

  /// fontSize: 30 [normal]
  static final TextStyle headingS = TextStyle(
    fontSize: 30.sp,
    fontWeight: FontWeight.normal,
  );

  //! Title
  /// fontSize: 28 [bold]
  static final TextStyle titleL = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
  );

  /// fontSize: 24 [w500]
  static final TextStyle titleM = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w500,
  );

  /// fontSize: 20 [normal]
  static final TextStyle titleS = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.normal,
  );

  //! Body
  /// fontSize: 18 [normal]
  static final TextStyle bodyL = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.normal,
  );

  /// fontSize: 16 [normal]
  static final TextStyle bodyM = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
  );

  /// fontSize: 14 [normal]
  static final TextStyle bodyS = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
  );

  //! Caption
  /// fontSize: 13 [w300]
  static final TextStyle caption = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.normal,
  );

  //! Label
  /// fontSize: 12 [bold]
  static final TextStyle labelL = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
  );

  /// fontSize: 11 [w500]
  static final TextStyle labelM = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
  );

  /// fontSize: 10 [normal]
  static final TextStyle labelS = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.normal,
  );
}
