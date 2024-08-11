import 'dart:io' show File;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/constants/firebase_const.dart';
import 'package:telechat/core/config/app_log.dart';
import 'package:telechat/features/group/models/group_model.dart';
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

  Stream<List<Map<String, dynamic>>> getListOfGroupChats() {
    return database
        .collection(Collections.groups)
        .where("memberIds", arrayContains: auth.currentUser!.uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
        );
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
          timeSent: DateTime.now(),
          memberIds: [auth.currentUser!.uid, ...memberIds],
        );

        await database.collection(Collections.groups).doc(groupId).set(groupModel.toMap());
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
