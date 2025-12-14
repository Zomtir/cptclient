import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/utils/message.dart';
import 'package:flutter/material.dart';

class TextEditDialog extends StatefulWidget {
  final String initialValue;
  final int minLength;
  final int maxLength;
  final int maxLines;
  final VoidCallback? onDelete;
  final VoidCallback? onReset;
  final Function(String)? onConfirm;

  TextEditDialog({
    super.key,
    required this.initialValue,
    required this.minLength,
    required this.maxLength,
    this.maxLines = 1,
    this.onDelete,
    this.onReset,
    this.onConfirm,
  }) {
    assert(
      (minLength <= maxLength),
      'minLength $minLength must be less or equal than maxLength $maxLength.',
    );
  }

  @override
  State<TextEditDialog> createState() => TextEditDialogState();
}

class TextEditDialogState extends State<TextEditDialog> {
  late String currentValue;
  final TextEditingController _ctrlText = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
    _ctrlText.text = currentValue;
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      child: ListTile(
        title: TextField(
          maxLines: widget.maxLines,
          controller: _ctrlText,
          onChanged: (String text) => currentValue = text,
        ),
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
              if (currentValue.length < widget.minLength) {
                messageText("Too short");
                return;
              }
              if (currentValue.length > widget.maxLength) {
                messageText("Too long");
                return;
              }

              widget.onConfirm?.call(currentValue.trim());
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}
