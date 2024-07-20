// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:telechat/shared/models/user_model.dart';

enum SearchContactStatus { initial, loading, success, error }

class SearchContactState extends Equatable {
  final SearchContactStatus status;
  final List<UserModel> contactList;

  const SearchContactState({
    this.status = SearchContactStatus.initial,
    this.contactList = const [],
  });

  bool get isLoading => status == SearchContactStatus.loading;

  SearchContactState copyWith({
    SearchContactStatus? status,
    List<UserModel>? contactList,
  }) {
    return SearchContactState(
      status: status ?? this.status,
      contactList: contactList ?? this.contactList,
    );
  }

  @override
  List<Object> get props => [status, contactList];
}
