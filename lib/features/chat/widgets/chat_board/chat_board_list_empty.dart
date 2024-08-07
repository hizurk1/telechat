import 'package:flutter/material.dart';
import 'package:telechat/app/constants/gen/assets.gen.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/core/extensions/build_context.dart';

class ChatBoardListEmptyWidget extends StatelessWidget {
  const ChatBoardListEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.svgs.meetingFriends.svg(
            width: context.screenWidth * 0.6,
            fit: BoxFit.fitWidth,
          ),
          Text(
            "Say Hi to your friend.",
            style: AppTextStyle.bodyM.sub,
            textAlign: TextAlign.center,
          ),
          const Gap(30),
        ],
      ),
    );
  }
}
