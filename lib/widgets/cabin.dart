import 'package:cabin_app/repository/cabin_repository.dart';
import 'package:cabin_app/utils/app_theme.dart';
import 'package:cabin_app/utils/constants.dart';
import 'package:cabin_app/widgets/custom_circle_avtar.dart';
import 'package:cabin_app/widgets/custom_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

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
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Marquee(text: "Welcome To 7Span * "),
                ),
              ),
              SizedBox(
                width: AppConstants.width,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: CustomCircleAvatar(
                  auth: auth,
                  imgUrl: '${auth.currentUser!.photoURL}',
                ),
              )
            ],
          ),
          SizedBox(
            height: AppConstants.height,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Left Cabin",
                style: AppTheme.titleText,
              ),
              Text(
                "Right Cabin",
                style: AppTheme.titleText,
              ),
            ],
          ),
          SizedBox(
            height: AppConstants.height,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection(cabins).limit(5).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      flex: 3,
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runSpacing: 2,
                        spacing: 15,
                        children: snapshot.data!.docs.map((documentSnapshot) {
                          return GestureDetector(
                            onTap: () async {
                              /// Checks if the cabin is selected
                              if (documentSnapshot['isSelected'] == true) {
                                /// Checks if userId is equal to auth userId
                                if (documentSnapshot['userId'] == auth.currentUser!.uid) {
                                  /// TAP-OUT
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialog(
                                        title: 'Are You Sure You Want To Tap OUT?',
                                        onPressed: () {
                                          CabinRepository.updateCabinValue(documentSnapshot.id, false, '', '', '');
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  );
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
                                  if (!mounted) return;
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialog(
                                        title: "Are You Sure You Want To Tap IN?",
                                        onPressed: () {
                                          CabinRepository.updateCabinValue(documentSnapshot.id, true, auth.currentUser!.uid,
                                              auth.currentUser!.displayName.toString(), auth.currentUser!.photoURL.toString());
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  );
                                }
                              }
                            },
                            child: Tooltip(
                              message: documentSnapshot['isSelected'] == true ? "${documentSnapshot['userName']}" : "",
                              child: Container(
                                width: MediaQuery.of(context).size.width / 12,
                                height: MediaQuery.of(context).size.width / 12,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: documentSnapshot['isSelected'] == true ? Colors.red.shade400 : Colors.white,
                                    border: Border.all(
                                      width: 3,
                                      color: documentSnapshot['isSelected'] == true ? Colors.red.shade400 : Colors.green,
                                    )),
                                child: documentSnapshot['isSelected'] == true
                                    ? CustomCircleAvatar(auth: auth, imgUrl: "${documentSnapshot['userPic']}")
                                    : Center(
                                        child: Icon(
                                          Icons.event_seat_outlined,
                                          size: MediaQuery.of(context).size.width * 0.05,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              // SizedBox(
              //   width: AppConstants.width,
              // ),
              Flexible(flex: 1, child: Container()),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection(cabins).where("cabinId", isGreaterThan: 5).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      flex: 3,
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runSpacing: 2,
                        spacing: 15,
                        children: snapshot.data!.docs.map((documentSnapshot) {
                          return GestureDetector(
                            onTap: () async {
                              /// Checks if the cabin is selected
                              if (documentSnapshot['isSelected'] == true) {
                                /// Checks if userId is equal to auth userId
                                if (documentSnapshot['userId'] == auth.currentUser!.uid) {
                                  /// TAP-OUT
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialog(
                                        title: 'Are You Sure You Want To Tap OUT?',
                                        onPressed: () {
                                          CabinRepository.updateCabinValue(documentSnapshot.id, false, '', '', '');
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  );
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
                                  if (!mounted) return;
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialog(
                                        title: 'Are You Sure You Want To Tap IN?',
                                        onPressed: () {
                                          CabinRepository.updateCabinValue(documentSnapshot.id, true, auth.currentUser!.uid,
                                              auth.currentUser!.displayName.toString(), auth.currentUser!.photoURL.toString());
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  );
                                }
                              }
                            },
                            child: Tooltip(
                              message: documentSnapshot['isSelected'] == true ? "${documentSnapshot['userName']}" : "",
                              child: Container(
                                width: MediaQuery.of(context).size.width / 12,
                                height: MediaQuery.of(context).size.width / 12,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: documentSnapshot['isSelected'] == true ? Colors.red.shade400 : Colors.white,
                                    border: Border.all(
                                      width: 3,
                                      color: documentSnapshot['isSelected'] == true ? Colors.red.shade400 : Colors.green,
                                    )),
                                child: documentSnapshot['isSelected'] == true
                                    ? CustomCircleAvatar(
                                        auth: auth,
                                        imgUrl: "${documentSnapshot['userPic']}",
                                      )
                                    : Center(
                                        child: Icon(
                                          Icons.event_seat,
                                          size: MediaQuery.of(context).size.width * 0.05,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
          SizedBox(
            height: AppConstants.height,
          ),
          const Divider(),
        ],
      ),
    );
  }
}
