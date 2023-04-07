import 'package:cabin_app/utils/app_theme.dart';
import 'package:cabin_app/widgets/custom_circle_avtar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
              children: [
                CustomCircleAvatar(
                  auth: auth,
                  imgUrl: widget.documentSnapshot['userPic'],
                  radius: 10,
                ),
                IconButton(
                  onPressed: () {
                    DateTime startTime = widget.documentSnapshot['startTime'].toDate();
                    Duration duration = DateTime.now().difference(startTime);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("${widget.documentSnapshot['userName']}"),
                            Text("Since ${duration.inMinutes} Minutes"),
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
