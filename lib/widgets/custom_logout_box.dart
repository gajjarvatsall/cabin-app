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
      content: const Text("Are you sure want to Logout?"),
      actions: [
        Row(
          children: [
            const Icon(Icons.logout_sharp),
            const SizedBox(
              // sized box with width 10
              width: 20,
            ),
          ],
        ),
      ],
      elevation: 2,
    );
  }
}
