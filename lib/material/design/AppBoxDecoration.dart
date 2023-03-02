import 'package:flutter/material.dart';

class AppBoxDecoration extends BoxDecoration {
  const AppBoxDecoration()
      : super(
          color: Colors.white,
          border: const Border.fromBorderSide(
            const BorderSide(color: Colors.amber, width: 2),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(9)),
        );
}
