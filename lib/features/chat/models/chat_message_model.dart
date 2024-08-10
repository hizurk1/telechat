// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:telechat/features/chat/providers/message_reply_provider.dart';
import 'package:telechat/shared/enums/message_enum.dart';

class ChatMessageModel {
  final String messageId;
  final String senderId;
  final String receiverId;
  final String textMessage;
  final DateTime timeSent;
  final MessageEnum messageType;
  final bool isSeen;
  final String username;
  final MessageReply? messageReply;

  ChatMessageModel({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.textMessage,
    required this.timeSent,
    required this.messageType,
    required this.isSeen,
    required this.username,
    required this.messageReply,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messageId': messageId,
      'senderId': senderId,
      'receiverId': receiverId,
      'textMessage': textMessage,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageType': messageType.name,
      'isSeen': isSeen,
      'username': username,
      'messageReply': messageReply?.toMap(),
    };
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      messageId: map['messageId'] as String,
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      textMessage: map['textMessage'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      messageType: MessageEnum.fromString(map['messageType']),
      isSeen: map['isSeen'] as bool,
      username: map['username'] as String,
      messageReply: map['messageReply'] != null
          ? MessageReply.fromMap(map['messageReply'] as Map<String, dynamic>)
          : null,
    );
  }
}
