import 'package:flutter/material.dart';

class AppSearchField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onChanged;

  const AppSearchField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 1,
      controller: controller,
      onChanged: (text) => onChanged?.call(),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        suffixIcon: IconButton(
          onPressed: () {
            controller.clear();
            onChanged?.call();
          },
          icon: Icon(Icons.clear),
        ),
      ),
    );
  }
}
