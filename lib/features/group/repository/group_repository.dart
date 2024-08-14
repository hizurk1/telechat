import 'dart:io' show File;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/constants/app_const.dart';
import 'package:telechat/app/constants/firebase_const.dart';
import 'package:telechat/core/config/app_log.dart';
import 'package:telechat/core/error_handler/error.dart';
import 'package:telechat/features/chat/models/chat_message_model.dart';
import 'package:telechat/features/chat/providers/message_reply_provider.dart';
import 'package:telechat/features/group/models/group_model.dart';
import 'package:telechat/shared/enums/message_enum.dart';
import 'package:telechat/shared/models/user_model.dart';
import 'package:telechat/shared/repositories/cloud_storage.dart';
import 'package:uuid/uuid.dart';

final groupRepositoryProvider = Provider((ref) {
  return GroupRepository(
    database: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  );
});

class GroupRepository {
  final FirebaseFirestore database;
  final FirebaseAuth auth;
  final ProviderRef ref;

  const GroupRepository({
    required this.database,
    required this.auth,
    required this.ref,
  });

  Stream<List<Map<String, dynamic>>> getListOfGroupChatsAsStream() {
    return database
        .collection(Collections.groups)
        .where("memberIds", arrayContains: auth.currentUser!.uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
        );
  }

  Future<List<Map<String, dynamic>>> getListOfGroupChats() async {
    try {
      final snapshot = await database
          .collection(Collections.groups)
          .where("memberIds", arrayContains: auth.currentUser!.uid)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      logger.e(e.toString());
      return [];
    }
  }

  Stream<Map<String, dynamic>?> getGroupInfoByIdAsStream(String groupId) {
    return database
        .collection(Collections.groups)
        .doc(groupId)
        .snapshots()
        .map((doc) => doc.data());
  }

  Future<Map<String, dynamic>?> getGroupInfoById(String groupId) async {
    try {
      final snapshot = await database.collection(Collections.groups).doc(groupId).get();
      if (snapshot.exists) {
        return snapshot.data();
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return null;
  }

  Future<void> createNewGroup({
    required String groupName,
    required File groupAvatar,
    required List<UserModel> groupMembers,
  }) async {
    try {
      final groupId = const Uuid().v1();

      final imageUrl = await ref.read(cloudStorageServiceProvider).storeFileToStorage(
            path: "groups/$groupId",
            file: groupAvatar,
          );

      if (imageUrl != null) {
        final memberIds = groupMembers.map((e) => e.uid).toList();
        final groupModel = GroupModel(
          groupId: groupId,
          groupName: groupName,
          groupAvatar: imageUrl,
          lastMessage: '',
          lastSenderId: '',
          lastSenderName: '',
          timeSent: DateTime.now(),
          memberIds: [auth.currentUser!.uid, ...memberIds],
        );

        await database.collection(Collections.groups).doc(groupId).set(groupModel.toMap());
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }

  //* Send message

  Stream<List<Map<String, dynamic>>> getListOfGroupChatMessages({
    required String groupId,
  }) {
    return database
        .collection(Collections.groups)
        .doc(groupId)
        .collection(Collections.messages)
        .orderBy("timeSent", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
        );
  }

  Future<void> sendMessageAsTextInGroup({
    required String groupId,
    required String textMessage,
    required UserModel senderModel,
    required MessageReply? messageReply,
  }) async {
    try {
      final timeSent = DateTime.now();

      //! /groups/{groupId}/data
      await _saveLastMessageInGroup(
        groupId: groupId,
        senderModel: senderModel,
        timeSent: timeSent,
        textMessage: textMessage,
      );

      //! /groups/{groupId}/messages/{messageId}/data
      await _saveMessageToMessagesSubCollectionInGroup(
        groupId: groupId,
        senderId: senderModel.uid,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        message: textMessage,
        username: senderModel.name,
        messageReply: messageReply,
      );
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> sendMessageAsMediaFileInGroup({
    required String groupId,
    required MessageEnum messageType,
    required UserModel senderModel,
    required File file,
    required MessageReply? messageReply,
    String? caption,
  }) async {
    try {
      final timeSent = DateTime.now();
      final messageId = const Uuid().v1();

      final imageUrl = await ref.read(cloudStorageServiceProvider).storeFileToStorage(
            path: "groupChats/$groupId/$messageId",
            file: file,
          );

      if (imageUrl != null) {
        //! /groups/{groupId}/data
        await _saveLastMessageInGroup(
          groupId: groupId,
          textMessage: messageType.message,
          senderModel: senderModel,
          timeSent: timeSent,
        );

        final message = caption != null ? "$imageUrl${AppConst.captionSpliter}$caption" : imageUrl;
        await _saveMessageToMessagesSubCollectionInGroup(
          groupId: groupId,
          senderId: senderModel.uid,
          timeSent: timeSent,
          message: message,
          messageType: messageType,
          username: senderModel.name,
          messageReply: messageReply,
        );
      } else {
        throw const DatabaseError(message: "Failed to upload your photo!");
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> sendMessageAsGIFInGroup({
    required String groupId,
    required UserModel senderModel,
    required String gifUrl,
    required MessageReply? messageReply,
  }) async {
    try {
      final timeSent = DateTime.now();

      //! /groups/{groupId}/data
      await _saveLastMessageInGroup(
        groupId: groupId,
        senderModel: senderModel,
        timeSent: timeSent,
        textMessage: MessageEnum.gif.message,
      );

      //! /groups/{groupId}/messages/{messageId}/data
      await _saveMessageToMessagesSubCollectionInGroup(
        groupId: groupId,
        senderId: senderModel.uid,
        timeSent: timeSent,
        messageType: MessageEnum.gif,
        message: gifUrl,
        username: senderModel.name,
        messageReply: messageReply,
      );
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> sendMessageAsCallInGroup({
    required String groupId,
    required String message,
    required UserModel senderModel,
    required MessageReply? messageReply,
  }) async {
    try {
      final timeSent = DateTime.now();

      //! /groups/{groupId}/data
      await _saveLastMessageInGroup(
        groupId: groupId,
        senderModel: senderModel,
        timeSent: timeSent,
        textMessage: MessageEnum.call.message,
      );

      //! /groups/{groupId}/messages/{messageId}/data
      await _saveMessageToMessagesSubCollectionInGroup(
        groupId: groupId,
        senderId: senderModel.uid,
        timeSent: timeSent,
        messageType: MessageEnum.call,
        message: message,
        username: senderModel.name,
        messageReply: messageReply,
      );
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> _saveLastMessageInGroup({
    required String groupId,
    required String textMessage,
    required UserModel senderModel,
    required DateTime timeSent,
  }) async {
    try {
      await database.collection(Collections.groups).doc(groupId).update({
        "lastMessage": textMessage,
        "timeSent": timeSent.millisecondsSinceEpoch,
        "lastSenderId": senderModel.uid,
        "lastSenderName": senderModel.name,
      });
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> _saveMessageToMessagesSubCollectionInGroup({
    required String groupId,
    required String senderId,
    required DateTime timeSent,
    required String message,
    required MessageEnum messageType,
    required String username,
    required MessageReply? messageReply,
  }) async {
    try {
      final messageId = const Uuid().v1();
      final messageModel = ChatMessageModel(
        messageId: messageId,
        senderId: senderId,
        textMessage: message,
        timeSent: timeSent,
        messageType: messageType,
        isSeen: false,
        senderName: username,
        messageReply: messageReply,
      );

      await database
          .collection(Collections.groups)
          .doc(groupId)
          .collection(Collections.messages)
          .doc(messageId)
          .set(messageModel.toMap());
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
