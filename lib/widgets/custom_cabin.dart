import 'dart:async';

import 'package:cabin_app/utils/app_theme.dart';
import 'package:cabin_app/widgets/profiled_photo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CustomCabin extends StatefulWidget {
  const CustomCabin({
    super.key,
    required this.documentSnapshot,
  });

  final QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot;

  @override
  State<CustomCabin> createState() => _CustomCabinState();
}

class _CustomCabinState extends State<CustomCabin> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final BehaviorSubject<int> subjectTimer = BehaviorSubject();
  int sinceInSec = -1;
  Timer? timer;

  setTimer() {
    if (widget.documentSnapshot['isSelected'] == true) {
      if (timer?.isActive ?? false) {
        timer?.cancel();
      }
      DateTime startTime = widget.documentSnapshot['startTime'].toDate();
      sinceInSec = DateTime.now().difference(startTime).inSeconds;
      subjectTimer.add(sinceInSec);
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
        sinceInSec++;
        subjectTimer.add(sinceInSec);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
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
          ? Stack(
              alignment: Alignment.topRight,
              children: [
                ProfiledPhoto(
                  auth: auth,
                  imgUrl: widget.documentSnapshot['userPic'],
                  radius: 10,
                  width: width / 12,
                  height: width / 12,
                ),
                IconButton(
                  color: Colors.white,
                  onPressed: () {
                    setTimer();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("${widget.documentSnapshot['userName']}"),
                            StreamBuilder<int>(
                              stream: subjectTimer,
                              builder: (context, snapshot) {
                                int timerValue = snapshot.data ?? 0;
                                return Text("Since ${intToTimeLeft(timerValue)}");
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.remove_red_eye),
                ),
              ],
            )
          : Center(
              child: Text(
                "${widget.documentSnapshot['cabinName']}",
                style: AppTheme.titleText,
              ),
            ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
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
