/// This model data was shown on Home screen.
class ChatContactModel {
  final String chatId;
  final List<String> memberIds;
  final String createdUserId;
  final String lastSenderId;
  final String lastMessage;
  final DateTime timeSent;

  const ChatContactModel({
    required this.chatId,
    required this.memberIds,
    required this.createdUserId,
    required this.lastSenderId,
    required this.timeSent,
    required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatId': chatId,
      'memberIds': memberIds,
      'createdUserId': createdUserId,
      'lastSenderId': lastSenderId,
      'lastMessage': lastMessage,
      'timeSent': timeSent.millisecondsSinceEpoch,
    };
  }

  factory ChatContactModel.fromMap(Map<String, dynamic> map) {
    return ChatContactModel(
      chatId: map['chatId'] as String,
      memberIds: List<String>.from(map['memberIds']),
      createdUserId: map['createdUserId'] as String,
      lastSenderId: map['lastSenderId'] as String,
      lastMessage: map['lastMessage'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
    );
  }
}
