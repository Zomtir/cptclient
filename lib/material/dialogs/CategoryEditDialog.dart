import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/material/widgets/CategoryEdit.dart';
import 'package:cptclient/utils/message.dart';
import 'package:flutter/material.dart';

class CategoryEditDialog extends StatefulWidget {
  final String initialValue;
  final int maxLength;
  final VoidCallback? onDelete;
  final VoidCallback? onReset;
  final Function(String)? onConfirm;

  CategoryEditDialog({
    super.key,
    required this.initialValue,
    required this.maxLength,
    this.onDelete,
    this.onReset,
    this.onConfirm,
  });

  @override
  State<StatefulWidget> createState() => CategoryEditState();
}

class CategoryEditDialogState extends State<CategoryEditDialog> {
 late String currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      child: ListTile(
        title: CategoryEdit(
          text: currentValue,
          onChanged: (newValue) => setState(() => currentValue = newValue.trim()),
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
              if (currentValue.length > widget.maxLength) {
                messageText("Too long");
                return;
              }

              widget.onConfirm?.call(currentValue);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}
