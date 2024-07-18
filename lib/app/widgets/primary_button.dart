import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/themes.dart';
import 'package:telechat/core/extensions/build_context.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.width,
  });

  PrimaryButton.text({
    super.key,
    required this.onPressed,
    required String text,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.width,
  }) : child = Text(
          text,
          style: AppTextStyle.bodyS.copyWith(
            color: textColor ?? AppColors.background,
          ),
          textAlign: TextAlign.center,
        );

  final VoidCallback onPressed;
  final Widget child;

  /// Default set to [primary]
  final Color? backgroundColor;

  /// Default set to [background]
  final Color? textColor;

  /// Default set to 52
  final double? height;

  /// Set to `0` to make it fit the child.
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 52.h,
      width: width == null ? context.screenWidth : (width! > 0 ? width : null),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
        child: child,
      ),
    );
  }
}
