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

  Future<bool> addContactForUserToDB({
    required String contactUid,
  }) async {
    try {
      await database.collection(Collections.users).doc(currentUser?.uid).update({
        "contactIds": FieldValue.arrayUnion([contactUid]),
      });
      return true;
    } catch (e) {
      logger.e("addContactForUserToDB: ${e.toString()}");
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserDataFromDB() async {
    try {
      final userData = await database.collection(Collections.users).doc(currentUser?.uid).get();
      return userData.data();
    } catch (e) {
      logger.e("getUserDataFromDB: ${e.toString()}");
      return null;
    }
  }

  Future<void> updateUserDataToDB({
    required Map<String, dynamic> map,
  }) async {
    try {
      await database.collection(Collections.users).doc(currentUser?.uid).update(map);
    } catch (e) {
      logger.e("updateUserDataToDB: ${e.toString()}");
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
      return Left(DatabaseError(message: "saveUserDataToDB: ${e.toString()}"));
    }
  }
}
