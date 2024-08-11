// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io' show File;

import 'package:equatable/equatable.dart';
import 'package:telechat/shared/models/user_model.dart';

enum NewGroupStatus { initial, loading, success, error }

class NewGroupState extends Equatable {
  final NewGroupStatus status;
  final List<UserModel> contacts;
  final List<UserModel> searchContacts;
  final List<UserModel> selectedContacts;
  final File? image;
  final String groupName;

  const NewGroupState({
    this.status = NewGroupStatus.initial,
    this.contacts = const [],
    this.searchContacts = const [],
    this.selectedContacts = const [],
    this.groupName = '',
    this.image,
  });

  NewGroupState copyWith({
    NewGroupStatus? status,
    List<UserModel>? contacts,
    List<UserModel>? searchContacts,
    List<UserModel>? selectedContacts,
    File? image,
    String? groupName,
  }) {
    return NewGroupState(
      status: status ?? this.status,
      contacts: contacts ?? this.contacts,
      searchContacts: searchContacts ?? this.searchContacts,
      selectedContacts: selectedContacts ?? this.selectedContacts,
      image: image ?? this.image,
      groupName: groupName ?? this.groupName,
    );
  }

  @override
  List<Object?> get props {
    return [
      status,
      contacts,
      searchContacts,
      selectedContacts,
      image,
      groupName,
    ];
  }
}
