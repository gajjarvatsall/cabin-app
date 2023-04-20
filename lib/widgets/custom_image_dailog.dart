import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  ImageDialog({
    required this.meme,
  });

  String? meme;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(image: ExactAssetImage(meme!), fit: BoxFit.fill),
        ),
      ),
    );
  }
}
