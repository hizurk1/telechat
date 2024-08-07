import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/themes.dart';
import 'package:telechat/app/widgets/unfocus.dart';
import 'package:telechat/features/chat/widgets/chat_board/chat_board_bottom_input.dart';
import 'package:telechat/features/chat/widgets/chat_board/chat_board_title.dart';
import 'package:telechat/shared/models/user_model.dart';

class ChatPage extends StatefulWidget {
  static const String route = "/chat";
  const ChatPage({
    super.key,
    required this.contact,
  });

  final UserModel contact;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return UnfocusArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.white),
          automaticallyImplyLeading: true,
          titleSpacing: 10.w,
          title: ChatBoardTitleWidget(contactId: widget.contact.uid),
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
        bottomSheet: ChatPageBottomInputWidget(receiverId: widget.contact.uid),
      ),
    );
  }
}
