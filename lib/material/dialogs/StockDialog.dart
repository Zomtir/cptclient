import 'package:cptclient/json/stock.dart';
import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<Stock?> showStockDialog({
  required BuildContext context,
  required Stock stock,
  required Future<bool> Function(Stock) callCreate,
  required Future<bool> Function(Stock) callEdit,
  required Future<bool> Function(Stock) callDelete,
  bool isDraft = false,
}) async {
  return showDialog<Stock>(
    context: context,
    useSafeArea: false,
    builder: (BuildContext context) {
      return AppDialog(
        child: StockDialog(
          stock: stock,
          callCreate: callCreate,
          callEdit: callEdit,
          callDelete: callDelete,
          isDraft: isDraft,
        ),
        maxWidth: 470,
      );
    },
  );
}

class StockDialog extends StatefulWidget {
  StockDialog({
    super.key,
    required this.stock,
    required this.callCreate,
    required this.callEdit,
    required this.callDelete,
    required this.isDraft,
  });

  final Stock stock;
  final Future<bool> Function(Stock) callCreate;
  final Future<bool> Function(Stock) callEdit;
  final Future<bool> Function(Stock) callDelete;
  final bool isDraft;

  @override
  State<StockDialog> createState() => _StockDialogState();
}

class _StockDialogState extends State<StockDialog> {
  final TextEditingController _ctrlStorage = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctrlStorage.text = widget.stock.storage;
  }

  void _handleChange(int delta) async {
    int overhead = widget.stock.owned - widget.stock.loaned;
    if (overhead + delta < 0) return;

    setState(() => widget.stock.owned = widget.stock.owned + delta);
  }

  void _handleDelete() async {
    if (widget.stock.loaned > 0) return;

    await widget.callCreate(widget.stock);

    Navigator.pop(context, widget.stock);
  }

  void _handleConfirm() async {
    bool success = (widget.isDraft ? await widget.callCreate(widget.stock) : await widget.callEdit(widget.stock));
    if (!success) return;

    Navigator.pop(context, widget.stock);
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: TextField(
            controller: _ctrlStorage,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.stockStorage,
            ),
            onChanged: (String text) => widget.stock.storage = text,
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _handleDelete(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () => _handleChange(-1),
            ),
            Text("${widget.stock.owned}"),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _handleChange(1),
            ),
          ],
        ),
        Container(
          alignment: AlignmentDirectional.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: <Widget>[
              AppButton(
                onPressed: _handleCancel,
                text: AppLocalizations.of(context)!.actionCancel,
              ),
              Spacer(),
              AppButton(
                onPressed: _handleConfirm,
                text: AppLocalizations.of(context)!.actionConfirm,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
