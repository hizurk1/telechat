import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/utils/navigator.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/app/widgets/no_border_text_field.dart';
import 'package:telechat/core/extensions/build_context.dart';
import 'package:telechat/features/chat/controllers/chat_controller.dart';
import 'package:telechat/features/chat/widgets/chat_board/chat_board_send_image_dialog.dart';
import 'package:telechat/shared/enums/message_enum.dart';

class ChatPageBottomInputWidget extends ConsumerStatefulWidget {
  final String receiverId;

  const ChatPageBottomInputWidget({
    super.key,
    required this.receiverId,
  });

  @override
  ConsumerState<ChatPageBottomInputWidget> createState() => _ChatPageBottomInputWidgetState();
}

class _ChatPageBottomInputWidgetState extends ConsumerState<ChatPageBottomInputWidget> {
  final _textInputController = TextEditingController();
  final _showSendButtonNotifier = ValueNotifier(false);
  File? image;

  @override
  void dispose() {
    _textInputController.dispose();
    _showSendButtonNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            offset: const Offset(0, -1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.emoji_emotions_outlined,
              color: AppColors.iconGrey,
              size: 30.r,
            ),
          ),
          const Gap.xsmall(),
          Expanded(
            child: NoBorderTextField(
              controller: _textInputController,
              onChanged: (String text) {
                if (text.isNotEmpty && !_showSendButtonNotifier.value) {
                  _showSendButtonNotifier.value = true;
                } else if (text.isEmpty && _showSendButtonNotifier.value) {
                  _showSendButtonNotifier.value = false;
                }
              },
              hintText: "Enter message",
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _showSendButtonNotifier,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => selectAttachImage(),
                  icon: Icon(
                    Icons.attach_file_rounded,
                    color: AppColors.iconGrey,
                    size: 30.r,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.keyboard_voice_outlined,
                    color: AppColors.iconGrey,
                    size: 30.r,
                  ),
                ),
              ],
            ),
            builder: (_, bool isShowSend, Widget? buttons) {
              return isShowSend
                  ? IconButton(
                      onPressed: () => sendTextMessage(),
                      icon: Icon(
                        Icons.send_rounded,
                        color: AppColors.primary,
                        size: 30.r,
                      ),
                    )
                  : buttons!;
            },
          ),
        ],
      ),
    );
  }

  selectAttachImage() async {
    image = null;
    final pickedImage = await ref.read(chatControllerProvider).pickImageFromGallery();
    if (pickedImage != null && mounted) {
      image = pickedImage;
      ChatBoardSendImageDialog(
        image: pickedImage,
        onSend: (String caption) {
          sendMediaFileMessage(caption.isNotEmpty ? caption : null);
        },
      ).show(context);
    } else {
      AppNavigator.showMessage(
        "Can not select this image! Please try again.",
        type: SnackbarType.error,
      );
    }
  }

  sendMediaFileMessage(String? caption) async {
    if (image != null) {
      await ref.read(chatControllerProvider).sendMessageAsMediaFile(
            messageType: MessageEnum.image,
            receiverId: widget.receiverId,
            file: image!,
            caption: caption,
          );
    }
  }

  sendTextMessage() async {
    if (!_showSendButtonNotifier.value) return;
    if (_textInputController.text.isEmpty) return;

    final textMessage = _textInputController.text.trim();
    _textInputController.clear();
    await ref.read(chatControllerProvider).sendMessageAsText(
          receiverId: widget.receiverId,
          textMessage: textMessage,
        );
  }
}
