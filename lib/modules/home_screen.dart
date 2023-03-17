import 'package:cabin_app/widgets/custom_cabin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cabin_app/widgets/drawer.dart';

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
      drawer: CustomDrawer(auth: auth, googleSignIn: googleSignIn),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 40),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              Text(
                "Left cabin",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: const [
                  CustomCabinContainer(number: "1"),
                  CustomCabinContainer(number: "2"),
                  CustomCabinContainer(number: "3"),
                  CustomCabinContainer(number: "4"),
                  CustomCabinContainer(number: "5"),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Right cabin",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: const [
                  CustomCabinContainer(number: "2"),
                  CustomCabinContainer(number: "3"),
                  CustomCabinContainer(number: "4"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
