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

  static Future<String> userData() async {
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('cabins').where('userName', isNotEqualTo: '').get();
    final List<DocumentSnapshot> documents = result.docs;
    String formatted = '';
    for (var element in documents) {
      if (element['userName'].toString().isNotEmpty) {
        if (formatted.isNotEmpty) {
          formatted = '${formatted + element['userName']} is in Cabin ${element['cabinName']} • ';
        } else {
          formatted = element['userName'] + ' is in Cabin ${element['cabinName']} • ';
        }
      }
    }
    return formatted;
  }

// static Future<String> getUserProfile(String id) async {
//   DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance.collection('users').doc(id).get();
//   return data['name'];
// }
}
