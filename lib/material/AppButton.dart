import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback onPressed;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.leading,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) leading!,
            Text(text),
            if (trailing != null) trailing!,
          ],
        ),
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
            )
          )
        )
      ),
    );
  }
}