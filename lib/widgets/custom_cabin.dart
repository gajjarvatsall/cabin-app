import 'package:cabin_app/utils/app_theme.dart';
import 'package:cabin_app/widgets/custom_circle_avtar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomCabin extends StatelessWidget {
  CustomCabin({
    super.key,
    required this.documentSnapshot,
  });

  QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final FirebaseAuth auth = FirebaseAuth.instance;
    return Tooltip(
      message: documentSnapshot['isSelected'] == true ? "${documentSnapshot['userName']}" : "",
      child: Container(
        margin: const EdgeInsets.all(5),
        width: width / 12,
        height: width / 12,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: documentSnapshot['isSelected'] == true ? Colors.red.shade400 : Colors.white,
            border: Border.all(
              width: 3,
              color: documentSnapshot['isSelected'] == true ? Colors.red.shade400 : Colors.green,
            )),
        child: documentSnapshot['isSelected'] == true
            ? CustomCircleAvatar(auth: auth, imgUrl: documentSnapshot['userPic'])
            : Center(
                child: Text(
                  "${documentSnapshot['cabinName']}",
                  style: AppTheme.titleText,
                ),
              ),
      ),
    );
  }
}
