import 'package:flutter/material.dart';

class AppSelectDecoration extends BoxDecoration {
  const AppSelectDecoration()
      : super(
          color: Colors.white,
          border: const Border.fromBorderSide(
            const BorderSide(color: Colors.amber, width: 2),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        );
}
