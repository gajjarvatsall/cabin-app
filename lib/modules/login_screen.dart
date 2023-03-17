import 'package:cabin_app/helper/google_firebase_helper.dart';
import 'package:cabin_app/widgets/elevated_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final weight = MediaQuery.of(context).size.width;
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('assets/images/login_screen_image.png'),
            SizedBox(
              height: height / 3,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: CustomElevatedButton(
                  onTap: () {
                    Future.delayed(Duration.zero, () {
                      GoogleAuthentication.googleSignIn(context);
                    });
                  },
                  text: "SignIn with Google",
                ))
          ],
        ),
      ),
    ));
  }
}
