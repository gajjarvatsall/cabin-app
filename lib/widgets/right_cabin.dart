import 'package:cabin_app/repository/right_cabin_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RightCabin extends StatefulWidget {
  const RightCabin({Key? key}) : super(key: key);

  @override
  State<RightCabin> createState() => _RightCabinState();
}

class _RightCabinState extends State<RightCabin> {
  final String cabinRight = 'cabinRight';
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Text(
            "Right cabins",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:
                  FirebaseFirestore.instance.collection(cabinRight).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 15,
                    children:
                        List.generate(snapshot.data!.docs.length, (index) {
                      DocumentSnapshot cabins = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () async {
                          if (cabins['userId'] == auth.currentUser!.uid &&
                              cabins['isSelected'] == true) {
                            CabinRepository.updateCabinValue(
                                cabins.id, false, '');
                          } else {
                            bool hasData =
                                await CabinRepository.doesNameAlreadyExist(
                                    auth.currentUser!.uid);
                            if (hasData == false) {
                              CabinRepository.updateCabinValue(
                                  cabins.id, true, auth.currentUser!.uid);
                            } else {}
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: cabins['isSelected'] == true
                                  ? Colors.red
                                  : Colors.green,
                              border: Border.all(
                                color: cabins['isSelected'] == true
                                    ? Colors.red
                                    : Colors.green,
                              )),
                          child: Center(
                            child: Text(
                              "${index + 1}",
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
