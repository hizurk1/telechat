import 'package:flutter/material.dart';
import 'package:telechat/app/themes/themes.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  PrimaryButton.text({
    super.key,
    required this.onPressed,
    required String text,
  }) : child = Text(
          text,
          style: AppTextStyle.bodyS,
          textAlign: TextAlign.center,
        );

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
