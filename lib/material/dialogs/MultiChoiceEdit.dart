import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:flutter/material.dart';

class MultiChoiceEdit<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final Widget Function(T) builder;
  final VoidCallback? onDelete;
  final VoidCallback? onReset;
  final Function(T)? onConfirm;

  MultiChoiceEdit({
    super.key,
    required this.items,
    required this.value,
    required this.builder,
    this.onDelete,
    this.onReset,
    this.onConfirm,
  });

  @override
  State<MultiChoiceEdit<T>> createState() => MultiChoiceEditState<T>();
}

class MultiChoiceEditState<T> extends State<MultiChoiceEdit<T>> {
  late T value;

  @override
  void initState() {
    super.initState();
    value = widget.value ?? widget.items.first;
  }

  @override
  Widget build(BuildContext context) {
    Widget radioGroup = RadioGroup<T>(
      groupValue: value,
      onChanged: (T? v) => setState(() => value = v as T),
      child: Column(
        children: widget.items
            .map(
              (i) => ListTile(
                title: widget.builder(i),
                leading: Radio<T>(
                  value: i,
                ),
              ),
            )
            .toList(),
      ),
    );

    return AppDialog(
      child: radioGroup,
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
              widget.onConfirm?.call(value);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}
