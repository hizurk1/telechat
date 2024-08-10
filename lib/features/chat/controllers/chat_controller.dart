import 'dart:core';
import 'dart:io' show File;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telechat/app/configs/remote_config.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/utils/navigator.dart';
import 'package:telechat/core/config/app_log.dart';
import 'package:telechat/core/error_handler/error.dart';
import 'package:telechat/core/extensions/string.dart';
import 'package:telechat/features/chat/models/chat_contact_model.dart';
import 'package:telechat/features/chat/models/chat_message_model.dart';
import 'package:telechat/features/chat/providers/message_reply_provider.dart';
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

  void cancelReplyMessage() {
    ref.read(messageReplyProvider.notifier).update((_) => null);
  }

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

  Future<(UserModel, UserModel)?> _getSenderAndReceiverModel(String receiverId) async {
    try {
      final senderModel = await ref.read(userControllerProvider).getUserData();
      if (senderModel == null) {
        logger.e("senderModel == null");
        return null;
      }

      // Get receiver data model
      final receiverUserMap =
          await ref.read(userRepositoryProvider).getUserDataByIdFromDB(receiverId);
      if (receiverUserMap == null) {
        logger.e("receiverUserMap == null");
        return null;
      }
      final receiverModel = UserModel.fromMap(receiverUserMap);

      return (senderModel, receiverModel);
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }

  Future<void> sendMessageAsText({
    required String receiverId,
    required String textMessage,
  }) async {
    try {
      final senderAndReceiver = await _getSenderAndReceiverModel(receiverId);
      if (senderAndReceiver == null) return;

      // Send message
      final messageReply = ref.read(messageReplyProvider);
      cancelReplyMessage();
      await chatRepository.sendMessageAsText(
        textMessage: textMessage,
        senderModel: senderAndReceiver.$1,
        receiverModel: senderAndReceiver.$2,
        messageReply: messageReply,
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
      final senderAndReceiver = await _getSenderAndReceiverModel(receiverId);
      if (senderAndReceiver == null) return;

      // Send message
      final messageReply = ref.read(messageReplyProvider);
      cancelReplyMessage();
      await chatRepository.sendMessageAsMediaFile(
        senderModel: senderAndReceiver.$1,
        receiverModel: senderAndReceiver.$2,
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

  Future<void> sendMessageAsGIF({
    required String receiverId,
    required String? gifUrl,
  }) async {
    if (gifUrl.isNullOrEmpty) return;

    try {
      final senderAndReceiver = await _getSenderAndReceiverModel(receiverId);
      if (senderAndReceiver == null) return;

      // Send message
      final gifId = gifUrl!.split('-').last;
      final url = "https://i.giphy.com/media/$gifId/200.gif";
      final messageReply = ref.read(messageReplyProvider);
      cancelReplyMessage();
      await chatRepository.sendMessageAsGIF(
        gifUrl: url,
        senderModel: senderAndReceiver.$1,
        receiverModel: senderAndReceiver.$2,
        messageReply: messageReply,
      );
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

  Future<File?> pickVideoFromGallery() async {
    try {
      final file = await imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: Duration(minutes: RemoteConfig.maxVideoLengthInMins),
      );
      return file != null ? File(file.path) : null;
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }

  Future<GiphyGif?> pickGIF() async {
    if (RemoteConfig.giphyApiKey.isNotEmpty) {
      try {
        final gif = await GiphyGet.getGif(
          context: AppNavigator.currentContext!,
          apiKey: RemoteConfig.giphyApiKey,
          tabColor: AppColors.primary,
          debounceTimeInMilliseconds: 350,
        );
        return gif;
      } catch (e) {
        logger.e(e.toString());
      }
    } else {
      AppNavigator.showMessage(
        "Can not connect to Giphy server!",
        type: SnackbarType.error,
      );
    }
    return null;
  }
}
