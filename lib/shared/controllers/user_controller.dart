import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/configs/remote_config.dart';
import 'package:telechat/app/utils/navigator.dart';
import 'package:telechat/core/config/app_log.dart';
import 'package:telechat/features/home/pages/home_page.dart';
import 'package:telechat/shared/models/user_model.dart';
import 'package:telechat/shared/repositories/cloud_storage.dart';
import 'package:telechat/shared/repositories/user_repository.dart';

final userControllerProvider = Provider((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return UserController(
    userRepository: userRepository,
    ref: ref,
  );
});

class UserController {
  final UserRepository userRepository;
  final ProviderRef ref;

  UserController({
    required this.userRepository,
    required this.ref,
  });

  User? get currentUser => userRepository.currentUser;

  //* Get user data
  Future<UserModel?> getUserData() async {
    final userData = await userRepository.getUserData();

    UserModel? userModel;
    if (userData != null) {
      userModel = UserModel.fromMap(userData);
    }
    return userModel;
  }

  //* Save user info

  Future<void> saveUserDataToDB({
    required String name,
    required File? profileImg,
  }) async {
    if (name.isEmpty) {
      AppNavigator.showMessage(
        "Please enter your name",
        type: SnackbarType.error,
      );
      return;
    }

    try {
      final uid = currentUser!.uid;
      String photoUrl = RemoteConfig.defaultUserProfilePicUrl;

      if (profileImg != null) {
        final url = await ref
            .read(cloudStorageServiceProvider)
            .storeUserProfileImage(uid: uid, file: profileImg);
        if (url != null) photoUrl = url;
      }

      final userModel = UserModel(
        uid: uid,
        name: name,
        profileImage: photoUrl,
        phoneNumber: currentUser!.phoneNumber!,
        isOnline: true,
        contactIds: const [],
        blockedIds: const [],
        groupIds: const [],
      );

      final result = await userRepository.saveUserDataToDB(
        uid: uid,
        map: userModel.toMap(),
      );
      result.fold(
        (err) => logger.e("saveUserDataToDB: ${err.message}"),
        (_) {
          logger.i("saveUserDataToDB: ${userModel.toString()}");
          AppNavigator.pushNamedAndRemoveUntil(HomePage.route);
        },
      );
    } catch (e) {
      logger.e("saveUserDataToDB: ${e.toString()}");
    }
  }
}
