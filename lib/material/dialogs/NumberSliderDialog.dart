import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:flutter/material.dart';

class NumberSliderDialog extends StatefulWidget {
  final int initialValue;
  final int min;
  final int max;
  final VoidCallback? onDelete;
  final VoidCallback? onReset;
  final Function(int)? onConfirm;

  NumberSliderDialog({
    super.key,
    required this.initialValue,
    required this.min,
    required this.max,
    this.onDelete,
    this.onReset,
    this.onConfirm,
  }) {
    assert(
      (min <= max),
      'minLength $min must be less or equal than maxLength $max.',
    );
  }

  @override
  State<NumberSliderDialog> createState() => NumberSliderDialogState();
}

class NumberSliderDialogState extends State<NumberSliderDialog> {
  late int currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      child: Slider(
        value: currentValue.toDouble(),
        min: widget.min.toDouble(),
        max: widget.max.toDouble(),
        divisions: () {
          int div = widget.max - widget.min;
          div = div < 1 ? 1 : div;
          return div;
        }.call(),
        onChanged: (double value) => currentValue = value.toInt(),
        label: "$currentValue",
      ),
      actions: [
        if (widget.onDelete != null)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              widget.onDelete?.call();
              Navigator.pop(context);
            },
          ),
        if (widget.onReset != null)
          IconButton(
            icon: const Icon(Icons.circle_outlined),
            onPressed: () {
              widget.onReset?.call();
              Navigator.pop(context);
            },
          ),
        if (widget.onConfirm != null)
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              widget.onConfirm?.call(currentValue);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}
