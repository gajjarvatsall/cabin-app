import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthentication {
  static final auth = FirebaseAuth.instance;
  static final googleSignIn = GoogleSignIn();

  static Future<bool?> googleUserSignIn(BuildContext context) async {
    showDialog(
      useRootNavigator: false, //this property needs to be added
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      },
    );
    bool? result;
    try {
      final googleAccount = await googleSignIn.signIn();
      if (googleAccount!.email.contains("7span.com")) {
        final googleAuth = await googleAccount.authentication;
        final credential = GoogleAuthProvider.credential(idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
        UserCredential userCredential = await auth.signInWithCredential(credential);
        User? user = userCredential.user;

        if (user != null) {
          if (userCredential.additionalUserInfo?.isNewUser ?? true) {
            {
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(user.uid)
                  .set({"email": user.email, "name": user.displayName, "profilePic": user.photoURL});
              Navigator.of(context).pop();
            }
            result = true;
          }
        }
      } else {
        result = false;
        print("Wrong Email ID");
        googleSignIn.signOut();
        Navigator.of(context).pop();
      }
      return result ?? true;
    } catch (e) {
      print('exception $e');
      Navigator.of(context).pop();
      result = false;
    }
    return result;
  }

  static Future<void> googleUserSignOut(context) async {
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }
}
