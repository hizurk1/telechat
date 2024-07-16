import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({
    super.key,
    this.color,
    this.size,
    this.lineWidth,
  });

  /// Default set to Colors.grey[600]
  final Color? color;

  /// Default set to 30
  final double? size;

  /// Default set to 3
  final double? lineWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size?.r ?? 30.r,
      width: size?.r ?? 30.r,
      child: CircularProgressIndicator(
        strokeWidth: lineWidth ?? 3,
        color: color ?? Colors.grey[600],
      ),
    );
  }
}
