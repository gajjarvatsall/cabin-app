import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfiledPhoto extends StatelessWidget {
  ProfiledPhoto({
    super.key,
    required this.auth,
    required this.imgUrl,
    this.width,
    this.height,
    this.radius,
  });

  final FirebaseAuth auth;
  final String imgUrl;
  final double? width;
  final double? height;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius!),
      child: Image.network(
        imgUrl,
        width: width,
        height: height,
        fit: BoxFit.contain,
        alignment: Alignment.center,
        errorBuilder: (context, url, error) => Image.asset(
          "assets/images/person.png",
          fit: BoxFit.fill,
          width: width,
          height: height,
        ),
      ),
    );
  }
}
