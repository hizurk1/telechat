import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/themes.dart';
import 'package:telechat/app/widgets/unfocus.dart';
import 'package:telechat/features/chat/controllers/chat_controller.dart';
import 'package:telechat/features/chat/widgets/chat_board/chat_board_bottom_input.dart';
import 'package:telechat/features/chat/widgets/chat_board/chat_board_list_view.dart';
import 'package:telechat/features/chat/widgets/chat_board/chat_board_message_reply.dart';
import 'package:telechat/features/chat/widgets/chat_board/chat_board_title.dart';

class ChatPage extends ConsumerStatefulWidget {
  static const String route = "/chat";
  const ChatPage({
    super.key,
    required this.contactId,
  });

  final String contactId;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatControllerProvider).cancelReplyMessage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return UnfocusArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.white),
          automaticallyImplyLeading: true,
          titleSpacing: 10.w,
          title: ChatBoardTitleWidget(contactId: widget.contactId),
          actions: [
            IconButton(
              onPressed: () {},
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
              child: ChatBoardListViewWidget(contactId: widget.contactId),
            ),
            const ChatBoardMessageReplyWidget(),
            ChatPageBottomInputWidget(receiverId: widget.contactId),
          ],
        ),
      ),
    );
  }
}
