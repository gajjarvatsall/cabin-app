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
  late Duration since;

  getTime() {
    DateTime startTime = widget.documentSnapshot['startTime'].toDate();
    setState(() {
      since = DateTime.now().difference(startTime);
    });
    return since;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
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
        IconButton(
          onPressed: () {
            getTime();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text("Since ${since.inMinutes} Minutes"),
                );
              },
            );
          },
          icon: Icon(Icons.info, color: widget.documentSnapshot['isSelected'] == true ? Colors.white : Colors.black),
        ),
      ],
    );
  }
}
