import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/cached_network_image.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/app/widgets/skeleton.dart';
import 'package:telechat/shared/controllers/user_controller.dart';
import 'package:telechat/shared/models/user_model.dart';

part 'chat_board_title_skeleton.dart';

class ChatBoardTitleWidget extends ConsumerWidget {
  const ChatBoardTitleWidget({
    super.key,
    required this.contactId,
  });

  final String contactId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<UserModel?>(
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
                  const Gap(4),
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
