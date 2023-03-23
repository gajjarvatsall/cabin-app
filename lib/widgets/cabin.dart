import 'package:cabin_app/repository/cabin_repository.dart';
import 'package:cabin_app/utils/constants.dart';
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
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection(cabins).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 9,
                        childAspectRatio: 2 / 3,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                /// Checks if the cabin is selected
                                if (documentSnapshot['isSelected'] == true) {
                                  /// Checks if userId is equal to auth userId
                                  if (documentSnapshot['userId'] == auth.currentUser!.uid) {
                                    /// TAP-OUT
                                    CabinRepository.updateCabinValue(documentSnapshot.id, false, '', '', '');
                                  }
                                } else {
                                  bool hasData = await CabinRepository.doesUserIdAlreadyExist(auth.currentUser!.uid);

                                  /// Checks if user is in any cabin
                                  if (hasData == true) {
                                    /// Show that user has been already in cabin
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text("You are already in a Cabin!"),
                                      duration: Duration(milliseconds: 500),
                                    ));
                                  } else {
                                    /// TAP-IN
                                    CabinRepository.updateCabinValue(documentSnapshot.id, true, auth.currentUser!.uid,
                                        auth.currentUser!.displayName.toString(), auth.currentUser!.photoURL.toString());
                                  }
                                }
                              },
                              child: Column(
                                children: [
                                  Text("${documentSnapshot['cabinName']}"),
                                  Container(
                                      width: MediaQuery.of(context).size.width / 11,
                                      height: MediaQuery.of(context).size.width / 10,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: documentSnapshot['isSelected'] == true ? Colors.red : Colors.green,
                                          border: Border.all(
                                            color: documentSnapshot['isSelected'] == true ? Colors.red : Colors.green,
                                          )),
                                      child: documentSnapshot['isSelected'] == true
                                          ? CircleAvatar(
                                              foregroundImage: NetworkImage("${documentSnapshot['userPic']}"),
                                            )
                                          : Icon(Icons.home)),
                                  documentSnapshot['isSelected'] == true
                                      ? Text(("${documentSnapshot['userName']}"))
                                      : const Text(""),
                                ],
                              ),
                            ),
                            if (index == 4)
                              const Divider(
                                  // The divider's height extent.
                                  ),
                          ],
                        );
                      });
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
          SizedBox(
            height: AppConstants.height,
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RotatedBox(
                quarterTurns: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: 90,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
              RotatedBox(
                quarterTurns: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: 90,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
