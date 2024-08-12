import 'package:equatable/equatable.dart';
import 'package:telechat/shared/models/user_model.dart';

enum ChatMemberStatus { loading, success, error }

class ChatMemberState extends Equatable {
  final ChatMemberStatus status;
  final List<UserModel> members;
  final String message;

  const ChatMemberState({
    this.status = ChatMemberStatus.loading,
    this.members = const [],
    this.message = '',
  });

  ChatMemberState copyWith({
    ChatMemberStatus? status,
    List<UserModel>? members,
    String? message,
  }) {
    return ChatMemberState(
      status: status ?? this.status,
      members: members ?? this.members,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, members, message];
}
