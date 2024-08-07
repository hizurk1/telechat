import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/core/config/app_log.dart';

final cloudStorageServiceProvider = Provider((ref) {
  return CloudStorageService(storage: FirebaseStorage.instance);
});

class CloudStorageService {
  final FirebaseStorage storage;

  CloudStorageService({required this.storage});

  Future<String?> storeUserProfileImage({
    required String uid,
    required File file,
  }) async {
    final ext = file.path.split('.').last;
    return await storeFileToStorage(
      path: "profileImage/$uid",
      file: file,
      metadata: SettableMetadata(contentType: "image/$ext"),
    );
  }

  Future<String?> storeFileToStorage({
    required String path,
    required File file,
    SettableMetadata? metadata,
  }) async {
    try {
      final uploadTask = storage.ref().child(path).putFile(
            file,
            metadata,
          );
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }
}
