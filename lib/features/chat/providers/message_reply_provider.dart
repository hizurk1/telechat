import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/shared/enums/message_enum.dart';

class MessageReply {
  final String replyTo;
  final String message;
  final MessageEnum messageType;

  const MessageReply({
    required this.replyTo,
    required this.message,
    required this.messageType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'replyTo': replyTo,
      'message': message,
      'messageType': messageType.name,
    };
  }

  factory MessageReply.fromMap(Map<String, dynamic> map) {
    return MessageReply(
      replyTo: map['replyTo'] as String,
      message: map['message'] as String,
      messageType: MessageEnum.fromString(map['messageType']),
    );
  }
}

final messageReplyProvider = StateProvider<MessageReply?>((ref) => null);
