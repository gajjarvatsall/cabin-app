import 'package:cabin_app/helper/google_firebase_helper.dart';
import 'package:cabin_app/utils/app_theme.dart';
import 'package:cabin_app/widgets/custom_dialog.dart';
import 'package:cabin_app/widgets/custom_image_dailog.dart';
import 'package:cabin_app/widgets/profiled_Img.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomNavigation extends StatelessWidget {
  const CustomNavigation({
    super.key,
    required this.width,
    required this.height,
    required this.auth,
  });

  final double width;
  final double height;
  final FirebaseAuth auth;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/logo-grid-dark.svg',
          width: width / 17,
          height: height / 17,
          fit: BoxFit.cover,
        ),
        Flexible(
          child: Text(
            "Welcome to CABIN CAST",
            textAlign: TextAlign.center,
            style: AppTheme.titleText.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
          onTap: () async {
            QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('cabins').get();
            List<String> fieldValues = [];
            querySnapshot.docs.forEach((doc) {
              fieldValues.add(doc.data()['userId']);
            });
            if (fieldValues.contains(auth.currentUser!.uid)) {
              showDialog(
                barrierDismissible: true,
                context: context,
                builder: (_) {
                  Future.delayed(const Duration(seconds: 4), () {
                    Navigator.of(context).pop(true);
                  });
                  return ImageDialog(
                    meme: 'assets/images/meme-5.png',
                  );
                },
              );
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return CustomDialog(
                    meme: 'assets/images/meme-3.png',
                    onPressedPositive: () async {
                      GoogleAuthentication.googleUserSignOut(context);
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    },
                    onPressedNegative: () => Navigator.pop(context),
                    button1Title: 'Cancel',
                    button2Title: 'Ok',
                  );
                },
              );
            }
          },
          child: SizedBox(
            height: 50,
            width: 50,
            child: ProfiledPhoto(
              auth: auth,
              imgUrl: "${auth.currentUser!.photoURL}",
              radius: 100,
            ),
          ),
        ),
      ],
    );
  }
}
