import 'dart:io' show File;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/utils/navigator.dart';
import 'package:telechat/core/config/app_log.dart';
import 'package:telechat/core/error_handler/error.dart';
import 'package:telechat/core/extensions/string.dart';
import 'package:telechat/features/chat/models/chat_message_model.dart';
import 'package:telechat/features/chat/providers/message_reply_provider.dart';
import 'package:telechat/features/group/models/group_model.dart';
import 'package:telechat/features/group/repository/group_repository.dart';
import 'package:telechat/shared/controllers/user_controller.dart';
import 'package:telechat/shared/enums/message_enum.dart';
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

  void cancelReplyMessage() {
    ref.read(messageReplyProvider.notifier).update((_) => null);
  }

  Stream<List<GroupModel>> getListOfGroupChats() {
    return groupRepository.getListOfGroupChats().map((listOfMaps) {
      return listOfMaps.map((map) => GroupModel.fromMap(map)).toList();
    });
  }

  Stream<List<ChatMessageModel>> getListOfGroupChatMessages({
    required String groupId,
  }) {
    return groupRepository.getListOfGroupChatMessages(groupId: groupId).map((listOfMaps) {
      return listOfMaps.map((map) => ChatMessageModel.fromMap(map)).toList();
    });
  }

  Stream<GroupModel?> getGroupInfoByIdAsStream(String groupId) {
    return groupRepository.getGroupInfoByIdAsStream(groupId).map((map) {
      return map != null ? GroupModel.fromMap(map) : null;
    });
  }

  Future<GroupModel?> getGroupInfoById(String groupId) async {
    try {
      final map = await groupRepository.getGroupInfoById(groupId);
      if (map != null) {
        return GroupModel.fromMap(map);
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return null;
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

  //* Group

  Future<void> sendMessageAsTextInGroup({
    required String groupId,
    required String textMessage,
  }) async {
    try {
      final senderModel = await ref.read(userControllerProvider).getUserData();
      if (senderModel == null) return;

      // Send message
      final messageReply = ref.read(messageReplyProvider);
      cancelReplyMessage();
      await groupRepository.sendMessageAsTextInGroup(
        groupId: groupId,
        textMessage: textMessage,
        senderModel: senderModel,
        messageReply: messageReply,
      );
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> sendMessageAsMediaFileInGroup({
    required String groupId,
    required MessageEnum messageType,
    required File file,
    String? caption,
  }) async {
    try {
      final senderModel = await ref.read(userControllerProvider).getUserData();
      if (senderModel == null) return;

      // Send message
      final messageReply = ref.read(messageReplyProvider);
      cancelReplyMessage();
      await groupRepository.sendMessageAsMediaFileInGroup(
        groupId: groupId,
        senderModel: senderModel,
        messageType: messageType,
        file: file,
        caption: caption,
        messageReply: messageReply,
      );
    } on DatabaseError catch (e) {
      logger.e(e.message);
      AppNavigator.showMessage(e.message, type: SnackbarType.error);
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> sendMessageAsGIFInGroup({
    required String groupId,
    required String? gifUrl,
  }) async {
    if (gifUrl.isNullOrEmpty) return;

    try {
      final senderModel = await ref.read(userControllerProvider).getUserData();
      if (senderModel == null) return;

      // Send message
      final gifId = gifUrl!.split('-').last;
      final url = "https://i.giphy.com/media/$gifId/200.gif";
      final messageReply = ref.read(messageReplyProvider);
      cancelReplyMessage();
      await groupRepository.sendMessageAsGIFInGroup(
        groupId: groupId,
        gifUrl: url,
        senderModel: senderModel,
        messageReply: messageReply,
      );
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> sendMessageAsCallInGroup({
    required String groupId,
    required String message,
  }) async {
    try {
      final senderModel = await ref.read(userControllerProvider).getUserData();
      if (senderModel == null) return;

      // Send message
      final messageReply = ref.read(messageReplyProvider);
      cancelReplyMessage();
      await groupRepository.sendMessageAsCallInGroup(
        groupId: groupId,
        message: message,
        senderModel: senderModel,
        messageReply: messageReply,
      );
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
