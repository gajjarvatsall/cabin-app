import 'package:cabin_app/models/cabin_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RCabin {
  Future<List<CabinModel>> allCabins() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('cabin_beta').get();
    List<CabinModel>? cabins =
        snapshot.docs.map((e) => CabinModel.fromJson(e.data())).toList();
    print("listcabins=========${cabins}");
    return Future.value(cabins);
  }
}
