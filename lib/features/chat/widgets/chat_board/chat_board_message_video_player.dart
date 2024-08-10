import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/widgets/loading_indicator.dart';
import 'package:telechat/core/extensions/build_context.dart';

class ChatBoardMessageVideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const ChatBoardMessageVideoPlayerWidget({
    super.key,
    required this.videoUrl,
  });

  @override
  State<ChatBoardMessageVideoPlayerWidget> createState() =>
      _ChatBoardMessageVideoPlayerWidgetState();
}

class _ChatBoardMessageVideoPlayerWidgetState extends State<ChatBoardMessageVideoPlayerWidget> {
  late CachedVideoPlayerController _videoController;
  bool showButton = true;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoController = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        _videoController.setVolume(1.0);
        _videoController.setLooping(true);
        setState(() {});
      });
    _videoController.addListener(_listenToVideoChanged);
  }

  @override
  void dispose() {
    _videoController.removeListener(_listenToVideoChanged);
    _videoController.dispose();
    super.dispose();
  }

  void _listenToVideoChanged() {
    if (_videoController.value.isPlaying) {
      setState(() {
        isPlaying = true;
      });
    } else {
      setState(() {
        isPlaying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => showButton = true),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: context.screenWidth * 0.5,
          maxWidth: context.screenWidth * 0.9,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            _videoController.value.isInitialized
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: CachedVideoPlayer(_videoController),
                    ),
                  )
                : const LoadingIndicatorWidget(),
            if (showButton)
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: () {
                    if (!_videoController.value.isPlaying) {
                      _videoController.play();
                    } else {
                      _videoController.pause();
                    }
                    Future.delayed(
                      Durations.extralong4,
                      () => setState(() => showButton = false),
                    );
                  },
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_filled_rounded,
                    color: AppColors.textGrey,
                    size: 40.r,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
