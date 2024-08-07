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
    this.color,
  });

  const Skeleton.circle({
    super.key,
    required this.size,
    this.height,
    this.width,
    this.color,
  }) : borderRadius = size;

  final double? height, width, size, borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size?.r ?? height?.h ?? 5.h,
      width: size?.r ?? width?.w ?? 20.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((borderRadius ?? 8).r),
        color: (color ?? AppColors.card),
      ),
    );
  }
}
