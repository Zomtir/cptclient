import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/TileSelector.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppListView.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/extensions.dart';
import 'package:flutter/material.dart';

class SelectionPage<T extends FieldInterface> extends StatefulWidget {
  final String title;
  final Widget tile;
  final Future<List<T>> Function() onCallAvailable;
  final Future<List<T>> Function() onCallSelected;
  final Future<bool> Function(T) onCallAdd;
  final Future<bool> Function(T) onCallRemove;

  SelectionPage({
    super.key,
    required this.title,
    required this.tile,
    required this.onCallAvailable,
    required this.onCallSelected,
    required this.onCallAdd,
    required this.onCallRemove,
  });

  @override
  SelectionPageState createState() => SelectionPageState<T>();
}

class SelectionPageState<T extends FieldInterface> extends State<SelectionPage<T>> {
  List<T> _available = [];
  List<T> _selected = [];

  SelectionPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    List<T> available = await widget.onCallAvailable();
    available.sort();

    List<T> selected = await widget.onCallSelected();
    selected.sort();

    setState(() {
      _available = available;
      _selected = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: AppBody(
        children: [
          widget.tile,
          AppButton(
            text: AppLocalizations.of(context)!.actionAdd,
            onPressed: () => showTileSelector<T>(
              context: context,
              items: _available.difference<T>(_selected),
              builder: (T item, Function(T)? onSelect) {
                return Row(
                  children: [
                    Expanded(
                      child: item.buildTile(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        if (!await widget.onCallAdd(item)) return;
                        _update();
                        onSelect?.call(item);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          AppListView<T>(
            items: _selected,
            itemBuilder: (T item) {
              return Row(
                children: [
                  Expanded(
                    child: item.buildTile(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () async {
                      if (!await widget.onCallRemove(item)) return;
                      _update();
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
