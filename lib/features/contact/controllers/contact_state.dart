// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:telechat/shared/models/user_model.dart';

enum ContactStatus { loading, success, error }

class ContactState extends Equatable {
  final ContactStatus status;
  final List<UserModel> contactList;
  final List<UserModel> searchList;

  const ContactState({
    this.status = ContactStatus.loading,
    this.contactList = const [],
    this.searchList = const [],
  });

  ContactState copyWith({
    ContactStatus? status,
    List<UserModel>? contactList,
    List<UserModel>? searchList,
  }) {
    return ContactState(
      status: status ?? this.status,
      contactList: contactList ?? this.contactList,
      searchList: searchList ?? this.searchList,
    );
  }

  @override
  List<Object> get props => [status, contactList, searchList];
}
