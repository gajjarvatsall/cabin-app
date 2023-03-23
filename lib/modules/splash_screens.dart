import 'package:cabin_app/widgets/elevated_button.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
          children: [
            Image.asset('assets/images/get_started_image.png'),
            SizedBox(
              height: height / 3,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: CustomElevatedButton(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  },
                  text: "Get started",
                ))
          ],
        ),
      ),
    ));
  }
}
