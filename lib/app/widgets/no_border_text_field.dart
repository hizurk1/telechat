import 'package:flutter/material.dart';
import 'package:telechat/app/themes/app_text_theme.dart';

class NoBorderTextField extends StatelessWidget {
  const NoBorderTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hintText;
  final void Function(String text)? onChanged;
  final void Function(String text)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: AppTextStyle.bodyM.white,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: AppTextStyle.bodyM.sub,
      ),
    );
  }
}
