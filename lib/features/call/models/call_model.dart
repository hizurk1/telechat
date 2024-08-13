class CallModel {
  final String callId;
  final String callerId;
  final String callerName;
  final String callerAvatar;
  final List<String> receiverIds;
  final bool hasDialled;

  CallModel({
    required this.callId,
    required this.callerId,
    required this.callerName,
    required this.callerAvatar,
    required this.receiverIds,
    required this.hasDialled,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'callId': callId,
      'callerId': callerId,
      'callerName': callerName,
      'callerAvatar': callerAvatar,
      'receiverIds': receiverIds,
      'hasDialled': hasDialled,
    };
  }

  factory CallModel.fromMap(Map<String, dynamic> map) {
    return CallModel(
      callId: map['callId'] as String,
      callerId: map['callerId'] as String,
      callerName: map['callerName'] as String,
      callerAvatar: map['callerAvatar'] as String,
      receiverIds: List<String>.from(map['receiverIds']),
      hasDialled: map['hasDialled'] as bool,
    );
  }

  CallModel copyWith({
    String? callId,
    String? callerId,
    String? callerName,
    String? callerAvatar,
    List<String>? receiverIds,
    bool? hasDialled,
  }) {
    return CallModel(
      callId: callId ?? this.callId,
      callerId: callerId ?? this.callerId,
      callerName: callerName ?? this.callerName,
      callerAvatar: callerAvatar ?? this.callerAvatar,
      receiverIds: receiverIds ?? this.receiverIds,
      hasDialled: hasDialled ?? this.hasDialled,
    );
  }
}
