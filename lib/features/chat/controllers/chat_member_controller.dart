import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/utils/navigator.dart';
import 'package:telechat/core/config/app_log.dart';
import 'package:telechat/features/chat/controllers/chat_member_state.dart';
import 'package:telechat/shared/controllers/user_controller.dart';

final chatMemberControllerProvider =
    StateNotifierProvider.autoDispose<ChatMemberController, ChatMemberState>((ref) {
  final userController = ref.read(userControllerProvider);
  return ChatMemberController(userController);
});

class ChatMemberController extends StateNotifier<ChatMemberState> {
  final UserController userController;
  ChatMemberController(this.userController) : super(const ChatMemberState());

  Future<void> fetchMemberInfoOfChat(List<String> memberIds) async {
    try {
      state = state.copyWith(status: ChatMemberStatus.loading);

      final chatMembers = await userController.getListOfUserDataByIds(memberIds);
      if (chatMembers != null) {
        state = state.copyWith(
          status: ChatMemberStatus.success,
          members: chatMembers,
        );
        return;
      }
    } catch (e) {
      logger.e(e.toString());
    }
    state = state.copyWith(status: ChatMemberStatus.error);
    AppNavigator.showMessage(
      "Failed to get chat members info",
      type: SnackbarType.error,
    );
  }
}
