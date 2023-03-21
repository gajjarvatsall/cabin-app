import 'package:cabin_app/widgets/drawer.dart';
import 'package:cabin_app/widgets/left_cabin.dart';
import 'package:cabin_app/widgets/right_cabin.dart';
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Meeting Cabins"),
      ),
      drawer: const CustomDrawer(),
      body: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width / 40),
          child: Column(children: const [LeftCabin(), RightCabin()])),
    );
  }
}
