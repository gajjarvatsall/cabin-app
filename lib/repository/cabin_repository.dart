import 'package:cloud_firestore/cloud_firestore.dart';

class CabinRepository {
  static Future<void> updateCabinValue(String id, bool isSelected, String userId, String userName, String userPic) async {
    await FirebaseFirestore.instance
        .collection('cabins')
        .doc(id)
        .update({'isSelected': isSelected, 'userId': userId, 'userName': userName, 'userPic': userPic});
  }

  static Future<bool> doesUserIdAlreadyExist(String userId) async {
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('cabins').where('userId', isEqualTo: userId).limit(1).get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }
}
