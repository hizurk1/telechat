import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/core/config/app_log.dart';
import 'package:telechat/features/contact/controllers/contact_state.dart';
import 'package:telechat/features/contact/repository/contact_repository.dart';
import 'package:telechat/shared/models/user_model.dart';
import 'package:telechat/shared/repositories/user_repository.dart';

final contactControllerProvider =
    StateNotifierProvider.autoDispose<ContactController, ContactState>((ref) {
  final contactRepository = ref.read(contactRepositoryProvider);
  final userRepository = ref.read(userRepositoryProvider);
  return ContactController(
    contactRepository: contactRepository,
    userRepository: userRepository,
  );
});

class ContactController extends StateNotifier<ContactState> {
  final ContactRepository contactRepository;
  final UserRepository userRepository;

  ContactController({
    required this.contactRepository,
    required this.userRepository,
  }) : super(const ContactState());

  void searchForYourContactsByNameOrPhone({required String keyword}) {
    if (state.contactList.isEmpty) {
      state = state.copyWith(searchList: []);
      return;
    }

    if (keyword.isNotEmpty) {
      final filteredContacts = state.contactList.where((contact) {
        return contact.name.toLowerCase().contains(keyword.toLowerCase()) ||
            contact.phoneNumber.contains(keyword);
      }).toList();

      state = state.copyWith(searchList: filteredContacts);
    } else {
      state = state.copyWith(searchList: state.contactList);
    }
  }

  Future<void> fetchContacts() async {
    try {
      state = state.copyWith(status: ContactStatus.loading);
      final userMap = await userRepository.getUserDataFromDB();
      if (userMap != null) {
        final userModel = UserModel.fromMap(userMap);

        if (userModel.contactIds.isNotEmpty) {
          final contactMaps =
              await contactRepository.getContactsByIds(contactIds: userModel.contactIds);
          final contactList = contactMaps.map((map) => UserModel.fromMap(map)).toList();

          state = state.copyWith(
            status: ContactStatus.success,
            contactList: contactList,
            searchList: contactList,
          );
        } else {
          state = state.copyWith(
            status: ContactStatus.success,
            contactList: [],
            searchList: [],
          );
        }
        return;
      }
    } catch (e) {
      logger.e(e.toString());
    }
    state = state.copyWith(
      status: ContactStatus.error,
      contactList: [],
      searchList: [],
    );
  }

  //* Get contacts
  Future<List<UserModel>> getContacts() async {
    try {
      final userMap = await userRepository.getUserDataFromDB();
      if (userMap != null) {
        final userModel = UserModel.fromMap(userMap);

        if (userModel.contactIds.isNotEmpty) {
          final contactMaps =
              await contactRepository.getContactsByIds(contactIds: userModel.contactIds);
          final contactList = contactMaps.map((map) => UserModel.fromMap(map)).toList();
          return contactList;
        }
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return [];
  }
}
