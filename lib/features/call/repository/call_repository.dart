import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/constants/firebase_const.dart';
import 'package:telechat/core/config/app_log.dart';
import 'package:telechat/features/call/models/call_model.dart';

final callRepositoryProvider = Provider((ref) {
  return CallRepository(
    database: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

class CallRepository {
  final FirebaseFirestore database;
  final FirebaseAuth auth;

  const CallRepository({
    required this.database,
    required this.auth,
  });

  Stream<Map<String, dynamic>?> get getCallAsStream {
    return database
        .collection(Collections.calls)
        .doc(auth.currentUser!.uid)
        .snapshots()
        .map((doc) => doc.data());
  }

  Future<bool> makeCall({
    required CallModel callerModel,
    required List<String> memberIds,
  }) async {
    try {
      final batch = database.batch();
      final myRef = database.collection(Collections.calls).doc(callerModel.callerId);
      batch.set(myRef, callerModel.toMap());

      for (String id in memberIds) {
        if (id != callerModel.callerId) {
          final docRef = database.collection(Collections.calls).doc(id);
          batch.set(
            docRef,
            callerModel.copyWith(hasDialled: false).toMap(),
          );
        }
      }

      await batch.commit();
      return true;
    } catch (e) {
      logger.e(e.toString());
      return false;
    }
  }

  Future<bool> endCall({
    required String callerId,
    required List<String> memberIds,
  }) async {
    try {
      final batch = database.batch();
      final myRef = database.collection(Collections.calls).doc(callerId);
      batch.delete(myRef);

      for (String id in memberIds) {
        final docRef = database.collection(Collections.calls).doc(id);
        batch.delete(docRef);
      }

      await batch.commit();
      return true;
    } catch (e) {
      logger.e(e.toString());
      return false;
    }
  }
}
