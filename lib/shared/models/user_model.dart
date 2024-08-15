// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String name;
  final String profileImage;
  final String phoneNumber;
  final DateTime? dateOfBirth;
  final DateTime createdDate;
  final bool isOnline;
  final List<String> contactIds;
  final List<String> blockedIds;
  final List<String> groupIds;
  const UserModel({
    required this.uid,
    required this.name,
    required this.profileImage,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.createdDate,
    required this.isOnline,
    required this.contactIds,
    required this.blockedIds,
    required this.groupIds,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? profileImage,
    String? phoneNumber,
    DateTime? dateOfBirth,
    DateTime? createdDate,
    bool? isOnline,
    List<String>? contactIds,
    List<String>? blockedIds,
    List<String>? groupIds,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      createdDate: createdDate ?? this.createdDate,
      isOnline: isOnline ?? this.isOnline,
      contactIds: contactIds ?? this.contactIds,
      blockedIds: blockedIds ?? this.blockedIds,
      groupIds: groupIds ?? this.groupIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'profileImage': profileImage,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth?.millisecondsSinceEpoch,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'isOnline': isOnline,
      'contactIds': contactIds,
      'blockedIds': blockedIds,
      'groupIds': groupIds,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      profileImage: map['profileImage'] as String,
      phoneNumber: map['phoneNumber'] as String,
      dateOfBirth: map['dateOfBirth'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'])
          : null,
      createdDate: DateTime.fromMillisecondsSinceEpoch(map['createdDate']),
      isOnline: map['isOnline'] as bool,
      contactIds: List<String>.from(map['contactIds']),
      blockedIds: List<String>.from(map['blockedIds']),
      groupIds: List<String>.from(map['groupIds']),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      uid,
      name,
      profileImage,
      phoneNumber,
      dateOfBirth,
      createdDate,
      isOnline,
      contactIds,
      blockedIds,
      groupIds,
    ];
  }
}
