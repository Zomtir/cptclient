import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:flutter/material.dart';

class NumberRangeDialog extends StatefulWidget {
  final RangeValues initialRange;
  final VoidCallback? onDelete;
  final VoidCallback? onReset;
  final Function(RangeValues)? onConfirm;

  NumberRangeDialog({
    super.key,
    required this.initialRange,
    this.onDelete,
    this.onReset,
    this.onConfirm,
  });

  @override
  State<NumberRangeDialog> createState() => NumberRangeDialogState();
}

class NumberRangeDialogState extends State<NumberRangeDialog> {
  RangeValues currentRange = RangeValues(0, 10);

  @override
  void initState() {
    super.initState();
    currentRange = widget.initialRange;
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      child: RangeSlider(
        values: currentRange,
        min: 0,
        max: 100,
        divisions: 10,
        onChanged: (RangeValues values) => setState(() => currentRange = values),
        labels: RangeLabels("${currentRange.start}", "${currentRange.end}"),
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
              widget.onConfirm?.call(currentRange);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}
