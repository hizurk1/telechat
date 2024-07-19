import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:telechat/app/constants/app_const.dart';
import 'package:telechat/app/constants/firebase_const.dart';
import 'package:telechat/core/error_handler/error_handler.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(
    auth: FirebaseAuth.instance,
    database: FirebaseFirestore.instance,
  );
});

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore database;

  AuthRepository({
    required this.auth,
    required this.database,
  });

  User? get currentUser => auth.currentUser;

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

  FutureEither<UserCredential> verifyOTP({
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      return Right(
        await auth.signInWithCredential(credential),
      );
    } on FirebaseAuthException catch (e) {
      return Left(AuthenticationError(message: e.message ?? ''));
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }

  Future<void> signInWithPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(String verificationId) timeOut,
  }) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw AuthenticationError(message: e.message ?? '');
        },
        codeSent: codeSent,
        timeout: const Duration(seconds: AppConst.otpTimeOutInSeconds),
        codeAutoRetrievalTimeout: timeOut,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthenticationError(message: e.message ?? '');
    } catch (e) {
      throw UnknownError(message: e.toString());
    }
  }
}
