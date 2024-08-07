import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/constants/gen/assets.gen.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/app/widgets/primary_button.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    super.key,
    this.onRetry,
    this.message,
  });

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.jsons.catError.lottie(
                height: 200.r,
                width: 200.r,
              ),
              Text(
                message ?? "Something went wrong! \nPlease try again.",
                style: AppTextStyle.bodyL.sub,
                textAlign: TextAlign.center,
              ),
              const Gap.extra(),
              PrimaryButton(
                onPressed: () => onRetry?.call(),
                width: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.replay_rounded, color: AppColors.background, size: 20.r),
                    const Gap.xsmall(),
                    Text("Retry", style: AppTextStyle.bodyS.bg),
                  ],
                ),
              ),
              const Gap.extra(),
            ],
          ),
        ),
      ),
    );
  }
}
