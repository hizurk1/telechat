// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

/// This model data was shown on Home screen.
class ChatContactModel {
  final String contactId;
  final String name;
  final String profileImg;
  final DateTime timeSent;
  final String lastMessage;

  const ChatContactModel({
    required this.contactId,
    required this.name,
    required this.profileImg,
    required this.timeSent,
    required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'contactId': contactId,
      'name': name,
      'profileImg': profileImg,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
    };
  }

  factory ChatContactModel.fromMap(Map<String, dynamic> map) {
    return ChatContactModel(
      contactId: map['contactId'] as String,
      name: map['name'] as String,
      profileImg: map['profileImg'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      lastMessage: map['lastMessage'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatContactModel.fromJson(String source) => ChatContactModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
