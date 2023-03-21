import 'package:cloud_firestore/cloud_firestore.dart';

const String cabinRight = 'cabinRight';

class CabinRepository {
  static Future<void> updateCabinValue(
      String id, bool isSelected, String userId) async {
    await FirebaseFirestore.instance
        .collection(cabinRight)
        .doc(id)
        .update({'isSelected': isSelected, 'userId': userId});
  }

  static Future<bool> doesUserIdAlreadyExist(String userId) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(cabinRight)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }
}
