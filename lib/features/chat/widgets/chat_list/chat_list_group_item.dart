import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/cached_network_image.dart';
import 'package:telechat/core/extensions/date_time.dart';
import 'package:telechat/features/chat/pages/chat_page.dart';
import 'package:telechat/features/group/models/group_model.dart';
import 'package:telechat/shared/controllers/user_controller.dart';

class ChatListGroupItemWidget extends StatelessWidget {
  final GroupModel groupModel;
  const ChatListGroupItemWidget({super.key, required this.groupModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(
          context,
          ChatPage.route,
          arguments: {
            "chatId": groupModel.groupId,
            "memberIds": groupModel.memberIds,
            "groupName": groupModel.groupName,
          },
        );
      },
      tileColor: AppColors.cardMessage,
      leading: CachedNetworkImageCustom.avatar(
        imageUrl: groupModel.groupAvatar,
        size: 52,
      ),
      title: Text(
        groupModel.groupName,
        style: AppTextStyle.bodyM.medium,
      ),
      subtitle: Consumer(
        builder: (context, ref, child) {
          final uid = ref.read(userControllerProvider).currentUser!.uid;
          return Text.rich(
            TextSpan(children: [
              TextSpan(
                text: groupModel.lastSenderId == uid ? "You: " : "${groupModel.lastSenderName}: ",
                style: AppTextStyle.labelL.white.medium,
              ),
              TextSpan(text: groupModel.lastMessage),
            ]),
            style: AppTextStyle.labelL.sub,
          );
        },
      ),
      trailing: Text(
        groupModel.timeSent.dynamicDate,
        style: AppTextStyle.labelL.sub,
      ),
    );
  }
}
