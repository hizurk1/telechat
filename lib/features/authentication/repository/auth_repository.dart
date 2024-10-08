import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:telechat/app/configs/remote_config.dart';
import 'package:telechat/core/config/app_log.dart';
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
        timeout: Duration(seconds: RemoteConfig.otpTimeOutInSeconds),
        codeAutoRetrievalTimeout: timeOut,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthenticationError(message: e.message ?? '');
    } catch (e) {
      throw UnknownError(message: e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
