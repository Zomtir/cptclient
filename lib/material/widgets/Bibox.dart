import 'package:flutter/material.dart';

class Bibox extends StatelessWidget {
  final bool value;
  final void Function(bool) onChanged;

  const Bibox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (value) {
      case true:
        return IconButton(onPressed: () => onChanged(false), icon: Icon(Icons.check_box_outlined));
      case false:
        return IconButton(onPressed: () => onChanged(true), icon: Icon(Icons.disabled_by_default_outlined));
    }
  }

}
