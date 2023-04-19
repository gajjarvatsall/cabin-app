import 'package:cabin_app/helper/google_firebase_helper.dart';
import 'package:cabin_app/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: SvgPicture.asset(
                'assets/images/logo-grid-dark.svg',
                width: width / 17,
                height: height / 17,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 70),
            child: Flex(
              direction: width < 1000 ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset(
                  'assets/images/login_screen_image.svg',
                  width: width / 2,
                  height: height / 2,
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/cabin_cast_logo.png",
                        width: width / 5,
                        height: height / 5,
                      ),
                      CustomElevatedButtonIcon(
                        icon: const FaIcon(FontAwesomeIcons.google, color: Colors.black),
                        onTap: () async {
                          bool? result = await GoogleAuthentication.googleUserSignIn(context);
                          if (result != null && result == true) {
                            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("You can only login with 7Span Email ID"),
                              duration: Duration(seconds: 3),
                            ));
                          }
                        },
                        text: "SignIn with Google",
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
