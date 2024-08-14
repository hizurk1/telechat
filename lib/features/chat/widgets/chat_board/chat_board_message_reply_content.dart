import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/constants/app_const.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/cached_network_image.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/core/extensions/string.dart';
import 'package:telechat/shared/enums/message_enum.dart';

class ChatBoardMessageReplyContentWidget extends StatelessWidget {
  final String title;
  final MessageEnum messageType;
  final String message;
  final bool showIcon;
  const ChatBoardMessageReplyContentWidget({
    super.key,
    required this.title,
    required this.messageType,
    required this.message,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    String url;
    if (message.contains(AppConst.captionSpliter)) {
      url = message.split(AppConst.captionSpliter).first;
    } else {
      url = message;
    }
    Widget child = const SizedBox();
    switch (messageType) {
      case MessageEnum.text:
        break;
      case MessageEnum.image:
      case MessageEnum.gif:
        child = CachedNetworkImageCustom(
          imageUrl: url,
          height: 40.r,
          width: 40.r,
        );
      case MessageEnum.video:
        child = Container(
          height: 40.r,
          width: 40.r,
          decoration: BoxDecoration(
            color: AppColors.iconGrey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Center(
            child: Icon(
              Icons.play_circle_fill_rounded,
              color: AppColors.iconGrey,
              size: 20.r,
            ),
          ),
        );
      case MessageEnum.audio:
        child = Container(
          height: 40.r,
          width: 40.r,
          decoration: BoxDecoration(
            color: AppColors.iconGrey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Center(
            child: Icon(
              Icons.audiotrack,
              color: AppColors.iconGrey,
              size: 20.r,
            ),
          ),
        );
        break;
      case MessageEnum.call:
        child = Container(
          height: 40.r,
          width: 40.r,
          decoration: BoxDecoration(
            color: AppColors.iconGrey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Center(
            child: Icon(
              Icons.video_call_rounded,
              color: AppColors.iconGrey,
              size: 20.r,
            ),
          ),
        );
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        const Gap(6),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyle.bodyS.white.medium,
            ),
            Text(
              messageType == MessageEnum.text
                  ? message
                  : (showIcon ? messageType.message : messageType.name.capitalizeFirstLetter),
              style: AppTextStyle.caption.white,
            ),
          ],
        )
      ],
    );
  }
}
