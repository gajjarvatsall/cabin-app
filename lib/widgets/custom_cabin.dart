import 'dart:async';

import 'package:cabin_app/utils/app_theme.dart';
import 'package:cabin_app/widgets/custom_circle_avtar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CustomCabin extends StatefulWidget {
  CustomCabin({
    super.key,
    required this.documentSnapshot,
  });

  QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot;

  @override
  State<CustomCabin> createState() => _CustomCabinState();
}

class _CustomCabinState extends State<CustomCabin> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final subjectTimer = BehaviorSubject<int>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setTimer();
    });
  }

  int sinceInSec = -1;

  setTimer() {
    if (widget.documentSnapshot['isSelected'] == true) {
      DateTime startTime = widget.documentSnapshot['startTime'].toDate();
      sinceInSec = DateTime.now().difference(startTime).inSeconds;
      subjectTimer.add(sinceInSec);
      Timer.periodic(Duration(seconds: 1), (Timer t) {
        sinceInSec++;
        subjectTimer.add(sinceInSec);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder<int>(
      stream: subjectTimer,
      builder: (context, snapshot) {
        int timerValue = snapshot.data ?? 0;
        return Tooltip(
          message: widget.documentSnapshot['isSelected'] == true
              ? "${widget.documentSnapshot['userName']}\n"
                  "Since : "
                  "${intToTimeLeft(timerValue)}"
              : "",
          child: Container(
            margin: const EdgeInsets.all(5),
            width: width / 12,
            height: width / 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: widget.documentSnapshot['isSelected'] == true ? 0 : 1,
                color: widget.documentSnapshot['isSelected'] == true ? Colors.transparent : Colors.green,
              ),
            ),
            child: widget.documentSnapshot['isSelected'] == true
                ? CustomCircleAvatar(
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
        );
      },
    );
  }

  String intToTimeLeft(int value) {
    int h, m, s;
    h = value ~/ 3600;
    m = ((value - h * 3600)) ~/ 60;
    s = value - (h * 3600) - (m * 60);
    String hourLeft = h.toString().length < 2 ? "0" + h.toString() : h.toString();
    String minuteLeft = m.toString().length < 2 ? "0" + m.toString() : m.toString();
    String secondsLeft = s.toString().length < 2 ? "0" + s.toString() : s.toString();
    String result = "$hourLeft:$minuteLeft:$secondsLeft";
    return result;
  }
}
