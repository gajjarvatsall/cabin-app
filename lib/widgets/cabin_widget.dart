import 'dart:async';

import 'package:cabin_app/repository/cabin_repository.dart';
import 'package:cabin_app/utils/app_theme.dart';
import 'package:cabin_app/utils/utils.dart';
import 'package:cabin_app/widgets/custom_dialog.dart';
import 'package:cabin_app/widgets/custom_image_dailog.dart';
import 'package:cabin_app/widgets/profiled_Img.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CustomCabin extends StatefulWidget {
  CustomCabin({
    super.key,
    required this.documentSnapshot,
    required this.deviceWidth,
  });

  final QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot;
  double deviceWidth;

  @override
  State<CustomCabin> createState() => _CustomCabinState();
}

class _CustomCabinState extends State<CustomCabin> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final BehaviorSubject<int> subjectTimer = BehaviorSubject();
  bool isVisible = false;
  int sinceInSec = 0;
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setTimer();
  }

  @override
  void didUpdateWidget(covariant CustomCabin oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.documentSnapshot['isSelected'] == true) {
      DateTime startTime = widget.documentSnapshot['startTime'].toDate();
      int sinceInSec = DateTime.now().difference(startTime).inSeconds;
      if (sinceInSec < 3) {
        setTimer();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {
        /// Checks if the cabin is selected
        if (widget.documentSnapshot['isSelected'] == true) {
          /// Checks if userId is equal to auth userId
          if (widget.documentSnapshot['userId'] == auth.currentUser!.uid) {
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
                  onPressedPositive: () async {
                    await CabinRepository.updateCabinValue(widget.documentSnapshot.id, false, DateTime.now(), '', '', '');
                    Navigator.pop(context);
                    setTimer();
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
                  onPressedPositive: () async {
                    await CabinRepository.updateCabinValue(widget.documentSnapshot.id, true, DateTime.now(),
                        auth.currentUser!.uid, auth.currentUser!.displayName.toString(), auth.currentUser!.photoURL.toString());
                    setTimer();
                    Navigator.of(context).pop();
                  },
                  onPressedNegative: () => Navigator.pop(context),
                  button1Title: 'Nathi Javu',
                  button2Title: 'Saru',
                );
              },
            );
          }
        }
        if (widget.documentSnapshot['isSelected'] == true) {
          if (widget.documentSnapshot['userId'] != auth.currentUser!.uid && widget.documentSnapshot['userId'] != null) {
            if (!mounted) return;
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) {
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.of(context).pop(true);
                });
                return ImageDialog(
                  meme: 'assets/images/meme-1.png',
                );
              },
            );
          }
        }
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            width: widget.deviceWidth > 900 ? width / 13 : width / 6,
            height: widget.deviceWidth > 900 ? width / 13 : width / 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: widget.documentSnapshot['isSelected'] == true ? 0 : 1,
                color: widget.documentSnapshot['isSelected'] == true ? Colors.transparent : Colors.green,
              ),
            ),
            child: widget.documentSnapshot['isSelected'] == true
                ? ProfiledPhoto(
                    auth: auth,
                    imgUrl: widget.documentSnapshot['userPic'],
                    radius: 10,
                  )
                : Center(
                    child: Text(
                      "${widget.documentSnapshot['cabinName']}",
                      style: AppTheme.titleText,
                    ),
                  ),
          ),
          StreamBuilder<int>(
            stream: subjectTimer,
            builder: (context, snapshot) {
              int timerValue = snapshot.data ?? 0;
              return Text(
                widget.documentSnapshot['isSelected'] == true
                    ? "${widget.documentSnapshot['userName']}\n"
                        "Since : "
                        "${Utils.intToTimeLeft(timerValue)}"
                    : "",
                textAlign: TextAlign.center,
              );
            },
          ),
        ],
      ),
    );
  }

  setTimer() {
    if (widget.documentSnapshot['isSelected'] == true) {
      sinceInSec = 0;
      if (timer != null) timer!.cancel();
      DateTime startTime = widget.documentSnapshot['startTime'].toDate();
      sinceInSec = DateTime.now().difference(startTime).inSeconds;
      subjectTimer.add(sinceInSec);
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
        sinceInSec++;
        subjectTimer.add(sinceInSec);
      });
    } else {
      sinceInSec = 0;
      if (timer != null) timer!.cancel();
    }
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
