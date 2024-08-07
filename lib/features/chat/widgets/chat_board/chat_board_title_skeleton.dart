part of 'chat_board_title.dart';

class ChatBoardTitleSkeleton extends StatelessWidget {
  const ChatBoardTitleSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Skeleton.circle(size: 42, color: AppColors.textGrey.withOpacity(0.25)),
        const Gap.large(),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Skeleton(height: 15, width: 70, color: AppColors.textGrey.withOpacity(0.25)),
              const Gap.xsmall(),
              Skeleton(height: 10, width: 40, color: AppColors.textGrey.withOpacity(0.25)),
            ],
          ),
        )
      ],
    );
  }
}
