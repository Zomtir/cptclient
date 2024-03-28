import 'package:cptclient/material/dialogs/TilePicker.dart';
import 'package:cptclient/material/fields/FieldController.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppField<T extends FieldInterface> extends StatefulWidget {
  final FieldController<T> controller;
  final void Function(T?) onChanged;

  const AppField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  AppFieldState createState() => AppFieldState<T>();
}

class AppFieldState<T extends FieldInterface> extends State<AppField<T>> {
  List<T> _items = [];

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    List<T>? items = await widget.controller.callItems?.call();
    if (items == null) return;
    setState(() => _items = items);
  }

  void _handleSearch(BuildContext context) async {
    T? item = await showTilePicker<T>(
      context: context,
      items: _items,
    );

    widget.onChanged.call(item);
  }

  void _handleClear() {
    widget.onChanged.call(null);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(widget.controller.value?.toFieldString() ??
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
