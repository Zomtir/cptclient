import 'package:cptclient/material/dialogs/TilePicker.dart';
import 'package:cptclient/material/fields/FieldController.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppField<T extends FieldInterface> extends StatelessWidget {
  final FieldController<T> controller;
  final void Function(T?) onChanged;

  const AppField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  void _handleSearch(BuildContext context) async {
    T? item = await showTilePicker<T>(
      context: context,
      items: await controller.callItems?.call() ?? [],
    );

    if (item == null) return;
    onChanged.call(item);
  }

  void _handleClear() {
    onChanged.call(null);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(controller.value?.toFieldString() ??
                AppLocalizations.of(context)!.undefined)),
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: _handleClear,
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => _handleSearch(context),
        ),
      ],
    );
  }
}
