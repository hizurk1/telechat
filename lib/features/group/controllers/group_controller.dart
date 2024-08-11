import 'dart:io' show File;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/utils/navigator.dart';
import 'package:telechat/core/config/app_log.dart';
import 'package:telechat/features/group/models/group_model.dart';
import 'package:telechat/features/group/repository/group_repository.dart';
import 'package:telechat/shared/models/user_model.dart';

final groupControllerProvider = Provider((ref) {
  final groupRepository = ref.read(groupRepositoryProvider);
  return GroupController(
    groupRepository: groupRepository,
    ref: ref,
  );
});

class GroupController {
  final GroupRepository groupRepository;
  final ProviderRef ref;

  GroupController({
    required this.groupRepository,
    required this.ref,
  });

  Stream<List<GroupModel>> getListOfGroupChats() {
    return groupRepository.getListOfGroupChats().map((listOfMaps) {
      return listOfMaps.map((map) => GroupModel.fromMap(map)).toList();
    });
  }

  Future<bool> createNewGroup({
    required String groupName,
    required File? groupAvatar,
    required List<UserModel> groupMembers,
  }) async {
    if (groupName.isEmpty) {
      AppNavigator.showMessage(
        "Please enter group name",
        type: SnackbarType.error,
      );
      return false;
    }
    if (groupAvatar == null) {
      AppNavigator.showMessage(
        "Please select your group avatar",
        type: SnackbarType.error,
      );
      return false;
    }

    try {
      await groupRepository.createNewGroup(
        groupName: groupName,
        groupAvatar: groupAvatar,
        groupMembers: groupMembers,
      );
      return true;
    } catch (e) {
      logger.e(e.toString());
      return false;
    }
  }
}
