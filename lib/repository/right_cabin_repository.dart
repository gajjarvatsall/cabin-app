import 'package:cloud_firestore/cloud_firestore.dart';

const String cabinRight = 'cabinRight';

class CabinRepository {
  static Future<void> updateCabinValue(String id, bool isSelected) async {
    await FirebaseFirestore.instance
        .collection(cabinRight)
        .doc(id)
        .update({'isSelected': !isSelected});
  }
}
