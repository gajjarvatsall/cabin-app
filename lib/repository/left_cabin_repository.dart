import 'package:cloud_firestore/cloud_firestore.dart';

class CabinRepository {
  final String cabinLeft = "cabinLeft";

  Future<void> updateCabinValue(String id, bool isSelected) async {
    await FirebaseFirestore.instance
        .collection(cabinLeft)
        .doc(id)
        .update({'isSelected': !isSelected});
  }
}
