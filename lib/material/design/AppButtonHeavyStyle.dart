import 'package:flutter/material.dart';

class AppButtonHeavyStyle extends ButtonStyle {
  const AppButtonHeavyStyle()
      : super(
          backgroundColor: const MaterialStatePropertyAll(Color(0xD1BE87)),
          shape: const MaterialStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
          ),
        );
}
