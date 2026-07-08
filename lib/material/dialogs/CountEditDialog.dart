import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:flutter/material.dart';

class CountEditDialog extends StatefulWidget {
  final int initialValue;
  final int minValue;
  final VoidCallback? onDelete;
  final Function(int)? onConfirm;

  CountEditDialog({
    super.key,
    required this.initialValue,
    this.minValue = 0,
    this.onConfirm,
    this.onDelete,
  });

  @override
  State<CountEditDialog> createState() => CountEditDialogState();
}

class CountEditDialogState extends State<CountEditDialog> {
  late int currentValue;
  final TextEditingController _ctrlCount = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
    _ctrlCount.text = currentValue.toString();
  }

  void _handleChange(int delta) async {
    if (currentValue + delta < widget.minValue) return;
    setState(() {
      currentValue = currentValue + delta;
      _ctrlCount.text = currentValue.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      child: Column(
        children: [
          TextField(
            controller: _ctrlCount,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.labelAmount,
            ),
            onChanged: (String text) => setState(
              () => currentValue = int.tryParse(text) ?? widget.initialValue,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () => _handleChange(-1),
              ),
              Text("$currentValue"),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _handleChange(1),
              ),
            ],
          ),
        ],
      ),
      actions: [
        if (widget.onDelete != null && widget.minValue <= 0)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              widget.onDelete?.call();
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
