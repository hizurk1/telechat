import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/features/chat/controllers/chat_audio_controller.dart';

class ChatBoardMessageAudioWidget extends StatelessWidget {
  final String audioUrl;
  const ChatBoardMessageAudioWidget({
    super.key,
    required this.audioUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer(
          builder: (context, ref, child) {
            final isPlaying = ref.watch(chatAudioControllerProvider);
            final notifier = ref.read(chatAudioControllerProvider.notifier);
            return IconButton(
              onPressed: () {
                if (!isPlaying) {
                  notifier.playAudio(audioUrl);
                } else {
                  notifier.pauseAudio();
                }
              },
              icon: Icon(
                isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                color: AppColors.white,
                size: 24.r,
              ),
            );
          },
        ),
        Container(
          width: 140.w,
          height: 20.h,
          margin: EdgeInsets.only(right: 12.w),
          color: AppColors.textGrey.withOpacity(0.5),
        ),
      ],
    );
  }
}
