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
        IconButton(
          onPressed: () => onChange(-1),
          icon: Icon(Icons.chevron_left),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
        SizedBox(
          width: 60,
          child: Focus(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.center,
              maxLines: 1,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(0, 10, 2, 0),
              ),
            ),
            onFocusChange: (hasFocus) {
              if (!hasFocus) onChange(0);
            },
          ),
        ),
        IconButton(
          onPressed: () => onChange(1),
          icon: Icon(Icons.chevron_right),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
      ],
    );
  }
}
