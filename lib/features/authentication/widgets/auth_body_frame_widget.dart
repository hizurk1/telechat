import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/app/widgets/unfocus.dart';

class AuthBodyFrameWidget extends StatelessWidget {
  const AuthBodyFrameWidget({
    super.key,
    required this.title,
    required this.body,
    required this.bottom,
  });

  final String title;
  final Widget body;
  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: UnfocusArea(
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: AppTextStyle.headingL,
                        ),
                        const Gap.extra(),
                        body
                      ],
                    ),
                  ),
                ),
                bottom,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
