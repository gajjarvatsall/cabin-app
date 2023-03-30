import 'package:cabin_app/utils/app_theme.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    required this.button1Title,
    required this.button2Title,
    this.onPressedPositive,
    this.onPressedNegative,
  });

  final String title;
  final String button1Title;
  final String button2Title;
  final void Function()? onPressedPositive;
  final void Function()? onPressedNegative;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
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
