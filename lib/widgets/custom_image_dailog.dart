import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        height: 200,
        decoration:
            const BoxDecoration(image: DecorationImage(image: ExactAssetImage('assets/images/person.png'), fit: BoxFit.cover)),
      ),
    );
  }
}
