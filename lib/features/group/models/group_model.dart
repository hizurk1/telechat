// ignore_for_file: public_member_api_docs, sort_constructors_first


class GroupModel {
  final String groupId;
  final String groupName;
  final String groupAvatar;
  final String lastMessage;
  final String lastSenderId; // who sent last message
  final String lastSenderName; // who sent last message
  final DateTime timeSent;
  final List<String> memberIds;

  const GroupModel({
    required this.groupId,
    required this.groupName,
    required this.groupAvatar,
    required this.lastMessage,
    required this.lastSenderId,
    required this.lastSenderName,
    required this.timeSent,
    required this.memberIds,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupId': groupId,
      'groupName': groupName,
      'groupAvatar': groupAvatar,
      'lastMessage': lastMessage,
      'lastSenderId': lastSenderId,
      'lastSenderName': lastSenderName,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'memberIds': memberIds,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      groupId: map['groupId'] as String,
      groupName: map['groupName'] as String,
      groupAvatar: map['groupAvatar'] as String,
      lastMessage: map['lastMessage'] as String,
      lastSenderId: map['lastSenderId'] as String,
      lastSenderName: map['lastSenderName'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      memberIds: List<String>.from(map['memberIds']),
    );
  }
}
