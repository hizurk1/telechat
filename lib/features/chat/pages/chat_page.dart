import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/themes.dart';
import 'package:telechat/app/widgets/error_page.dart';
import 'package:telechat/app/widgets/loading_indicator.dart';
import 'package:telechat/app/widgets/unfocus.dart';
import 'package:telechat/features/call/controllers/call_controller.dart';
import 'package:telechat/features/chat/controllers/chat_controller.dart';
import 'package:telechat/features/chat/controllers/chat_member_controller.dart';
import 'package:telechat/features/chat/controllers/chat_member_state.dart';
import 'package:telechat/features/chat/widgets/chat_board/chat_board_bottom_input.dart';
import 'package:telechat/features/chat/widgets/chat_board/chat_board_list_view.dart';
import 'package:telechat/features/chat/widgets/chat_board/chat_board_message_reply.dart';
import 'package:telechat/features/chat/widgets/chat_board/chat_board_title.dart';

class ChatPage extends ConsumerStatefulWidget {
  static const String route = "/chat";
  const ChatPage({
    super.key,
    required this.chatId,
    required this.memberIds,
    this.groupName,
  });

  final String chatId;
  final List<String> memberIds;
  final String? groupName;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatControllerProvider).cancelReplyMessage();
      ref.read(chatMemberControllerProvider.notifier).fetchMemberInfoOfChat(widget.memberIds);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatMemberControllerProvider);
    return switch (state.status) {
      ChatMemberStatus.loading => const LoadingIndicatorPage(),
      ChatMemberStatus.error => ErrorPage(
          onRetry: () => ref
              .read(chatMemberControllerProvider.notifier)
              .fetchMemberInfoOfChat(widget.memberIds),
        ),
      ChatMemberStatus.success => UnfocusArea(
          child: Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: AppColors.white),
              automaticallyImplyLeading: true,
              titleSpacing: 10.w,
              title: ChatBoardTitleWidget(
                chatId: widget.chatId,
                groupName: widget.groupName,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    ref.read(callControllerProvider).makeCall(
                          isGroupCall: widget.groupName != null,
                          chatId: widget.chatId,
                        );
                  },
                  icon: const Icon(
                    Icons.call,
                    color: AppColors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ChatBoardListViewWidget(
                    chatId: widget.chatId,
                    isGroup: widget.groupName != null,
                  ),
                ),
                const ChatBoardMessageReplyWidget(),
                ChatPageBottomInputWidget(
                  chatId: widget.chatId,
                  isGroup: widget.groupName != null,
                ),
              ],
            ),
          ),
        ),
    };
  }
}
