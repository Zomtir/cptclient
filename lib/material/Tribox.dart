import 'package:flutter/material.dart';

class Tribox extends StatelessWidget {
  final bool? value;
  final void Function(bool?) onChanged;

  const Tribox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (value) {
      case null:
        return IconButton(onPressed: () => onChanged(true), icon: Icon(Icons.check_box_outline_blank));
      case true:
        return IconButton(onPressed: () => onChanged(false), icon: Icon(Icons.check_box_outlined));
      case false:
        return IconButton(onPressed: () => onChanged(null), icon: Icon(Icons.disabled_by_default_outlined));
    }
    throw Exception("Tribox: Not all trinary states were covered.") ;
  }

}
