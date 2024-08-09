import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatAudioControllerProvider =
    StateNotifierProvider.autoDispose<ChatAudioController, bool>((ref) {
  final audioPlayer = AudioPlayer();
  ref.onDispose(() => audioPlayer.dispose());
  return ChatAudioController(audioPlayer);
});

class ChatAudioController extends StateNotifier<bool> {
  final AudioPlayer audioPlayer;
  ChatAudioController(this.audioPlayer) : super(false);

  Future<void> playAudio(String url) async {
    await audioPlayer.stop();
    await audioPlayer.play(UrlSource(url));
    state = true;
  }

  Future<void> pauseAudio() async {
    await audioPlayer.pause();
    state = false;
  }

  Future<void> stopAudio() async {
    await audioPlayer.stop();
    state = false;
  }
}
