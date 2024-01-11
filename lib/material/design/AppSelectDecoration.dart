import 'package:flutter/material.dart';

class AppSelectDecoration extends BoxDecoration {
  const AppSelectDecoration()
      : super(
          color: Colors.white,
          border: const Border.fromBorderSide(
            BorderSide(color: Colors.amber, width: 2),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        );
}
