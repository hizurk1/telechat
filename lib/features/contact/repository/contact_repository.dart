import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/constants/firebase_const.dart';
import 'package:telechat/core/config/app_log.dart';

final contactRepositoryProvider = Provider((ref) {
  return ContactRepository(
    database: FirebaseFirestore.instance,
    ref: ref,
  );
});

class ContactRepository {
  final FirebaseFirestore database;
  final ProviderRef ref;

  ContactRepository({
    required this.database,
    required this.ref,
  });

  Future<List<Map<String, dynamic>>> getContactsByIds({
    required List<String> contactIds,
  }) async {
    try {
      final snapshot = await database
          .collection(Collections.users)
          .where(
            "contactIds",
            arrayContainsAny: contactIds,
          )
          .get();
      final listMaps = snapshot.docs.map((doc) => doc.data()).toList();
      return listMaps;
    } catch (e) {
      logger.e("getContactsByIds: ${e.toString()}");
    }
    return [];
  }
}
