import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/utils/util_function.dart';
import 'package:telechat/core/config/app_log.dart';
import 'package:telechat/features/contact/controllers/contact_controller.dart';
import 'package:telechat/features/group/controllers/new_group_state.dart';
import 'package:telechat/shared/models/user_model.dart';

final newGroupControllerProvider =
    StateNotifierProvider.autoDispose<NewGroupController, NewGroupState>((ref) {
  final contactController = ref.read(contactControllerProvider.notifier);
  return NewGroupController(contactController);
});

class NewGroupController extends StateNotifier<NewGroupState> {
  final ContactController contactController;
  NewGroupController(this.contactController) : super(const NewGroupState());

  void onChangedGroupName(String name) {
    state = state.copyWith(groupName: name);
  }

  Future<void> onSelectImage() async {
    final pickedImg = await UtilsFunction.pickImageFromGallery();
    if (pickedImg != null) {
      state = state.copyWith(image: pickedImg);
    }
  }

  void onSelectContact(UserModel contact) {
    final selectedContacts = List<UserModel>.from(state.selectedContacts);

    if (state.selectedContacts.contains(contact)) {
      state = state.copyWith(
        selectedContacts: selectedContacts..remove(contact),
      );
    } else {
      state = state.copyWith(
        selectedContacts: selectedContacts..add(contact),
      );
    }
  }

  void onSearchContacts(String keyword) {
    if (keyword.isEmpty) {
      state = state.copyWith(
        searchContacts: state.contacts,
      );
      return;
    }

    final filteredList = state.contacts
        .where(
          (e) => e.name.toLowerCase().contains(keyword.toLowerCase()),
        )
        .toList();
    state = state.copyWith(
      searchContacts: filteredList,
    );
  }

  Future<void> fetchContacts() async {
    try {
      state = state.copyWith(status: NewGroupStatus.loading);
      final contacts = await contactController.getContacts();
      state = state.copyWith(
        status: NewGroupStatus.success,
        contacts: contacts,
        searchContacts: contacts,
      );
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
