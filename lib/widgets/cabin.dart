import 'dart:developer';

import 'package:cabin_app/helper/google_firebase_helper.dart';
import 'package:cabin_app/repository/cabin_repository.dart';
import 'package:cabin_app/utils/app_theme.dart';
import 'package:cabin_app/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
                alignment: Alignment.topRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    GoogleAuthentication.googleUserSignOut(context);
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  },
                  icon: Icon(Icons.logout),
                  label: Text("Logout"),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Left Cabin",
                style: AppTheme.titleText,
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection(cabins).limit(5).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Wrap(
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runSpacing: 2,
                        spacing: 15,
                        children: snapshot.data!.docs.map((documentSnapshot) {
                          log("documentSnapshot['isSelected']: ${documentSnapshot['isSelected']}");
                          return GestureDetector(
                            onTap: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: documentSnapshot['isSelected'] == true
                                      ? const Text('Are you sure! you want to TAP OUT ?')
                                      : const Text('Are you sure! you want to TAP IN ?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        /// Checks if the cabin is selected
                                        if (documentSnapshot['isSelected'] == true) {
                                          /// Checks if userId is equal to auth userId
                                          if (documentSnapshot['userId'] == auth.currentUser!.uid) {
                                            /// TAP-OUT
                                            CabinRepository.updateCabinValue(documentSnapshot.id, false, '', '', '');
                                          }
                                        } else {
                                          bool hasData =
                                              await CabinRepository.doesUserIdAlreadyExist(auth.currentUser!.uid);

                                          /// Checks if user is in any cabin
                                          if (hasData == true) {
                                            /// Show that user has been already in cabin
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                              content: Text("You are already in a Cabin!"),
                                              duration: Duration(milliseconds: 500),
                                            ));
                                          } else {
                                            /// TAP-IN
                                            CabinRepository.updateCabinValue(
                                                documentSnapshot.id,
                                                true,
                                                auth.currentUser!.uid,
                                                auth.currentUser!.displayName.toString(),
                                                auth.currentUser!.photoURL.toString());
                                          }
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Continue'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("${documentSnapshot['cabinName']}"),
                                Container(
                                  width: MediaQuery.of(context).size.width / 11,
                                  height: MediaQuery.of(context).size.width / 11,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color:
                                          documentSnapshot['isSelected'] == true ? Colors.red.shade400 : Colors.white,
                                      border: Border.all(
                                        width: 3,
                                        color:
                                            documentSnapshot['isSelected'] == true ? Colors.red.shade400 : Colors.green,
                                      )),
                                  child: documentSnapshot['isSelected'] == true
                                      ? CircleAvatar(
                                          minRadius: 30,
                                          backgroundColor: Colors.white,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl: "${documentSnapshot['userPic']}",
                                              fit: BoxFit.cover,
                                              height: 150,
                                              width: 150,
                                              alignment: Alignment.center,
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: Icon(
                                            Icons.event_seat_outlined,
                                            size: MediaQuery.of(context).size.width * 0.05,
                                          ),
                                        ),
                                ),
                                documentSnapshot['isSelected'] == true
                                    ? Text(
                                        ("${documentSnapshot['userName']}"),
                                        textAlign: TextAlign.center,
                                      )
                                    : const Flexible(child: Text("")),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
          const Divider(),
          SizedBox(
            height: AppConstants.height,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Right Cabin",
                style: AppTheme.titleText,
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection(cabins).where("cabinId", isGreaterThan: 5).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Wrap(
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runSpacing: 2,
                        spacing: 15,
                        children: snapshot.data!.docs.map((documentSnapshot) {
                          log("documentSnapshot['isSelected']: ${documentSnapshot['isSelected']}");
                          return GestureDetector(
                            onTap: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: documentSnapshot['isSelected'] == true
                                      ? const Text('Are you sure! you want to TAP OUT ?')
                                      : const Text('Are you sure! you want to TAP IN ?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        /// Checks if the cabin is selected
                                        if (documentSnapshot['isSelected'] == true) {
                                          /// Checks if userId is equal to auth userId
                                          if (documentSnapshot['userId'] == auth.currentUser!.uid) {
                                            /// TAP-OUT
                                            CabinRepository.updateCabinValue(documentSnapshot.id, false, '', '', '');
                                          }
                                        } else {
                                          bool hasData =
                                              await CabinRepository.doesUserIdAlreadyExist(auth.currentUser!.uid);

                                          /// Checks if user is in any cabin
                                          if (hasData == true) {
                                            /// Show that user has been already in cabin
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                              content: Text("You are already in a Cabin!"),
                                              duration: Duration(milliseconds: 500),
                                            ));
                                          } else {
                                            /// TAP-IN
                                            CabinRepository.updateCabinValue(
                                                documentSnapshot.id,
                                                true,
                                                auth.currentUser!.uid,
                                                auth.currentUser!.displayName.toString(),
                                                auth.currentUser!.photoURL.toString());
                                          }
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Continue'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("${documentSnapshot['cabinName']}"),
                                Container(
                                  width: MediaQuery.of(context).size.width / 11,
                                  height: MediaQuery.of(context).size.width / 11,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color:
                                          documentSnapshot['isSelected'] == true ? Colors.red.shade400 : Colors.white,
                                      border: Border.all(
                                        width: 3,
                                        color:
                                            documentSnapshot['isSelected'] == true ? Colors.red.shade400 : Colors.green,
                                      )),
                                  child: documentSnapshot['isSelected'] == true
                                      ? CircleAvatar(
                                          minRadius: 30,
                                          backgroundColor: Colors.white,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl: "${documentSnapshot['userPic']}",
                                              fit: BoxFit.cover,
                                              height: 150,
                                              width: 150,
                                              alignment: Alignment.center,
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: Icon(
                                            Icons.event_seat,
                                            size: MediaQuery.of(context).size.width * 0.05,
                                          ),
                                        ),
                                ),
                                documentSnapshot['isSelected'] == true
                                    ? Text(
                                        ("${documentSnapshot['userName']}"),
                                        textAlign: TextAlign.center,
                                      )
                                    : const Flexible(child: Text("")),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppConstants.height,
          ),
        ],
      ),
    );
  }
}
