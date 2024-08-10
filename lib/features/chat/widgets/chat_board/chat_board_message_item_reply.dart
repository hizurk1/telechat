part of 'chat_board_message_item.dart';

class _ChatBoardMessageItemReply extends StatelessWidget {
  final MessageReply messageReply;
  final bool isMe;
  const _ChatBoardMessageItemReply({
    required this.messageReply,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 8.w).copyWith(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h).copyWith(right: 8.w),
      decoration: BoxDecoration(
        color: (isMe ? AppColors.primaryBright : AppColors.textGrey).withOpacity(0.25),
        borderRadius: BorderRadius.circular(8.r),
        border: Border(
          left: BorderSide(
            color: (isMe ? AppColors.primaryBright : AppColors.textGrey).withOpacity(0.6),
            width: 4,
          ),
        ),
      ),
      child: ChatBoardMessageReplyContentWidget(
        title: messageReply.replyTo,
        messageType: messageReply.messageType,
        message: messageReply.message,
        showIcon: false,
      ),
    );
  }
}
