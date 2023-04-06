import 'package:cabin_app/utils/app_theme.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.button1Title,
    required this.button2Title,
    required this.meme,
    this.onPressedPositive,
    this.onPressedNegative,
  });

  final String button1Title;
  final String button2Title;
  final String meme;
  final void Function()? onPressedPositive;
  final void Function()? onPressedNegative;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: Image.asset(
          meme,
          width: 350,
          height: 200,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onPressedNegative,
          child: Text(
            button1Title,
            style: AppTheme.titleText,
          ),
        ),
        TextButton(
          onPressed: onPressedPositive,
          child: Text(
            button2Title,
            style: AppTheme.titleText,
          ),
        ),
      ],
    );
  }
}
