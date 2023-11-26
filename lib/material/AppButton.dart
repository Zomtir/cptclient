import 'package:cptclient/material/design/AppButtonHeavyStyle.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback onPressed;
  final ButtonStyle style;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.leading,
    this.trailing,
    this.style = const AppButtonHeavyStyle(),
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
        style: style,
      ),
    );
  }
}