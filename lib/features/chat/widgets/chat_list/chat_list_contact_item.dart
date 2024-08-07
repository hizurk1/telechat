import 'package:flutter/material.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/cached_network_image.dart';
import 'package:telechat/core/extensions/date_time.dart';
import 'package:telechat/features/chat/models/chat_contact_model.dart';
import 'package:telechat/features/chat/pages/chat_page.dart';

class ChatListContactItemWidget extends StatelessWidget {
  final ChatContactModel chatContact;
  const ChatListContactItemWidget({
    super.key,
    required this.chatContact,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(
          context,
          ChatPage.route,
          arguments: {
            "contactId": chatContact.contactId,
          },
        );
      },
      tileColor: AppColors.cardMessage,
      leading: CachedNetworkImageCustom.avatar(
        imageUrl: chatContact.profileImg,
        size: 52,
      ),
      title: Text(
        chatContact.name,
        style: AppTextStyle.bodyM.medium,
      ),
      subtitle: Text(
        chatContact.lastMessage,
        style: AppTextStyle.labelL.sub,
      ),
      trailing: Text(
        chatContact.timeSent.dynamicDate,
        style: AppTextStyle.labelL.sub,
      ),
    );
  }
}
