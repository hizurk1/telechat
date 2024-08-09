import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telechat/app/utils/navigator.dart';
import 'package:telechat/features/chat/controllers/chat_record_state.dart';

final chatRecordControllerProvider =
    StateNotifierProvider.autoDispose<ChatRecordController, ChatRecordState>((ref) {
  final soundRecorder = FlutterSoundRecorder();
  ref.onDispose(
    () {
      soundRecorder.closeRecorder();
    },
  );
  return ChatRecordController(
    soundRecorder: soundRecorder,
  );
});

class ChatRecordController extends StateNotifier<ChatRecordState> {
  final FlutterSoundRecorder soundRecorder;
  ChatRecordController({
    required this.soundRecorder,
  }) : super(const ChatRecordState());

  Future<void> initialize() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      AppNavigator.showMessage(
        "Please grant the microphone permission!",
        type: SnackbarType.error,
      );
    } else {
      await soundRecorder.openRecorder();
      state = state.copyWith(status: ChatRecordStatus.ready);
    }
  }

  Future<void> startRecording() async {
    if (state.isNotReady) return;
    state = state.copyWith(status: ChatRecordStatus.recording, audioPath: '');

    final tempDir = await getTemporaryDirectory();
    final audioPath = "${tempDir.path}/flutter_sound.aac";
    await soundRecorder.startRecorder(
      toFile: audioPath,
    );

    state = state.copyWith(audioPath: audioPath);
  }

  Future<void> stopRecording() async {
    await soundRecorder.stopRecorder();
    state = state.copyWith(status: ChatRecordStatus.ready, audioPath: '');
  }
}
