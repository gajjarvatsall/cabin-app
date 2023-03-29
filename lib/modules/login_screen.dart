import 'package:cabin_app/helper/google_firebase_helper.dart';
import 'package:cabin_app/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final padding = MediaQuery.of(context).padding;
    // const minWidth = ;
    return Scaffold(
        body: Center(
      child: Flex(
        direction: width < 700 ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(width: width / 2, child: Image.asset('assets/images/login_screen_image.png')),
          CustomElevatedButtonIcon(
            icon: const FaIcon(FontAwesomeIcons.google, color: Colors.black),
            onTap: () async {
              bool result = await GoogleAuthentication.googleUserSignIn(context);
              if (result) {
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              }
            },
            text: "SignIn with Google",
          )
        ],
      ),
    ));
  }
}
