import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Gap extends StatelessWidget {
  const Gap(this.size, {super.key});

  /// Size = 4
  const Gap.xsmall({super.key}) : size = 4;

  /// Size = 8
  const Gap.small({super.key}) : size = 8;

  /// Size = 12
  const Gap.medium({super.key}) : size = 12;

  /// Size = 16
  const Gap.large({super.key}) : size = 16;

  /// Size = 24
  const Gap.extra({super.key}) : size = 24;

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.r,
      width: size.r,
    );
  }
}
