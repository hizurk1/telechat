import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/configs/remote_config.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/widgets/loading_indicator.dart';
import 'package:telechat/features/call/controllers/call_controller.dart';
import 'package:telechat/features/call/models/call_model.dart';

class CallPage extends ConsumerStatefulWidget {
  static const String route = "/call";
  final String channelId;
  final CallModel callModel;
  final bool isGroup;
  const CallPage({
    super.key,
    required this.channelId,
    required this.callModel,
    required this.isGroup,
  });

  @override
  ConsumerState<CallPage> createState() => _CallPageState();
}

class _CallPageState extends ConsumerState<CallPage> {
  final _stopwatch = Stopwatch();
  AgoraClient? _agoraClient;

  @override
  void initState() {
    super.initState();
    _agoraClient = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: RemoteConfig.agoraAppID,
        tokenUrl: RemoteConfig.callTokenUrl,
        channelName: widget.channelId,
      ),
    );
    _initAgora();
  }

  _initAgora() async {
    await _agoraClient!.initialize();
    _stopwatch.start();
    setState(() {});
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_agoraClient!.isInitialized
          ? const LoadingIndicatorPage()
          : SafeArea(
              child: Stack(
                children: [
                  AgoraVideoViewer(client: _agoraClient!),
                  AgoraVideoButtons(
                    client: _agoraClient!,
                    disconnectButtonChild: IconButton.filled(
                      onPressed: () async {
                        _stopwatch.stop();
                        await _agoraClient!.engine.leaveChannel();
                        await ref.read(callControllerProvider).endCall(
                              callerId: widget.callModel.callerId,
                              chatId: widget.callModel.chatId,
                              memberIds: widget.callModel.receiverIds,
                              timeCalledInSec: _stopwatch.elapsed.inSeconds,
                              isGroupCall: widget.isGroup,
                            );
                      },
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.redAccent),
                      ),
                      padding: EdgeInsets.all(12.r),
                      icon: Icon(
                        Icons.call_end,
                        color: AppColors.white,
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
