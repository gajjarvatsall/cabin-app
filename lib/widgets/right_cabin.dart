import 'package:cabin_app/helper/get_storage_helper.dart';
import 'package:cabin_app/repository/right_cabin_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class RightCabin extends StatefulWidget {
  const RightCabin({Key? key}) : super(key: key);

  @override
  State<RightCabin> createState() => _RightCabinState();
}

class _RightCabinState extends State<RightCabin> {
  final String cabinRight = 'cabinRight';
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    onTapped.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            stream: FirebaseFirestore.instance.collection(cabinRight).snapshots(),
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
                      DocumentSnapshot cabins = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () async {
                          /// Stored a variable locally for isTappedIn or Not
                          bool isTapped = onTapped.getStorage.read('isTap');

                          /// Check if any of cabin is selected or not

                          if (cabins['isSelected'] == false) {
                            /// Check if cabin is selected with auth user id and local variable is true

                            if (cabins['userId'] == auth.currentUser!.uid && cabins['isSelected'] == true && isTapped) {
                              CabinRepository.updateCabinValue(cabins.id, false, '');
                              onTapped.getStorage.write('isTap', false);
                            } else {
                              /// Check if user already in any cabin
                              bool hasData = await CabinRepository.doesUserIdAlreadyExist(auth.currentUser!.uid);

                              /// Check if user not in any cabin and not selected any cabin and local variable is false
                              if (hasData == false && cabins['isSelected'] == false && !isTapped) {
                                CabinRepository.updateCabinValue(cabins.id, true, auth.currentUser!.uid);
                                onTapped.getStorage.write('isTap', true);
                              } else {
                                /// Show that user has been already in cabin
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("You are already in a Cabin !"),
                                  duration: Duration(seconds: 1),
                                ));
                              }
                            }
                          } else {
                            /// TAP-OUT
                            /// Check if user has been already in cabin and local variable is true
                            if (cabins['userId'] == auth.currentUser!.uid && cabins['isSelected'] == true && isTapped) {
                              CabinRepository.updateCabinValue(cabins.id, false, '');
                              onTapped.getStorage.write('isTap', false);
                            }
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: cabins['isSelected'] == true ? Colors.red : Colors.green,
                              border: Border.all(
                                color: cabins['isSelected'] == true ? Colors.red : Colors.green,
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
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
