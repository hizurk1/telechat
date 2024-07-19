// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String name;
  final String profileImage;
  final String phoneNumber;
  final bool isOnline;
  final List<String> contactIds;
  final List<String> groupIds;
  const UserModel({
    required this.uid,
    required this.name,
    required this.profileImage,
    required this.phoneNumber,
    required this.isOnline,
    required this.contactIds,
    required this.groupIds,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? profileImage,
    String? phoneNumber,
    bool? isOnline,
    List<String>? contactIds,
    List<String>? groupIds,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isOnline: isOnline ?? this.isOnline,
      contactIds: contactIds ?? this.contactIds,
      groupIds: groupIds ?? this.groupIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'profileImage': profileImage,
      'phoneNumber': phoneNumber,
      'isOnline': isOnline,
      'contactIds': contactIds,
      'groupIds': groupIds,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      profileImage: map['profileImage'] as String,
      phoneNumber: map['phoneNumber'] as String,
      isOnline: map['isOnline'] as bool,
      contactIds: List<String>.from((map['contactIds'])),
      groupIds: List<String>.from((map['groupIds'])),
    );
  }
  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      uid,
      name,
      profileImage,
      phoneNumber,
      isOnline,
      contactIds,
      groupIds,
    ];
  }
}
