import 'package:cloud_firestore/cloud_firestore.dart';

class CabinRepository {
  final String cabinLeft = "cabinLeft";

  Future<void> updateCabinValue(
      String id, bool isSelected, String userId) async {
    await FirebaseFirestore.instance
        .collection(cabinLeft)
        .doc(id)
        .update({'isSelected': isSelected, 'userId': userId});
  }

  Future<bool> doesUserIdAlreadyExist(String userId) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(cabinLeft)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }
}
