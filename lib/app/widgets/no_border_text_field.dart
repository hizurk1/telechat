import 'package:flutter/material.dart';
import 'package:telechat/app/themes/app_text_theme.dart';

class NoBorderTextField extends StatelessWidget {
  const NoBorderTextField({
    super.key,
    this.controller,
    this.hintText,
    this.autofocus = false,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final String? hintText;
  final bool autofocus;
  final FocusNode? focusNode;
  final void Function(String text)? onChanged;
  final void Function(String text)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: AppTextStyle.bodyM.white,
      autofocus: autofocus,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: AppTextStyle.bodyM.sub,
      ),
    );
  }
}
