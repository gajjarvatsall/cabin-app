import 'package:cabin_app/helper/google_firebase_helper.dart';
import 'package:cabin_app/utils/app_theme.dart';
import 'package:cabin_app/utils/constants.dart';
import 'package:cabin_app/widgets/elevated_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: AppConstants.height,
          ),
          CircleAvatar(
            minRadius: 70,
            backgroundColor: Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl: "${auth.currentUser!.photoURL}",
                fit: BoxFit.cover,
                height: 150,
                width: 150,
                alignment: Alignment.center,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(
            height: AppConstants.height,
          ),
          Center(
              child: Text(
            "${auth.currentUser?.displayName}",
            style: AppTheme.titleText,
          )),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomElevatedButton(
              onTap: () async {
                GoogleAuthentication.googleUserSignOut(context);
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
              text: ("Sign out"),
            ),
          ),
        ],
      ),
    );
  }
}
