import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/themes.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/app/widgets/loading_indicator.dart';
import 'package:telechat/core/extensions/date_time.dart';
import 'package:telechat/features/chat/controllers/chat_controller.dart';
import 'package:telechat/features/chat/models/chat_message_model.dart';
import 'package:telechat/features/chat/widgets/chat_board/chat_board_list_empty.dart';
import 'package:telechat/features/chat/widgets/chat_board/chat_board_message_item.dart';
import 'package:telechat/shared/controllers/user_controller.dart';

class ChatBoardListViewWidget extends ConsumerStatefulWidget {
  final String contactId;
  const ChatBoardListViewWidget({
    super.key,
    required this.contactId,
  });

  @override
  ConsumerState<ChatBoardListViewWidget> createState() => _ChatBoardListViewWidgetState();
}

class _ChatBoardListViewWidgetState extends ConsumerState<ChatBoardListViewWidget> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = ref.read(userControllerProvider).currentUser!.uid;
    return StreamBuilder<List<ChatMessageModel>>(
      stream: ref.watch(chatControllerProvider).getListOfChatMessages(
            contactId: widget.contactId,
          ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicatorPage();
        }
        final List<ChatMessageModel>? chatMessages = snapshot.data;
        return chatMessages != null
            ? chatMessages.isNotEmpty
                ? ListView.separated(
                    controller: _scrollController,
                    itemCount: chatMessages.length,
                    padding: EdgeInsets.all(16.r),
                    reverse: true,
                    separatorBuilder: (_, int i) => _buildSeperator(uid, i, chatMessages),
                    itemBuilder: (context, int index) {
                      final chatMessage = chatMessages[index];
                      return ChatBoardMessageItemWidget(
                        username: chatMessage.username,
                        message: chatMessage.textMessage,
                        timeSent: chatMessage.timeSent,
                        messageType: chatMessage.messageType,
                        isSeen: chatMessage.isSeen,
                        isMe: chatMessage.senderId == uid,
                        messageReply: chatMessage.messageReply,
                      );
                    },
                  )
                : const ChatBoardListEmptyWidget()
            : Container();
      },
    );
  }

  /// Seperator is in between `currentMessage` and `nextMessage`.
  /// And it places on top of the `nextMessage`.
  Widget _buildSeperator(String uid, int i, List<ChatMessageModel> chatMessages) {
    final currentMessage = chatMessages[i];
    final nextMessage = chatMessages[i + 1];

    if (!currentMessage.timeSent.isSameDay(nextMessage.timeSent)) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4.r, horizontal: 8.r),
            margin: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: AppColors.cardMessage,
            ),
            child: Text(
              nextMessage.timeSent.formatDateForSeparator(),
              style: AppTextStyle.caption.dark,
            ),
          ),
        ],
      );
    } else {
      final isMe = chatMessages[i].senderId == uid;
      if (i + 1 < chatMessages.length &&
          ((isMe && chatMessages[i + 1].senderId != uid) ||
              (!isMe && chatMessages[i + 1].senderId == uid))) {
        return const Gap.medium();
      } else {
        return const Gap.xsmall();
      }
    }
  }
}
