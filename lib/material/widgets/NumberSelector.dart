import 'package:flutter/material.dart';

class NumberSelector extends StatelessWidget {
  final Widget child;
  final void Function(int) onChange;

  const NumberSelector({
    super.key,
    required this.child,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => onChange(-1),
          icon: Icon(Icons.chevron_left),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
        child,
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
