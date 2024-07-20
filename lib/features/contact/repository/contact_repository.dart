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

  Future<List<Map<String, dynamic>>> getContactsByKeyword({
    required String keyword,
  }) async {
    try {
      final snapshotPhone = await database
          .collection(Collections.users)
          .where(
            "phoneNumber",
            isEqualTo: keyword,
          )
          .get();

      final snapshotName = await database
          .collection(Collections.users)
          .where(
            "name",
            isEqualTo: keyword,
          )
          .get();

      List<Map<String, dynamic>> filteredContacts = [];
      if (snapshotPhone.docs.isNotEmpty) {
        final contacts = snapshotPhone.docs.map((doc) => doc.data()).toList();
        filteredContacts.addAll(contacts);
      }
      if (snapshotName.docs.isNotEmpty) {
        final contacts = snapshotName.docs.map((doc) => doc.data()).toList();
        filteredContacts.addAll(contacts);
      }
      return filteredContacts;
    } catch (e) {
      logger.e("getContactsByIds: ${e.toString()}");
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getContactsByIds({
    required List<String> contactIds,
  }) async {
    try {
      final snapshot = await database
          .collection(Collections.users)
          .where(
            "uid",
            whereIn: contactIds,
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
