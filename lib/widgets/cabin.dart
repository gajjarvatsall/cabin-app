import 'package:cabin_app/repository/cabin_repository.dart';
import 'package:cabin_app/utils/app_theme.dart';
import 'package:cabin_app/utils/constants.dart';
import 'package:cabin_app/widgets/custom_cabin.dart';
import 'package:cabin_app/widgets/custom_circle_avtar.dart';
import 'package:cabin_app/widgets/custom_dialog.dart';
import 'package:cabin_app/widgets/custom_logout_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/logo-grid-dark.svg',
                width: width / 17,
                height: height / 17,
                fit: BoxFit.cover,
              ),
              Text(
                "Welcome To 7Span",
                style: AppTheme.titleText,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const LogoutPopup();
                    },
                  );
                },
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CustomCircleAvatar(auth: auth, imgUrl: "${auth.currentUser!.photoURL}"),
                ),
              ),
            ],
          ),
          const Divider(),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection(cabins).snapshots(),
              builder: (context, snapshot) {
                return FutureBuilder(
                    future: CabinRepository.userData(),
                    builder: (context, snapShot) {
                      return (snapShot.data?.isNotEmpty ?? false)
                          ? SizedBox(
                              height: 50,
                              child: Marquee(
                                text: snapShot.data ?? ' Welcome To 7span ',
                                style: AppTheme.titleText,
                              ),
                            )
                          : Container();
                    });
              }),
          const Divider(),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection(cabins).limit(5).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: Wrap(
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
                                        title: 'Are you sure you want to tap OUT?',
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
                                        title: "Are you sure you want to tap IN?",
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
                            child: CustomCabin(
                              documentSnapshot: documentSnapshot,
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
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection(cabins).where("cabinId", isGreaterThan: 5).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                                      title: 'Are you sure you want to tap OUT?',
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
                                      title: 'Are you sure you want to tap IN?',
                                      onPressed: () async {
                                        CabinRepository.updateCabinValue(documentSnapshot.id, true, auth.currentUser!.uid,
                                            auth.currentUser!.displayName.toString(), auth.currentUser!.photoURL.toString());
                                        Navigator.of(context).pop();

                                        //   Navigator.pop(context);
                                      },
                                    );
                                  },
                                );
                              }
                            }
                          },
                          child: CustomCabin(documentSnapshot: documentSnapshot),
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
