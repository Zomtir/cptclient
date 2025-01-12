import 'package:flutter/material.dart';

class AppInputDecoration extends InputDecoration {
  const AppInputDecoration({super.suffixIcon})
      : super(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Colors.amber, width: 2),
          ),
          isDense: true,
        );
}
