import 'package:flutter/material.dart';

class AppButtonHeavyStyle extends ButtonStyle {
  const AppButtonHeavyStyle()
      : super(
          backgroundColor: const WidgetStatePropertyAll(Color(0xD1BE87)),
          shape: const WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
          ),
        );
}
