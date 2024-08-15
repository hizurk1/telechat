import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/configs/remote_config.dart';
import 'package:telechat/app/pages/home/home_page.dart';
import 'package:telechat/app/utils/navigator.dart';
import 'package:telechat/core/config/app_log.dart';
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
    final userData = await userRepository.getUserDataFromDB();

    UserModel? userModel;
    if (userData != null) {
      userModel = UserModel.fromMap(userData);
    }
    return userModel;
  }

  //* Get user data as stream
  Stream<UserModel?> getUserDataAsStream() {
    return userRepository.getUserDataAsStreamFromDB().map(
      (data) {
        return data != null ? UserModel.fromMap(data) : null;
      },
    );
  }

  //* Get user data by id
  Future<UserModel?> getUserDataById(String uid) async {
    final userData = await userRepository.getUserDataByIdFromDB(uid);

    UserModel? userModel;
    if (userData != null) {
      userModel = UserModel.fromMap(userData);
    }
    return userModel;
  }

  //* Get user datas by ids
  Future<List<UserModel>?> getListOfUserDataByIds(List<String> userIds) async {
    final listOfData = await userRepository.getListOfUserDataByIds(userIds);
    return listOfData?.map((e) => UserModel.fromMap(e)).toList();
  }

  //* Save user info

  Future<void> saveUserData({
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
        dateOfBirth: null,
        createdDate: DateTime.now(),
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
        (err) => logger.e(err.message),
        (_) {
          logger.i("saveUserData: ${userModel.toString()}");
          AppNavigator.pushNamedAndRemoveUntil(HomePage.route);
        },
      );
    } catch (e) {
      logger.e(e.toString());
    }
  }

  //* Get user data as stream
  Stream<UserModel?> getUserContactAsStream(String contactId) {
    return userRepository.getUserContactAsStreamFromDB(contactId).map(
      (data) {
        return data != null ? UserModel.fromMap(data) : null;
      },
    );
  }

  //* Update user online status
  Future<void> updateUserOnlineStatus(bool isOnline) async {
    try {
      await userRepository.updateUserOnlineStatus(isOnline);
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
