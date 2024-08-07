import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/constants/firebase_const.dart';
import 'package:telechat/core/config/app_log.dart';
import 'package:telechat/features/chat/models/chat_contact_model.dart';
import 'package:telechat/features/chat/models/chat_message_model.dart';
import 'package:telechat/shared/enums/message_enum.dart';
import 'package:telechat/shared/models/user_model.dart';
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
