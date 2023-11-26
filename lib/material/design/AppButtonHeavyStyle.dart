import 'package:flutter/material.dart';

class AppButtonHeavyStyle extends ButtonStyle {
  const AppButtonHeavyStyle()
      : super(
          shape: const MaterialStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(18)),
            ),
          ),
        );
}
