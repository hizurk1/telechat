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

  Future<void> updateChatMessageAsSeen({
    required String receiverId,
    required String messageId,
  }) async {
    try {
      final Map<String, bool> updatedMap = {
        "isSeen": true,
      };
      await Future.wait([
        // For sender
        database
            .collection(Collections.users)
            .doc(auth.currentUser?.uid)
            .collection(Collections.chats)
            .doc(receiverId)
            .collection(Collections.messages)
            .doc(messageId)
            .update(updatedMap),
        // For receiver
        database
            .collection(Collections.users)
            .doc(receiverId)
            .collection(Collections.chats)
            .doc(auth.currentUser?.uid)
            .collection(Collections.messages)
            .doc(messageId)
            .update(updatedMap),
      ]);
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> sendMessageAsGIF({
    required String gifUrl,
    required UserModel receiverModel,
    required UserModel senderModel,
    required MessageReply? messageReply,
  }) async {
    try {
      final timeSent = DateTime.now();

      //! /users/{senderId:receiverId}/chats/{receiverId:senderId}/data
      await _saveDataToContactsSubCollection(
        senderModel: senderModel,
        receiverModel: receiverModel,
        timeSent: timeSent,
        lastMessage: MessageEnum.gif.message,
      );

      //! /users/{senderId:receiverId}/chats/{receiver:sender}/messages/{messageId}/data
      await _saveMessageToMessagesSubCollection(
        senderId: senderModel.uid,
        receiverId: receiverModel.uid,
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

  Future<void> sendMessageAsMediaFile({
    required MessageEnum messageType,
    required UserModel receiverModel,
    required UserModel senderModel,
    required File file,
    required MessageReply? messageReply,
    String? caption,
  }) async {
    try {
      final timeSent = DateTime.now();
      final messageId = const Uuid().v1();

      final imageUrl = await ref.read(cloudStorageServiceProvider).storeFileToStorage(
            path: "chats/${messageType.name}/${senderModel.uid}/${receiverModel.uid}/$messageId",
            file: file,
          );

      if (imageUrl != null) {
        await _saveDataToContactsSubCollection(
          senderModel: senderModel,
          receiverModel: receiverModel,
          timeSent: timeSent,
          lastMessage: messageType.message,
        );

        final message = caption != null ? "$imageUrl${AppConst.captionSpliter}$caption" : imageUrl;
        await _saveMessageToMessagesSubCollection(
          senderId: senderModel.uid,
          receiverId: receiverModel.uid,
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

  Stream<List<Map<String, dynamic>>> getListOfChatMessages({
    required String contactId,
  }) {
    return database
        .collection(Collections.users)
        .doc(auth.currentUser?.uid)
        .collection(Collections.chats)
        .doc(contactId)
        .collection(Collections.messages)
        .orderBy("timeSent", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
        );
  }

  Stream<List<Map<String, dynamic>>> getListOfChatContacts() {
    return database
        .collection(Collections.users)
        .doc(auth.currentUser?.uid)
        .collection(Collections.chats)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
        );
  }

  Future<void> sendMessageAsText({
    required String textMessage,
    required UserModel receiverModel,
    required UserModel senderModel,
    required MessageReply? messageReply,
  }) async {
    try {
      final timeSent = DateTime.now();

      //! /users/{senderId:receiverId}/chats/{receiverId:senderId}/data
      await _saveDataToContactsSubCollection(
        senderModel: senderModel,
        receiverModel: receiverModel,
        timeSent: timeSent,
        lastMessage: textMessage,
      );

      //! /users/{senderId:receiverId}/chats/{receiver:sender}/messages/{messageId}/data
      await _saveMessageToMessagesSubCollection(
        senderId: senderModel.uid,
        receiverId: receiverModel.uid,
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

  /*
    When sending a message, it's store the message's data in 2 sides: sender and receiver.
  */

  /// This will be shown on the home screen
  Future<void> _saveDataToContactsSubCollection({
    required UserModel senderModel,
    required UserModel receiverModel,
    required DateTime timeSent,
    required String lastMessage,
  }) async {
    try {
      //* Store chat contact message data for `Sender` user.
      final senderChatContact = ChatContactModel(
        contactId: receiverModel.uid,
        name: receiverModel.name,
        profileImg: receiverModel.profileImage,
        timeSent: timeSent,
        lastMessage: lastMessage,
      );

      //* Store chat contact message data for `Receiver` user.
      final receiverChatContact = ChatContactModel(
        contactId: senderModel.uid,
        name: senderModel.name,
        profileImg: senderModel.profileImage,
        timeSent: timeSent,
        lastMessage: lastMessage,
      );

      await Future.wait([
        // For sender
        database
            .collection(Collections.users)
            .doc(senderModel.uid)
            .collection(Collections.chats)
            .doc(receiverModel.uid)
            .set(senderChatContact.toMap()),
        // For receiver
        database
            .collection(Collections.users)
            .doc(receiverModel.uid)
            .collection(Collections.chats)
            .doc(senderModel.uid)
            .set(receiverChatContact.toMap()),
      ]);
    } catch (e) {
      logger.e(e.toString());
    }
  }

  /// This will be shown on chat board screen
  Future<void> _saveMessageToMessagesSubCollection({
    required String senderId,
    required String receiverId,
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
        receiverId: receiverId,
        textMessage: message,
        timeSent: timeSent,
        messageType: messageType,
        isSeen: false,
        username: username,
        messageReply: messageReply,
      );

      await Future.wait([
        // For sender
        database
            .collection(Collections.users)
            .doc(senderId)
            .collection(Collections.chats)
            .doc(receiverId)
            .collection(Collections.messages)
            .doc(messageId)
            .set(messageModel.toMap()),
        // For receiver
        database
            .collection(Collections.users)
            .doc(receiverId)
            .collection(Collections.chats)
            .doc(senderId)
            .collection(Collections.messages)
            .doc(messageId)
            .set(messageModel.toMap()),
      ]);
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
