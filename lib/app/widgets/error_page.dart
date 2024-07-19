import 'package:flutter/material.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/app/widgets/primary_button.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    super.key,
    required this.onRetry,
    this.message,
  });

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              message ?? "Something went wrong! Please try again.",
              style: AppTextStyle.bodyL.white,
            ),
            const Gap.medium(),
            PrimaryButton.text(
              onPressed: () {},
              text: "Try again",
            ),
          ],
        ),
      ),
    );
  }
}
