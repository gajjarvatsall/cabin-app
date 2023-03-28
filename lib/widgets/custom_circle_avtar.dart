import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  CustomCircleAvatar({
    super.key,
    required this.auth,
    required this.imgUrl,
    this.width,
    this.height,
  });

  final FirebaseAuth auth;
  final String imgUrl;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: CachedNetworkImage(
          imageUrl: imgUrl,
          width: width,
          height: height,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorWidget: (context, url, error) => Image.asset(
            "assets/images/person.png",
            fit: BoxFit.cover,
            width: width,
            height: height,
          ),
        ),
      ),
    );
  }
}
