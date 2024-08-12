import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/constants/gen/assets.gen.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/core/extensions/build_context.dart';

class ChatListNoContactWidget extends StatelessWidget {
  const ChatListNoContactWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(context.screenHeight / 6),
          Assets.jsons.empty.lottie(
            height: 200.r,
            width: 200.r,
          ),
          Text(
            "No chats\nClick on add button to start.",
            style: AppTextStyle.bodyM.sub,
            textAlign: TextAlign.center,
          ),
          const Gap(30),
        ],
      ),
    );
  }
}
