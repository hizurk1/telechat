import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:telechat/app/constants/firebase_const.dart';
import 'package:telechat/core/config/app_log.dart';
import 'package:telechat/core/error_handler/error.dart';
import 'package:telechat/core/error_handler/typedef.dart';

final userRepositoryProvider = Provider((ref) {
  return UserRepository(
    auth: FirebaseAuth.instance,
    database: FirebaseFirestore.instance,
  );
});

class UserRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore database;

  UserRepository({
    required this.auth,
    required this.database,
  });

  User? get currentUser => auth.currentUser;

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final userData = await database.collection(Collections.users).doc(currentUser?.uid).get();
      return userData.data();
    } catch (e) {
      logger.e("getUserData: ${e.toString()}");
      return null;
    }
  }

  FutureEither<void> saveUserDataToDB({
    required String uid,
    required Map<String, dynamic> map,
  }) async {
    try {
      return Right(
        await database.collection(Collections.users).doc(uid).set(map),
      );
    } catch (e) {
      return Left(DatabaseError(message: e.toString()));
    }
  }
}
