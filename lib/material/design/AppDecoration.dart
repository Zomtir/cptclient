import 'package:flutter/material.dart';

class AppDecoration extends BoxDecoration {
  const AppDecoration()
      : super(
          color: Colors.white,
          border: const Border.fromBorderSide(
            const BorderSide(color: Colors.amber, width: 2),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(9)),
        );
}
