import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/utils/navigator.dart';
import 'package:telechat/core/config/app_log.dart';
import 'package:telechat/features/call/models/call_model.dart';
import 'package:telechat/features/call/pages/call_page.dart';
import 'package:telechat/features/call/repository/call_repository.dart';
import 'package:telechat/features/chat/controllers/chat_controller.dart';
import 'package:telechat/features/chat/controllers/chat_member_controller.dart';
import 'package:telechat/features/group/controllers/group_controller.dart';
import 'package:telechat/shared/controllers/user_controller.dart';
import 'package:uuid/uuid.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.read(callRepositoryProvider);
  return CallController(
    callRepository: callRepository,
    auth: FirebaseAuth.instance,
    ref: ref,
  );
});

class CallController {
  final CallRepository callRepository;
  final FirebaseAuth auth;
  final ProviderRef ref;

  const CallController({
    required this.callRepository,
    required this.auth,
    required this.ref,
  });

  Stream<CallModel?> get getCallAsStream {
    return callRepository.getCallAsStream.map((map) {
      return map != null ? CallModel.fromMap(map) : null;
    });
  }

  Future<void> endCall({
    required String callerId,
    required String chatId,
    required List<String> memberIds,
    required int timeCalledInSec,
    required bool isGroupCall,
  }) async {
    await callRepository.endCall(callerId: callerId, memberIds: memberIds);

    if (auth.currentUser!.uid == callerId) {
      if (isGroupCall) {
        await ref.read(groupControllerProvider).sendMessageAsCallInGroup(
              groupId: chatId,
              message: timeCalledInSec.toString(),
            );
      } else {
        await ref.read(chatControllerProvider).sendMessageAsCall(
              chatId: chatId,
              message: timeCalledInSec.toString(),
            );
      }
    }

    AppNavigator.pop();
  }

  Future<void> makeCall({
    required String chatId,
    bool isGroupCall = false,
  }) async {
    try {
      final userModel = await ref.read(userControllerProvider).getUserData();
      if (userModel == null) return;

      final callId = const Uuid().v1();
      final members = ref.read(chatMemberControllerProvider).members;
      final memberIds = members.map((e) => e.uid).toList();

      CallModel callerModel = CallModel(
        callId: callId,
        chatId: chatId,
        callerId: userModel.uid,
        callerName: userModel.name,
        callerAvatar: userModel.profileImage,
        receiverIds: memberIds,
        isGroup: isGroupCall,
        hasDialled: true,
      );

      if (isGroupCall) {
        final groupModel = await ref.read(groupControllerProvider).getGroupInfoById(chatId);
        if (groupModel != null) {
          callerModel = callerModel.copyWith(
            callerName: groupModel.groupName,
            callerAvatar: groupModel.groupAvatar,
          );
        }
      }

      final result = await callRepository.makeCall(
        callerModel: callerModel,
        memberIds: memberIds,
      );
      if (result) {
        AppNavigator.pushNamed(CallPage.route, arguments: {
          "channelId": callerModel.callId,
          "callModel": callerModel,
          "isGroup": false,
        });
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
