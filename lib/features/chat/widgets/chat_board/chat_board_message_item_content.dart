part of 'chat_board_message_item.dart';

class _ChatMessageItemContent extends StatelessWidget {
  final String message;
  final MessageEnum messageType;
  const _ChatMessageItemContent({
    required this.message,
    required this.messageType,
  });

  @override
  Widget build(BuildContext context) {
    String? caption;
    String url;
    if (message.contains(AppConst.captionSpliter)) {
      url = message.split(AppConst.captionSpliter).first;
      caption = message.split(AppConst.captionSpliter).last;
    } else {
      url = message;
    }

    Widget child = const SizedBox();
    switch (messageType) {
      case MessageEnum.text:
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w).copyWith(top: 8.h),
          child: Text(
            message,
            textAlign: TextAlign.start,
            style: AppTextStyle.bodyS.white,
          ),
        );
      case MessageEnum.image:
      case MessageEnum.video:
        if (messageType == MessageEnum.image) {
          child = CachedNetworkImageCustom(
            imageUrl: url,
          );
        } else if (messageType == MessageEnum.video) {
          child = ChatBoardMessageVideoPlayerWidget(videoUrl: url);
        }
        return caption != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  child,
                  const Gap.xsmall(),
                  Padding(
                    padding: EdgeInsets.only(left: 8.w, top: 4.h),
                    child: Text(
                      caption,
                      style: AppTextStyle.bodyS.white,
                    ),
                  ),
                ],
              )
            : child;
      case MessageEnum.gif:
        return CachedNetworkImageCustom(
          imageUrl: url,
        );
      default:
        return child;
    }
  }
}
