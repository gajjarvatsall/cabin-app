import 'package:cabin_app/widgets/cabin_list.dart';
import 'package:cabin_app/widgets/navigationbar.dart';
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 40),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomNavigation(width: width, height: height, auth: auth),
              CabinList(),
            ],
          ),
        ),
      ),
    );
  }
}
