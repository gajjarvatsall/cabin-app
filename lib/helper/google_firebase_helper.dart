import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthentication {
  static final auth = FirebaseAuth.instance;
  static final googleSignIn = GoogleSignIn();

  static Future<bool> googleUserSignIn(context) async {
    bool result = false;
    try {
      final googleAccount = await googleSignIn.signIn();
      final googleAuth = await googleAccount?.authentication;
      final credential = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .set({
            "email": user.email,
            "name": user.displayName,
            "profilePic": user.photoURL
          });
        }
        result = true;
      }
      return result;
    } catch (e) {
      print(e);
    }
    return result;
  }

  static Future<void> googleUserSignOut(context) async {
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }
}
