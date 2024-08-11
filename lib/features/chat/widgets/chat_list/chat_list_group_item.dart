import 'package:flutter/material.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/cached_network_image.dart';
import 'package:telechat/core/extensions/date_time.dart';
import 'package:telechat/features/group/models/group_model.dart';

class ChatListGroupItemWidget extends StatelessWidget {
  final GroupModel groupModel;
  const ChatListGroupItemWidget({super.key, required this.groupModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      tileColor: AppColors.cardMessage,
      leading: CachedNetworkImageCustom.avatar(
        imageUrl: groupModel.groupAvatar,
        size: 52,
      ),
      title: Text(
        groupModel.groupName,
        style: AppTextStyle.bodyM.medium,
      ),
      subtitle: Text(
        groupModel.lastMessage,
        style: AppTextStyle.labelL.sub,
      ),
      trailing: Text(
        groupModel.timeSent.dynamicDate,
        style: AppTextStyle.labelL.sub,
      ),
    );
  }
}
