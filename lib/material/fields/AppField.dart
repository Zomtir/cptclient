import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/PickerDialog.dart';
import 'package:cptclient/material/fields/FieldController.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:flutter/material.dart';

class AppField<T extends FieldInterface> extends StatelessWidget {
  final FieldController<T> controller;
  final void Function(T?) onChanged;

  const AppField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  void _handleSearch(BuildContext context) async {
    List<T>? items = await controller.callItems?.call() ?? []; // TODO Result
    await showDialog(
      context: context,
      builder: (context) => PickerDialog(
        items: items,
        onPick: (item) => onChanged.call(item),
      ),
    );
  }

  void _handleClear() {
    onChanged.call(null);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: controller.value?.buildEntry(context) ?? Text(AppLocalizations.of(context)!.undefined),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _handleSearch(context),
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: _handleClear,
          ),
        ],
      ),
    );
  }
}
