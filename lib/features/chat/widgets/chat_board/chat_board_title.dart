import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/cached_network_image.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/app/widgets/skeleton.dart';
import 'package:telechat/features/chat/controllers/chat_member_controller.dart';
import 'package:telechat/features/group/controllers/group_controller.dart';
import 'package:telechat/features/group/models/group_model.dart';
import 'package:telechat/shared/controllers/user_controller.dart';
import 'package:telechat/shared/models/user_model.dart';

part 'chat_board_title_skeleton.dart';

class ChatBoardTitleWidget extends ConsumerWidget {
  const ChatBoardTitleWidget({
    super.key,
    required this.chatId,
    this.groupName,
  });

  final String chatId;
  final String? groupName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.read(userControllerProvider).currentUser!.uid;
    final members = ref.read(chatMemberControllerProvider).members;
    final contactId = members.firstWhereOrNull((e) => e.uid != uid)?.uid ?? '';
    return groupName != null
        ? StreamBuilder<GroupModel?>(
            stream: ref.read(groupControllerProvider).getGroupInfoByIdAsStream(chatId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ChatBoardTitleSkeleton();
              }
              final groupModel = snapshot.data;
              return Row(
                children: [
                  CachedNetworkImageCustom.avatar(
                    imageUrl: groupModel?.groupAvatar ?? '',
                    loadingIndicatorSize: 0,
                    size: 42,
                  ),
                  const Gap.large(),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          groupModel?.groupName ?? '',
                          style: AppTextStyle.bodyM.medium,
                        ),
                        const Gap.xsmall(),
                        Text(
                          "${groupModel?.memberIds.length ?? 0} members",
                          style: AppTextStyle.labelL.sub,
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          )
        : StreamBuilder<UserModel?>(
            stream: ref.read(userControllerProvider).getUserContactAsStream(contactId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ChatBoardTitleSkeleton();
              }
              final userModel = snapshot.data;
              final isOnline = (userModel?.isOnline ?? false);
              return Row(
                children: [
                  CachedNetworkImageCustom.avatar(
                    imageUrl: userModel?.profileImage ?? '',
                    loadingIndicatorSize: 0,
                    size: 42,
                  ),
                  const Gap.large(),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userModel?.name ?? '',
                          style: AppTextStyle.bodyM.medium,
                        ),
                        const Gap.xsmall(),
                        Text(
                          isOnline ? "Online" : "Offline",
                          style: AppTextStyle.labelL.copyWith(
                            color: isOnline ? AppColors.primary : AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          );
  }
}
