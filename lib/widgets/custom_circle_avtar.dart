import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  CustomCircleAvatar({
    super.key,
    required this.auth,
    required this.imgUrl,
  });

  final FirebaseAuth auth;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      minRadius: 0,
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: CachedNetworkImage(
          imageUrl: imgUrl,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorWidget: (context, url, error) => Image.asset(
            "assets/images/person.png",
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
