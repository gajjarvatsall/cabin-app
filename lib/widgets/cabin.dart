import 'dart:async';

import 'package:cabin_app/repository/cabin_repository.dart';
import 'package:cabin_app/utils/app_theme.dart';
import 'package:cabin_app/utils/constants.dart';
import 'package:cabin_app/widgets/custom_cabin.dart';
import 'package:cabin_app/widgets/custom_dialog.dart';
import 'package:cabin_app/widgets/custom_image_dailog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class Cabin extends StatefulWidget {
  Cabin({Key? key}) : super(key: key);

  @override
  State<Cabin> createState() => _CabinState();
}

class _CabinState extends State<Cabin> {
  final String cabins = 'cabins';
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
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
                                  if (isVisible == true) {
                                    return;
                                  }
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      isVisible = true;
                                      return CustomDialog(
                                        meme: 'assets/images/meme-2.png',
                                        onPressedPositive: () {
                                          CabinRepository.updateCabinValue(
                                              documentSnapshot.id, false, DateTime.now(), '', '', '');
                                          Navigator.pop(context);
                                          isVisible = false;
                                        },
                                        onPressedNegative: () {
                                          Navigator.of(context).pop();
                                          isVisible = false;
                                        },
                                        button1Title: 'Nathi Javu',
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
                                  _customSnackbar(context);
                                } else {
                                  /// TAP-IN
                                  if (!mounted) return;
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return CustomDialog(
                                        meme: 'assets/images/meme-4.png',
                                        onPressedPositive: () {
                                          CabinRepository.updateCabinValue(
                                              documentSnapshot.id,
                                              true,
                                              DateTime.now(),
                                              auth.currentUser!.uid,
                                              auth.currentUser!.displayName.toString(),
                                              auth.currentUser!.photoURL.toString());
                                          Navigator.pop(context);
                                        },
                                        onPressedNegative: () => Navigator.pop(context),
                                        button1Title: 'Nathi Javu',
                                        button2Title: 'Saru',
                                      );
                                    },
                                  );
                                }
                              }
                              if (documentSnapshot['isSelected'] == true) {
                                if (documentSnapshot['userId'] != auth.currentUser!.uid && documentSnapshot['userId'] != null) {
                                  if (!mounted) return;
                                  await showDialog(
                                    barrierDismissible: false,
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
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return CustomDialog(
                                      meme: 'assets/images/meme-2.png',
                                      onPressedPositive: () {
                                        CabinRepository.updateCabinValue(documentSnapshot.id, false, DateTime.now(), '', '', '');
                                        Navigator.pop(context);
                                      },
                                      onPressedNegative: () => Navigator.pop(context),
                                      button1Title: 'Nathi Javu',
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
                                _customSnackbar(context);
                              } else {
                                /// TAP-IN
                                if (!mounted) return;
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return CustomDialog(
                                      meme: 'assets/images/meme-4.png',
                                      onPressedPositive: () async {
                                        CabinRepository.updateCabinValue(
                                            documentSnapshot.id,
                                            true,
                                            DateTime.now(),
                                            auth.currentUser!.uid,
                                            auth.currentUser!.displayName.toString(),
                                            auth.currentUser!.photoURL.toString());
                                        Navigator.of(context).pop();
                                        //   Navigator.pop(context);
                                      },
                                      onPressedNegative: () => Navigator.pop(context),
                                      button1Title: 'Nathi Javu',
                                      button2Title: 'Saru',
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
                                  barrierDismissible: false,
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

  _customSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("You are already in a Cabin!"),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
