import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/app_color.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({
    super.key,
    this.height,
    this.width,
    this.size,
    this.borderRadius,
    this.opacity,
  });

  final double? height, width, size, borderRadius, opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size?.r ?? height?.h,
      width: size?.r ?? width?.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((borderRadius ?? 8).r),
        color: AppColors.card,
      ),
    );
  }
}