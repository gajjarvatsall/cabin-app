import 'package:cabin_app/widgets/elevated_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          children: [
            const SizedBox(
              height: 50,
            ),
            CircleAvatar(
              minRadius: 100,
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
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(
            child: Text("Home Screen"),
          ),
        ],
      ),
    );
  }
}
