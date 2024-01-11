import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final AssetImage image;
  final String text;
  final VoidCallback onPressed;

  const AppIconButton({
    super.key,
    required this.image,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              width: 75,
              alignment: Alignment.center,
              image: image,
            ),
            Text(text),
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}

