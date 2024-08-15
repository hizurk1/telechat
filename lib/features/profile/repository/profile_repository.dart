import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/constants/firebase_const.dart';
import 'package:telechat/core/config/app_log.dart';

final profileReporitoryProvider = Provider((ref) {
  return ProfileRepository(
    database: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

class ProfileRepository {
  final FirebaseFirestore database;
  final FirebaseAuth auth;

  ProfileRepository({
    required this.database,
    required this.auth,
  });

  Future<void> updateUserProfile({
    required Map<String, dynamic> map,
  }) async {
    try {
      await database.collection(Collections.users).doc(auth.currentUser!.uid).update(map);
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
