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
import 'package:telechat/features/chat/controllers/chat_record_controller.dart';
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
  File? media;
  bool isExpanded = false;

  @override
  void dispose() {
    _textInputController.dispose();
    _showSendButtonNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRecording = ref.watch(chatRecordControllerProvider).isRecording;
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
            onPressed: () {
              if (isExpanded) setState(() => isExpanded = false);
              ref.read(chatControllerProvider).pickGIF().then((gif) {
                if (gif != null) {
                  ref.read(chatControllerProvider).sendMessageAsGIF(
                        receiverId: widget.receiverId,
                        gifUrl: gif.url,
                      );
                }
              });
            },
            icon: Icon(
              Icons.gif_box_outlined,
              color: AppColors.iconGrey,
              size: 30.r,
            ),
          ),
          const Gap.xsmall(),
          Expanded(
            child: NoBorderTextField(
              controller: _textInputController,
              onChanged: (String text) {
                if (isExpanded) setState(() => isExpanded = false);
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
                isExpanded
                    ? Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() => isExpanded = false);
                              selectAttachVideo();
                            },
                            icon: Icon(
                              Icons.video_collection_outlined,
                              color: AppColors.iconGrey,
                              size: 24.r,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() => isExpanded = false);
                            },
                            icon: Icon(
                              Icons.audiotrack,
                              color: AppColors.iconGrey,
                              size: 24.r,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() => isExpanded = false);
                            },
                            icon: Icon(
                              Icons.camera_alt_outlined,
                              color: AppColors.iconGrey,
                              size: 24.r,
                            ),
                          ),
                        ],
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() => isExpanded = true);
                        },
                        icon: Icon(
                          Icons.attach_file_rounded,
                          color: AppColors.iconGrey,
                          size: 26.r,
                        ),
                      ),
                IconButton(
                  onPressed: () => onRecordingAudioPressed(),
                  icon: Icon(
                    isRecording ? Icons.stop_circle_outlined : Icons.keyboard_voice_outlined,
                    color: isRecording ? AppColors.primary : AppColors.iconGrey,
                    size: 30.r,
                  ),
                ),
              ],
            ),
            builder: (_, bool isShowSend, Widget? buttons) {
              return isShowSend
                  ? IconButton(
                      onPressed: () {
                        if (isExpanded) setState(() => isExpanded = false);
                        sendTextMessage();
                      },
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

  onRecordingAudioPressed() async {
    if (isExpanded) setState(() => isExpanded = false);

    final notifier = ref.read(chatRecordControllerProvider.notifier);
    final state = ref.read(chatRecordControllerProvider);
    if (state.isNotReady) {
      await notifier.initialize();
    }

    if (state.isRecording) {
      await notifier.stopRecording();
      if (state.audioPath.isNotEmpty) {
        await ref.read(chatControllerProvider).sendMessageAsMediaFile(
              messageType: MessageEnum.audio,
              receiverId: widget.receiverId,
              file: File(state.audioPath),
            );
      } else {
        AppNavigator.showMessage(
          "Can not find the audio file. Please try again.",
          type: SnackbarType.error,
        );
      }
    } else {
      await notifier.startRecording();
    }
  }

  selectAttachVideo() async {
    media = null;
    final pickedVideo = await ref.read(chatControllerProvider).pickVideoFromGallery();
    if (pickedVideo != null && mounted) {
      media = pickedVideo;
      ChatBoardSendMediaDialog(
        media: pickedVideo,
        type: MessageEnum.video,
        onSend: (String caption) {
          sendMediaFileMessage(caption.isNotEmpty ? caption : null, MessageEnum.video);
        },
      ).show(context);
    }
  }

  selectAttachImage() async {
    media = null;
    final pickedImage = await ref.read(chatControllerProvider).pickImageFromGallery();
    if (pickedImage != null && mounted) {
      media = pickedImage;
      ChatBoardSendMediaDialog(
        media: pickedImage,
        type: MessageEnum.image,
        onSend: (String caption) {
          sendMediaFileMessage(caption.isNotEmpty ? caption : null, MessageEnum.image);
        },
      ).show(context);
    }
  }

  sendMediaFileMessage(String? caption, MessageEnum type) async {
    if (media != null) {
      await ref.read(chatControllerProvider).sendMessageAsMediaFile(
            messageType: type,
            receiverId: widget.receiverId,
            file: media!,
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
