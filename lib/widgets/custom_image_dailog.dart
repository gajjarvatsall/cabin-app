import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 250,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(image: ExactAssetImage('assets/images/meme-1.png'), fit: BoxFit.fill),
        ),
      ),
    );
  }
}
