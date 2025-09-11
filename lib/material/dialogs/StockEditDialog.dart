import 'package:cptclient/json/stock.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:flutter/material.dart';

class StockEditDialog extends StatefulWidget {
  final Stock initialValue;
  final VoidCallback? onDelete;
  final Function(Stock)? onConfirm;

  StockEditDialog({
    super.key,
    required this.initialValue,
    this.onConfirm,
    this.onDelete,
  });

  @override
  State<StockEditDialog> createState() => StockEditDialogState();
}

class StockEditDialogState extends State<StockEditDialog> {
  late Stock currentValue;
  final TextEditingController _ctrlStorage = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
    _ctrlStorage.text = currentValue.storage;
  }

  void _handleChange(int delta) async {
    int overhead = currentValue.owned - currentValue.loaned;
    if (overhead + delta < 0) return;

    setState(() => currentValue.owned = currentValue.owned + delta);
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      child: Column(
        children: [
          ListTile(
            title: TextField(
              controller: _ctrlStorage,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.stockStorage,
              ),
              onChanged: (String text) => currentValue.storage = text,
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                widget.onDelete?.call();
                Navigator.pop(context);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () => _handleChange(-1),
              ),
              Text("${currentValue.owned}"),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _handleChange(1),
              ),
            ],
          ),
        ],
      ),
      actions: [
        if (widget.onDelete != null)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              if (currentValue.loaned > 0) return;
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
