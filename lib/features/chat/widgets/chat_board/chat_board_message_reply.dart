import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/core/extensions/build_context.dart';
import 'package:telechat/features/chat/providers/message_reply_provider.dart';
import 'package:telechat/features/chat/widgets/chat_board/chat_board_message_reply_content.dart';

class ChatBoardMessageReplyWidget extends ConsumerWidget {
  const ChatBoardMessageReplyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    if (messageReply != null) {
      return Container(
        width: context.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h).copyWith(right: 8.w),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.background)),
          color: AppColors.card,
        ),
        child: Row(
          children: [
            Icon(
              Icons.reply_rounded,
              color: AppColors.iconGrey,
              size: 30.r,
            ),
            const Gap.medium(),
            Expanded(
              child: ChatBoardMessageReplyContentWidget(
                title: "Reply to ${messageReply.replyTo}",
                message: messageReply.message,
                messageType: messageReply.messageType,
              ),
            ),
            IconButton(
              onPressed: () => ref.read(messageReplyProvider.notifier).update((_) => null),
              icon: Icon(
                Icons.close,
                color: AppColors.iconGrey,
                size: 24.r,
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
