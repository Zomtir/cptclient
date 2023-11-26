import 'package:flutter/material.dart';

class AppButtonLightStyle extends ButtonStyle {
  const AppButtonLightStyle()
      : super(
          backgroundColor: const MaterialStatePropertyAll(Color(0x46FFC107)),
          shape: const MaterialStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(18)),
            ),
          ),
        );
}