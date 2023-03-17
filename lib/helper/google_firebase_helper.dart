import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final auth = FirebaseAuth.instance;

class GoogleAuthentication {
  static Future<void> googleSignIn(context) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          await auth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken),
          );
          await saveUser(googleAccount);
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } finally {}
      }
    }
  }
}

Future<void> saveUser(GoogleSignInAccount account) async {
  FirebaseFirestore.instance.collection("users").doc().set({
    "email": account.email,
    "name": account.displayName,
    "profilePic": account.photoUrl
  });
}
