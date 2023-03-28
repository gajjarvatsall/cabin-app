import 'package:cabin_app/helper/google_firebase_helper.dart';
import 'package:cabin_app/widgets/custom_circle_avtar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogoutPopup extends StatefulWidget {
  const LogoutPopup({Key? key}) : super(key: key);

  @override
  State<LogoutPopup> createState() => _LogoutPopupState();
}

class _LogoutPopupState extends State<LogoutPopup> {
  static final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: const EdgeInsets.all(30),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomCircleAvatar(
              auth: auth,
              imgUrl: '${auth.currentUser!.photoURL}',
            ),
            const SizedBox(
              width: 20,
            ),
            Text("${auth.currentUser!.displayName}")
          ],
        ),
        const SizedBox(
          // sized box with width 10
          height: 20,
        ),
        Row(
          children: [
            const Icon(Icons.logout_sharp),
            const SizedBox(
              // sized box with width 10
              width: 20,
            ),
            GestureDetector(
                onTap: () {
                  GoogleAuthentication.googleUserSignOut(context);
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
                child: const Text("Logout"))
          ],
        ),
      ],
      elevation: 2,
    );
  }
}
