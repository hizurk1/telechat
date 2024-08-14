class CallModel {
  final String callId;
  final String chatId;
  final String callerId;
  final String callerName;
  final String callerAvatar;
  final List<String> receiverIds;
  final bool isGroup;
  final bool hasDialled;

  CallModel({
    required this.callId,
    required this.chatId,
    required this.callerId,
    required this.callerName,
    required this.callerAvatar,
    required this.receiverIds,
    required this.isGroup,
    required this.hasDialled,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'callId': callId,
      'chatId': chatId,
      'callerId': callerId,
      'callerName': callerName,
      'callerAvatar': callerAvatar,
      'receiverIds': receiverIds,
      'isGroup': isGroup,
      'hasDialled': hasDialled,
    };
  }

  factory CallModel.fromMap(Map<String, dynamic> map) {
    return CallModel(
      callId: map['callId'] as String,
      chatId: map['chatId'] as String,
      callerId: map['callerId'] as String,
      callerName: map['callerName'] as String,
      callerAvatar: map['callerAvatar'] as String,
      receiverIds: List<String>.from(map['receiverIds']),
      isGroup: map['isGroup'] as bool,
      hasDialled: map['hasDialled'] as bool,
    );
  }

  CallModel copyWith({
    String? callId,
    String? chatId,
    String? callerId,
    String? callerName,
    String? callerAvatar,
    List<String>? receiverIds,
    bool? isGroup,
    bool? hasDialled,
  }) {
    return CallModel(
      callId: callId ?? this.callId,
      chatId: chatId ?? this.chatId,
      callerId: callerId ?? this.callerId,
      callerName: callerName ?? this.callerName,
      callerAvatar: callerAvatar ?? this.callerAvatar,
      receiverIds: receiverIds ?? this.receiverIds,
      isGroup: isGroup ?? this.isGroup,
      hasDialled: hasDialled ?? this.hasDialled,
    );
  }
}
