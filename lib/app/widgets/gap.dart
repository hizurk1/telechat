import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap(this.size, {super.key});

  const Gap.small({super.key}) : size = 8;
  const Gap.medium({super.key}) : size = 12;
  const Gap.large({super.key}) : size = 16;
  const Gap.extra({super.key}) : size = 24;

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
    );
  }
}