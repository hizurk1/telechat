import 'package:flutter/material.dart';
import 'package:telechat/app/themes/app_color.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({
    super.key,
    this.color = AppColors.primary,
    this.size = 20,
    this.lineWidth = 2.5,
  });

  final Color color;
  final double size;
  final double lineWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        strokeWidth: lineWidth,
        color: color,
      ),
    );
  }
}

class LoadingIndicatorPage extends StatelessWidget {
  const LoadingIndicatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: LoadingIndicatorWidget(
          size: 30,
          lineWidth: 3,
        ),
      ),
    );
  }
}
