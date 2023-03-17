import 'package:cabin_app/widgets/elevated_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.auth,
    required this.googleSignIn,
  });

  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          CircleAvatar(
            minRadius: 70,
            foregroundImage: NetworkImage('${auth.currentUser?.photoURL}'),
          ),
          const SizedBox(
            height: 50,
          ),
          Center(child: Text("${auth.currentUser?.displayName}")),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomElevatedButton(
                onTap: () {
                  googleSignIn.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                },
                text: ("Sign out")),
          ),
        ],
      ),
    );
  }
}
