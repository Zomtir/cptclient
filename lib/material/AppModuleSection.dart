import 'package:flutter/material.dart';

class AppModuleSection extends StatelessWidget {
  final AssetImage image;
  final String text;

  const AppModuleSection({
    Key? key,
    required this.image,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          width: 45,
          alignment: Alignment.center,
          image: image,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

