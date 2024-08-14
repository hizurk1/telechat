import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/constants/gen/assets.gen.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/core/extensions/build_context.dart';

class ChatListNoContactWidget extends StatelessWidget {
  const ChatListNoContactWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.jsons.empty.lottie(
                height: 200.r,
                width: 200.r,
              ),
              Text(
                "No chats\nClick on add button to start.",
                style: AppTextStyle.bodyM.sub,
                textAlign: TextAlign.center,
              ),
              const Gap(40),
            ],
          ),
        ),
        Positioned(
          bottom: 45.h,
          right: 90.w,
          child: Transform.rotate(
            angle: pi * 0.15,
            child: Transform.flip(
              flipY: true,
              child: Assets.svgs.arrowDashLine.svg(
                width: context.screenWidth / 4,
                fit: BoxFit.fitWidth,
                colorFilter: context.colorFilter(AppColors.iconGrey),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
