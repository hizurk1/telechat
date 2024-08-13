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
    setState(() {});
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
                        await _agoraClient!.engine.leaveChannel();
                        await ref.read(callControllerProvider).endCall(
                              callerId: widget.callModel.callerId,
                              memberIds: widget.callModel.receiverIds,
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
