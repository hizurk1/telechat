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
  });

  PrimaryButton.text({
    super.key,
    required this.onPressed,
    required String text,
    this.backgroundColor,
  }) : child = Text(
          text,
          style: AppTextStyle.bodyS.bg,
          textAlign: TextAlign.center,
        );

  final VoidCallback onPressed;
  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52.h,
      width: context.screenWidth,
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
