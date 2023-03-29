import 'package:flutter/material.dart';

class CustomElevatedButtonIcon extends StatelessWidget {
  CustomElevatedButtonIcon({super.key, required this.onTap, required this.text, required this.icon});

  String text;
  Function onTap;
  var icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: icon,
      onPressed: () => onTap(),
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
        minimumSize: MaterialStateProperty.all(
            Size(MediaQuery.of(context).size.width / 6, MediaQuery.of(context).size.height / 12)),
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: const BorderSide(
              color: Colors.black,
            ),
          ),
        ),
      ),
      label: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: const TextStyle(fontSize: 17, color: Colors.black),
        ),
      ),
    );
  }
}
