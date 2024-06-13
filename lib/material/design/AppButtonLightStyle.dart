import 'package:flutter/material.dart';

class AppButtonLightStyle extends ButtonStyle {
  const AppButtonLightStyle()
      : super(
          //backgroundColor: const MaterialStatePropertyAll(Color(0x11F3ECD9)),
          shape: const WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
          ),
        );
}