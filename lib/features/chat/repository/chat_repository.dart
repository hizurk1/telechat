import 'dart:io' show File;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/constants/app_const.dart';
import 'package:telechat/app/constants/firebase_const.dart';
import 'package:telechat/core/config/app_log.dart';
import 'package:telechat/core/error_handler/error.dart';
import 'package:telechat/features/chat/models/chat_contact_model.dart';
import 'package:telechat/features/chat/models/chat_message_model.dart';
import 'package:telechat/features/chat/providers/message_reply_provider.dart';
import 'package:telechat/shared/enums/message_enum.dart';
import 'package:telechat/shared/models/user_model.dart';
import 'package:telechat/shared/repositories/cloud_storage.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(
    database: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  );
});

class ChatRepository {
  final FirebaseFirestore database;
  final FirebaseAuth auth;
  final ProviderRef ref;

  const ChatRepository({
    required this.database,
    required this.auth,
    required this.ref,
  });

  Future<ChatContactModel?> createChat({
    required String contactId,
  }) async {
    try {
      final chatId = const Uuid().v1();

      final chatModel = ChatContactModel(
        chatId: chatId,
        memberIds: [auth.currentUser!.uid, contactId],
        createdUserId: auth.currentUser!.uid,
        lastSenderId: '',
        timeSent: DateTime.now(),
        lastMessage: '',
      );

      await database.collection(Collections.chats).doc(chatId).set(chatModel.toMap());
      return chatModel;
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }

  Future<void> updateChatMessageAsSeen({
    required String chatId,
    required String messageId,
  }) async {
    try {
      final Map<String, bool> updatedMap = {
        "isSeen": true,
      };
      await database
          .collection(Collections.chats)
          .doc(chatId)
          .collection(Collections.messages)
          .doc(messageId)
          .update(updatedMap);
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> sendMessageAsText({
    required String chatId,
    required UserModel senderModel,
    required String textMessage,
    required MessageReply? messageReply,
  }) async {
    try {
      final timeSent = DateTime.now();

      await _updateLastMessageInChat(
        chatId: chatId,
        timeSent: timeSent,
        lastMessage: textMessage,
      );

      await _saveMessageToMessagesSubCollection(
        chatId: chatId,
        senderModel: senderModel,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        message: textMessage,
        messageReply: messageReply,
      );
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> sendMessageAsGIF({
    required String chatId,
    required String gifUrl,
    required UserModel senderModel,
    required MessageReply? messageReply,
  }) async {
    try {
      final timeSent = DateTime.now();

      await _updateLastMessageInChat(
        chatId: chatId,
        timeSent: timeSent,
        lastMessage: MessageEnum.gif.message,
      );

      await _saveMessageToMessagesSubCollection(
        chatId: chatId,
        senderModel: senderModel,
        timeSent: timeSent,
        messageType: MessageEnum.gif,
        message: gifUrl,
        messageReply: messageReply,
      );
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> sendMessageAsMediaFile({
    required String chatId,
    required UserModel senderModel,
    required MessageEnum messageType,
    required File file,
    required MessageReply? messageReply,
    String? caption,
  }) async {
    try {
      final timeSent = DateTime.now();
      final messageId = const Uuid().v1();

      final imageUrl = await ref.read(cloudStorageServiceProvider).storeFileToStorage(
            path: "chats/$chatId/$messageId",
            file: file,
          );

      if (imageUrl != null) {
        await _updateLastMessageInChat(
          chatId: chatId,
          timeSent: timeSent,
          lastMessage: messageType.message,
        );

        final message = caption != null ? "$imageUrl${AppConst.captionSpliter}$caption" : imageUrl;
        await _saveMessageToMessagesSubCollection(
          chatId: chatId,
          senderModel: senderModel,
          timeSent: timeSent,
          message: message,
          messageType: messageType,
          messageReply: messageReply,
        );
      } else {
        throw const DatabaseError(message: "Failed to upload your photo!");
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Stream<List<Map<String, dynamic>>> getListOfChatMessages({
    required String chatId,
  }) {
    return database
        .collection(Collections.chats)
        .doc(chatId)
        .collection(Collections.messages)
        .orderBy("timeSent", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
        );
  }

  Stream<List<Map<String, dynamic>>> getListOfChatContacts() {
    return database
        .collection(Collections.chats)
        .where("memberIds", arrayContains: auth.currentUser!.uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
        );
  }

  /// This will be shown on the home screen
  Future<void> _updateLastMessageInChat({
    required String chatId,
    required DateTime timeSent,
    required String lastMessage,
  }) async {
    try {
      await database.collection(Collections.chats).doc(chatId).update({
        "lastSenderId": auth.currentUser!.uid,
        "timeSent": timeSent.millisecondsSinceEpoch,
        "lastMessage": lastMessage,
      });
    } catch (e) {
      logger.e(e.toString());
    }
  }

  /// This will be shown on chat board screen
  Future<void> _saveMessageToMessagesSubCollection({
    required String chatId,
    required UserModel senderModel,
    required DateTime timeSent,
    required String message,
    required MessageEnum messageType,
    required MessageReply? messageReply,
  }) async {
    try {
      final messageId = const Uuid().v1();
      final messageModel = ChatMessageModel(
        messageId: messageId,
        senderId: senderModel.uid,
        senderName: senderModel.name,
        textMessage: message,
        timeSent: timeSent,
        messageType: messageType,
        isSeen: false,
        messageReply: messageReply,
      );

      await database
          .collection(Collections.chats)
          .doc(chatId)
          .collection(Collections.messages)
          .doc(messageId)
          .set(messageModel.toMap());
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
