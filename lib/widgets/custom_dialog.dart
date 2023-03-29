import 'package:cabin_app/utils/app_theme.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    this.onPressed,
  });

  final String title;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text(
            'Naa',
            style: AppTheme.titleText,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            'Haa',
            style: AppTheme.titleText,
          ),
        ),
      ],
    );
  }
}
