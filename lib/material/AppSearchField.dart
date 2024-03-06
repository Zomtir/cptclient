import 'package:flutter/material.dart';

class AppSearchField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onChange;

  const AppSearchField({
    super.key,
    required this.controller,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 1,
      controller: controller,
      onChanged: (text) => onChange?.call(),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        suffixIcon: IconButton(
          onPressed: () {
            controller.clear();
            onChange?.call();
          },
          icon: Icon(Icons.clear),
        ),
      ),
    );
  }
}
