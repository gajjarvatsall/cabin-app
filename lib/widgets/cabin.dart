import 'package:cabin_app/helper/google_firebase_helper.dart';
import 'package:cabin_app/repository/cabin_repository.dart';
import 'package:cabin_app/utils/app_theme.dart';
import 'package:cabin_app/utils/constants.dart';
import 'package:cabin_app/widgets/custom_cabin.dart';
import 'package:cabin_app/widgets/custom_circle_avtar.dart';
import 'package:cabin_app/widgets/custom_dialog.dart';
import 'package:cabin_app/widgets/custom_image_dailog.dart';
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
  bool isVisible = false;

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
                style: AppTheme.titleText.copyWith(fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomDialog(
                        title: "Are you sure do you want to Logout?",
                        onPressed: () {
                          GoogleAuthentication.googleUserSignOut(context);
                          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                        },
                        button1Title: 'Cancel',
                        button2Title: 'Ok',
                      );
                    },
                  );
                },
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CustomCircleAvatar(
                    auth: auth,
                    imgUrl: "${auth.currentUser!.photoURL}",
                    radius: 100,
                  ),
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
                      ? Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: Marquee(
                                blankSpace: 100,
                                text: snapShot.data ?? ' Welcome To 7span ',
                                style: AppTheme.titleText,
                              ),
                            ),
                            const Divider(),
                          ],
                        )
                      : Container();
                },
              );
            },
          ),
          SizedBox(
            height: AppConstants.height,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Left Cabin",
                style: AppTheme.titleText.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                "Right Cabin",
                style: AppTheme.titleText.copyWith(fontWeight: FontWeight.w600),
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
                                        title: 'Bus Dost Javu J Che?',
                                        onPressed: () {
                                          CabinRepository.updateCabinValue(documentSnapshot.id, false, '', '', '');
                                          Navigator.pop(context);
                                        },
                                        button1Title: 'Naa',
                                        button2Title: 'Haa',
                                      );
                                    },
                                  );
                                }
                              } else {
                                bool hasData = await CabinRepository.doesUserIdAlreadyExist(auth.currentUser!.uid);

                                /// Checks if user is in any cabin
                                if (hasData == true) {
                                  /// Show that user has been already in cabin
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("You are already in a Cabin!"),
                                    duration: Duration(seconds: 1),
                                  ));
                                } else {
                                  /// TAP-IN
                                  if (!mounted) return;
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialog(
                                        title: "Bau var na lagadata ho",
                                        onPressed: () {
                                          CabinRepository.updateCabinValue(documentSnapshot.id, true, auth.currentUser!.uid,
                                              auth.currentUser!.displayName.toString(), auth.currentUser!.photoURL.toString());
                                          Navigator.pop(context);
                                        },
                                        button1Title: 'Naa',
                                        button2Title: 'Haa',
                                      );
                                    },
                                  );
                                }
                              }
                              if (documentSnapshot['isSelected'] == true) {
                                if (documentSnapshot['userId'] != auth.currentUser!.uid && documentSnapshot['userId'] != null) {
                                  if (!mounted) return;
                                  await showDialog(
                                    context: context,
                                    builder: (_) {
                                      Future.delayed(const Duration(seconds: 2), () {
                                        Navigator.of(context).pop(true);
                                      });
                                      return ImageDialog();
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
                                      title: 'Bus Dost Javu J Che?',
                                      onPressed: () {
                                        CabinRepository.updateCabinValue(documentSnapshot.id, false, '', '', '');
                                        Navigator.pop(context);
                                      },
                                      button1Title: 'Naaa',
                                      button2Title: 'Haa',
                                    );
                                  },
                                );
                              }
                            } else {
                              bool hasData = await CabinRepository.doesUserIdAlreadyExist(auth.currentUser!.uid);

                              /// Checks if user is in any cabin
                              if (hasData == true) {
                                /// Show that user has been already in cabin
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("You are already in a Cabin!"),
                                  duration: Duration(seconds: 1),
                                ));
                              } else {
                                /// TAP-IN
                                if (!mounted) return;
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialog(
                                      title: 'Bau Var Na Lagadata Ho',
                                      onPressed: () async {
                                        CabinRepository.updateCabinValue(documentSnapshot.id, true, auth.currentUser!.uid,
                                            auth.currentUser!.displayName.toString(), auth.currentUser!.photoURL.toString());
                                        Navigator.of(context).pop();
                                        //   Navigator.pop(context);
                                      },
                                      button1Title: 'Naa',
                                      button2Title: 'Haa',
                                    );
                                  },
                                );
                              }
                            }
                            if (documentSnapshot['isSelected'] == true) {
                              if (documentSnapshot['userId'] != auth.currentUser!.uid && documentSnapshot['userId'] != null) {
                                if (!mounted) return;
                                await showDialog(
                                  context: context,
                                  builder: (_) {
                                    Future.delayed(const Duration(seconds: 2), () {
                                      Navigator.of(context).pop(true);
                                    });
                                    return ImageDialog();
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
                    return Container();
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
