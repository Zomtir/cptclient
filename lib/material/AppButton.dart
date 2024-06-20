import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Widget? leading;
  final VoidCallback? onPressed;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: leading,
      label: Text(text),
    );
  }
}