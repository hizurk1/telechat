import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/utils/navigator.dart';
import 'package:telechat/core/config/app_log.dart';
import 'package:telechat/core/extensions/string.dart';
import 'package:telechat/features/profile/repository/profile_repository.dart';
import 'package:telechat/shared/repositories/cloud_storage.dart';

final profileControllerProvider = Provider((ref) {
  final storage = ref.read(cloudStorageServiceProvider);
  final profileRepository = ref.read(profileReporitoryProvider);
  return ProfileController(
    profileRepository: profileRepository,
    auth: FirebaseAuth.instance,
    storage: storage,
  );
});

class ProfileController {
  final ProfileRepository profileRepository;
  final FirebaseAuth auth;
  final CloudStorageService storage;

  ProfileController({
    required this.profileRepository,
    required this.auth,
    required this.storage,
  });

  Future<void> updateUserProfile({
    String? name,
    String? dateOfBirth,
    File? profileImg,
  }) async {
    if (name != null && name.isEmpty) {
      AppNavigator.showMessage(
        "Name can not be empty!",
        type: SnackbarType.error,
      );
      return;
    }

    try {
      String? imageUrl;
      if (profileImg != null) {
        imageUrl = await storage.storeUserProfileImage(
          uid: auth.currentUser!.uid,
          file: profileImg,
        );
      }

      final updateMap = {
        if (imageUrl != null) "profileImage": imageUrl,
        if (dateOfBirth.isNotNullOrEmpty) "dateOfBirth": dateOfBirth!.toDate.millisecondsSinceEpoch,
        if (name != null) "name": name,
      };

      if (updateMap.keys.isNotEmpty) {
        await profileRepository.updateUserProfile(map: updateMap);
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
