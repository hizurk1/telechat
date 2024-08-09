import 'package:equatable/equatable.dart';

enum ChatRecordStatus { initial, ready, recording }

class ChatRecordState extends Equatable {
  final ChatRecordStatus status;
  final String audioPath;

  const ChatRecordState({
    this.status = ChatRecordStatus.initial,
    this.audioPath = '',
  });

  bool get isNotReady => status == ChatRecordStatus.initial;

  bool get isRecording => status == ChatRecordStatus.recording;

  ChatRecordState copyWith({
    ChatRecordStatus? status,
    String? audioPath,
  }) {
    return ChatRecordState(
      status: status ?? this.status,
      audioPath: audioPath ?? this.audioPath,
    );
  }

  @override
  List<Object> get props => [status, audioPath];
}
