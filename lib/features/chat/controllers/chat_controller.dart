import 'dart:core';
import 'dart:io' show File;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telechat/app/utils/navigator.dart';
import 'package:telechat/core/config/app_log.dart';
import 'package:telechat/core/error_handler/error.dart';
import 'package:telechat/features/chat/models/chat_contact_model.dart';
import 'package:telechat/features/chat/models/chat_message_model.dart';
import 'package:telechat/features/chat/repository/chat_repository.dart';
import 'package:telechat/shared/controllers/user_controller.dart';
import 'package:telechat/shared/enums/message_enum.dart';
import 'package:telechat/shared/models/user_model.dart';
import 'package:telechat/shared/repositories/user_repository.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.read(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    imagePicker: ImagePicker(),
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ImagePicker imagePicker;
  final ProviderRef ref;

  const ChatController({
    required this.chatRepository,
    required this.imagePicker,
    required this.ref,
  });

  Stream<List<ChatMessageModel>> getListOfChatMessages({
    required String contactId,
  }) {
    return chatRepository.getListOfChatMessages(contactId: contactId).map((listOfMaps) {
      return listOfMaps.map((map) => ChatMessageModel.fromMap(map)).toList();
    });
  }

  Stream<List<ChatContactModel>> getListOfChatContacts() {
    return chatRepository.getListOfChatContacts().map((listOfMaps) {
      return listOfMaps.map((map) => ChatContactModel.fromMap(map)).toList();
    });
  }

  Future<void> sendMessageAsText({
    required String receiverId,
    required String textMessage,
  }) async {
    try {
      final senderModel = await ref.read(userControllerProvider).getUserData();
      if (senderModel == null) {
        logger.e("senderModel == null");
        return;
      }

      // Get receiver data model
      final receiverUserMap =
          await ref.read(userRepositoryProvider).getUserDataByIdFromDB(receiverId);
      if (receiverUserMap == null) {
        logger.e("receiverUserMap == null");
        return;
      }
      final receiverModel = UserModel.fromMap(receiverUserMap);

      // Send message
      await chatRepository.sendMessageAsText(
        textMessage: textMessage,
        receiverModel: receiverModel,
        senderModel: senderModel,
      );
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> sendMessageAsMediaFile({
    required MessageEnum messageType,
    required String receiverId,
    required File file,
    String? caption,
  }) async {
    try {
      final senderModel = await ref.read(userControllerProvider).getUserData();
      if (senderModel == null) {
        logger.e("senderModel == null");
        return;
      }

      // Get receiver data model
      final receiverUserMap =
          await ref.read(userRepositoryProvider).getUserDataByIdFromDB(receiverId);
      if (receiverUserMap == null) {
        logger.e("receiverUserMap == null");
        return;
      }
      final receiverModel = UserModel.fromMap(receiverUserMap);

      // Send message
      await chatRepository.sendMessageAsMediaFile(
        receiverModel: receiverModel,
        senderModel: senderModel,
        messageType: messageType,
        file: file,
        caption: caption,
      );
    } on DatabaseError catch (e) {
      logger.e(e.message);
      AppNavigator.showMessage(e.message, type: SnackbarType.error);
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<File?> pickImageFromGallery() async {
    try {
      final file = await imagePicker.pickImage(source: ImageSource.gallery);
      return file != null ? File(file.path) : null;
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }
}
