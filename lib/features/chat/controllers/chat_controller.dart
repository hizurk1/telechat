import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/core/config/app_log.dart';
import 'package:telechat/features/chat/repository/chat_repository.dart';
import 'package:telechat/shared/controllers/user_controller.dart';
import 'package:telechat/shared/models/user_model.dart';
import 'package:telechat/shared/repositories/user_repository.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.read(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  const ChatController({
    required this.chatRepository,
    required this.ref,
  });

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
}
