import 'package:flutter/material.dart';

class NumberSelector extends StatelessWidget {
  final TextEditingController controller;
  final void Function(int) onChange;

  const NumberSelector({
    super.key,
    required this.controller,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: () => onChange(-1), icon: Icon(Icons.chevron_left)),
        SizedBox(
          width: 60,
          child: Focus(
            child: TextField(
              maxLines: 1,
              textAlign: TextAlign.center,
              controller: controller,
            ),
            onFocusChange: (hasFocus) {
              if (!hasFocus) onChange(0);
            },
          ),
        ),
        IconButton(onPressed: () => onChange(1), icon: Icon(Icons.chevron_right)),
      ],
    );
  }
}