import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/cached_network_image.dart';
import 'package:telechat/core/extensions/date_time.dart';
import 'package:telechat/features/chat/models/chat_contact_model.dart';
import 'package:telechat/features/chat/pages/chat_page.dart';
import 'package:telechat/shared/controllers/user_controller.dart';
import 'package:telechat/shared/models/user_model.dart';

class ChatListContactItemWidget extends ConsumerWidget {
  final ChatContactModel chatContact;
  const ChatListContactItemWidget({
    super.key,
    required this.chatContact,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.read(userControllerProvider).currentUser!.uid;
    final contactId = chatContact.memberIds.where((e) => e != uid).first;
    return FutureBuilder<UserModel?>(
      future: ref.read(userControllerProvider).getUserDataById(contactId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        return ListTile(
          onTap: () {
            Navigator.pushNamed(
              context,
              ChatPage.route,
              arguments: {
                "chatId": chatContact.chatId,
                "memberIds": chatContact.memberIds,
              },
            );
          },
          tileColor: AppColors.cardMessage,
          leading: CachedNetworkImageCustom.avatar(
            imageUrl: snapshot.data?.profileImage ?? '',
            size: 52,
          ),
          title: Text(
            snapshot.data?.name ?? '',
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
      },
    );
  }
}
