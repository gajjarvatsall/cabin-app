import 'package:cabin_app/repository/cabin_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cabin extends StatefulWidget {
  const Cabin({Key? key}) : super(key: key);

  @override
  State<Cabin> createState() => _CabinState();
}

class _CabinState extends State<Cabin> {
  final String cabins = 'cabins';
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection(cabins).orderBy("cabinName").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 15,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () async {
                          /// Checks if the cabin is selected
                          if (documentSnapshot['isSelected'] == true) {
                            /// Checks if userId is equal to auth userId
                            if (documentSnapshot['userId'] == auth.currentUser!.uid) {
                              /// TAP-OUT
                              CabinRepository.updateCabinValue(documentSnapshot.id, false, '');
                            }
                          } else {
                            bool hasData = await CabinRepository.doesUserIdAlreadyExist(auth.currentUser!.uid);

                            /// Checks if user is in any cabin
                            if (hasData == true) {
                              /// Show that user has been already in cabin
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("You are already in a Cabin !"),
                                duration: Duration(milliseconds: 500),
                              ));
                            } else {
                              /// TAP-IN
                              CabinRepository.updateCabinValue(documentSnapshot.id, true, auth.currentUser!.uid);
                            }
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: documentSnapshot['isSelected'] == true ? Colors.red : Colors.green,
                              border: Border.all(
                                color: documentSnapshot['isSelected'] == true ? Colors.red : Colors.green,
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
                    });
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ],
    );
  }
}
