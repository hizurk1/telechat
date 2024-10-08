import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/utils/navigator.dart';
import 'package:telechat/app/utils/util_function.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/app/widgets/no_border_text_field.dart';
import 'package:telechat/core/extensions/build_context.dart';
import 'package:telechat/features/chat/controllers/chat_controller.dart';
import 'package:telechat/features/chat/controllers/chat_record_controller.dart';
import 'package:telechat/features/chat/widgets/chat_board/chat_board_send_image_dialog.dart';
import 'package:telechat/features/group/controllers/group_controller.dart';
import 'package:telechat/shared/enums/message_enum.dart';

class ChatPageBottomInputWidget extends ConsumerStatefulWidget {
  final String chatId;
  final bool isGroup;
  const ChatPageBottomInputWidget({
    super.key,
    required this.chatId,
    required this.isGroup,
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
  void initState() {
    super.initState();
    _textInputController.addListener(_listenToTextChanged);
  }

  void _listenToTextChanged() {
    if (isExpanded) setState(() => isExpanded = false);
    if (_textInputController.text.isNotEmpty && !_showSendButtonNotifier.value) {
      _showSendButtonNotifier.value = true;
    } else if (_textInputController.text.isEmpty && _showSendButtonNotifier.value) {
      _showSendButtonNotifier.value = false;
    }
  }

  @override
  void dispose() {
    _textInputController.removeListener(_listenToTextChanged);
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
            onPressed: () => onSelectGIF(),
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
                              selectAttachImage();
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
                Consumer(
                  builder: (context, ref, child) {
                    final isRecording = ref.watch(chatRecordControllerProvider).isRecording;
                    return IconButton(
                      onPressed: () => onRecordingAudioPressed(),
                      icon: Icon(
                        isRecording ? Icons.stop_circle_outlined : Icons.keyboard_voice_outlined,
                        color: isRecording ? AppColors.primary : AppColors.iconGrey,
                        size: 30.r,
                      ),
                    );
                  },
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

  onSelectGIF() {
    if (isExpanded) setState(() => isExpanded = false);
    ref.read(chatControllerProvider).pickGIF().then((gif) {
      if (gif == null) return;
      if (widget.isGroup) {
        ref.read(groupControllerProvider).sendMessageAsGIFInGroup(
              groupId: widget.chatId,
              gifUrl: gif.url,
            );
      } else {
        ref.read(chatControllerProvider).sendMessageAsGIF(
              chatId: widget.chatId,
              gifUrl: gif.url,
            );
      }
    });
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
        if (widget.isGroup) {
          await ref.read(groupControllerProvider).sendMessageAsMediaFileInGroup(
                groupId: widget.chatId,
                messageType: MessageEnum.audio,
                file: File(state.audioPath),
              );
        } else {
          await ref.read(chatControllerProvider).sendMessageAsMediaFile(
                chatId: widget.chatId,
                messageType: MessageEnum.audio,
                file: File(state.audioPath),
              );
        }
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
    final pickedVideo = await UtilsFunction.pickVideoFromGallery();
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
    final pickedImage = await UtilsFunction.pickImageFromGallery();
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
    if (media == null) return;
    if (widget.isGroup) {
      await ref.read(groupControllerProvider).sendMessageAsMediaFileInGroup(
            groupId: widget.chatId,
            messageType: type,
            file: media!,
            caption: caption,
          );
    } else {
      await ref.read(chatControllerProvider).sendMessageAsMediaFile(
            chatId: widget.chatId,
            messageType: type,
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
    if (widget.isGroup) {
      await ref.read(groupControllerProvider).sendMessageAsTextInGroup(
            groupId: widget.chatId,
            textMessage: textMessage,
          );
    } else {
      await ref.read(chatControllerProvider).sendMessageAsText(
            chatId: widget.chatId,
            textMessage: textMessage,
          );
    }
  }
}
