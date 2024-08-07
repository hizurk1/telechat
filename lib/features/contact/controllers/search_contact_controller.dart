import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/utils/navigator.dart';
import 'package:telechat/core/config/app_log.dart';
import 'package:telechat/features/contact/controllers/search_contact_state.dart';
import 'package:telechat/features/contact/repository/contact_repository.dart';
import 'package:telechat/shared/models/user_model.dart';
import 'package:telechat/shared/repositories/user_repository.dart';

final searchContactControllerProvider =
    StateNotifierProvider.autoDispose<SearchContactController, SearchContactState>((ref) {
  final contactRepository = ref.read(contactRepositoryProvider);
  final userRepository = ref.read(userRepositoryProvider);
  return SearchContactController(
    contactRepository: contactRepository,
    userRepository: userRepository,
  );
});

class SearchContactController extends StateNotifier<SearchContactState> {
  final ContactRepository contactRepository;
  final UserRepository userRepository;

  SearchContactController({
    required this.contactRepository,
    required this.userRepository,
  }) : super(const SearchContactState());

  Future<void> addContactForUser({
    required String contactUid,
    required String contactName,
  }) async {
    try {
      final userMap = await userRepository.getUserDataFromDB();
      if (userMap != null) {
        final userModel = UserModel.fromMap(userMap);
        if (contactUid == userModel.uid) {
          AppNavigator.showMessage(
            "You can not add yourself as a contact.",
            type: SnackbarType.info,
          );
          return;
        } else if (userModel.contactIds.contains(contactUid)) {
          AppNavigator.showMessage(
            "You have already added this contact.",
            type: SnackbarType.info,
          );
          return;
        }
      }

      await AppNavigator.showLoading(
        task: userRepository.addContactForUserToDB(contactUid: contactUid),
        onFinish: () {
          AppNavigator.pop(true);
          AppNavigator.showMessage(
            "Added \"$contactName\" to your contact list.",
            type: SnackbarType.success,
          );
        },
        onFailed: () {
          AppNavigator.showMessage(
            "Something went wrong! Please try again.",
            type: SnackbarType.error,
          );
        },
      );
    } catch (e) {
      logger.e(e.toString());
    }
  }

  void clearSearchField() {
    state = state.copyWith(
      status: SearchContactStatus.initial,
      contactList: [],
    );
  }

  Future<void> globalContactSearchByKeyword({
    required String keyword,
  }) async {
    try {
      state = state.copyWith(status: SearchContactStatus.loading);

      final maps = await contactRepository.getContactsByKeyword(keyword: keyword);
      final contacts = maps.map((e) => UserModel.fromMap(e)).toList();

      state = state.copyWith(
        status: SearchContactStatus.success,
        contactList: contacts,
      );
    } catch (e) {
      logger.e(e.toString());
      state = state.copyWith(
        status: SearchContactStatus.error,
        contactList: [],
      );
    }
  }
}
