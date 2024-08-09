import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/constants/app_const.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/cached_network_image.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/core/extensions/build_context.dart';
import 'package:telechat/core/extensions/date_time.dart';
import 'package:telechat/features/chat/widgets/chat_board/chat_board_message_video_player.dart';
import 'package:telechat/shared/enums/message_enum.dart';

part 'chat_board_message_item_content.dart';

class ChatBoardMessageItemWidget extends StatelessWidget {
  final String message;
  final DateTime timeSent;
  final MessageEnum messageType;
  final bool isMe;
  final bool isSeen;
  const ChatBoardMessageItemWidget({
    super.key,
    required this.message,
    required this.timeSent,
    required this.messageType,
    required this.isMe,
    required this.isSeen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: context.screenWidth - 45.w,
          ),
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: isMe ? AppColors.primaryDark : AppColors.card,
            borderRadius: BorderRadius.circular(12.r).copyWith(
              bottomRight: isMe ? const Radius.circular(0) : null,
              bottomLeft: !isMe ? const Radius.circular(0) : null,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ChatMessageItemContent(
                message: message,
                messageType: messageType,
              ),
              const Gap.small(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timeSent.hhmmaa,
                      textAlign: TextAlign.end,
                      style: AppTextStyle.labelL.copyWith(
                        color: isMe ? AppColors.primaryBright : AppColors.textGrey,
                      ),
                      maxLines: 1,
                    ),
                    const Gap.xsmall(),
                    if (isMe)
                      Icon(
                        isSeen ? Icons.done_all_rounded : Icons.done_rounded,
                        color: isMe ? AppColors.primaryBright : AppColors.textGrey,
                        size: 18.r,
                      ),
                  ],
                ),
              ),
              const Gap.xsmall(),
            ],
          ),
        ),
      ],
    );
  }
}
