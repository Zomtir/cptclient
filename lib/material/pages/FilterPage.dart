import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/TileSelector.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppListView.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/extensions.dart';
import 'package:flutter/material.dart';

class FilterPage<T extends FieldInterface> extends StatefulWidget {
  final String title;
  final Widget tile;
  final Future<List<T>> Function() onCallAvailable;
  final Future<List<(T,bool)>> Function() onCallSelected;
  final Future<bool> Function(T, bool) onCallEdit;
  final Future<bool> Function(T) onCallRemove;

  FilterPage({
    super.key,
    required this.title,
    required this.tile,
    required this.onCallAvailable,
    required this.onCallSelected,
    required this.onCallEdit,
    required this.onCallRemove,
  });

  @override
  FilterPageState createState() => FilterPageState<T>();
}

class FilterPageState<T extends FieldInterface> extends State<FilterPage<T>> {
  List<T> _available = [];
  List<(T,bool)> _selected = [];

  FilterPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    List<T> available = await widget.onCallAvailable();
    available.sort();

    List<(T,bool)> selected = await widget.onCallSelected();
    selected.sort((a,b) => a.$1.compareTo(b.$1));

    setState(() {
      _available = available;
      _selected = selected;
    });
  }

  void _edit(T item, bool access) async {
    if (!await widget.onCallEdit(item, access)) return;
    _update();
  }

  void _remove(T item) async {
    if (!await widget.onCallRemove(item)) return;
    _update();
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
              items: _available.difference<T>(_selected.map((tuple) => tuple.$1).toList()),
              builder: (T item, Function(T)? onSelect) {
                return Row(
                  children: [
                    Expanded(
                      child: item.buildTile(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.block),
                      onPressed: () {onSelect?.call(item); _edit(item, false);},
                    ),
                    IconButton(
                      icon: const Icon(Icons.light_mode_outlined),
                      onPressed: () {onSelect?.call(item); _edit(item, true);},
                    ),
                  ],
                );
              },
            ),
          ),
          AppListView<(T,bool)>(
            items: _selected,
            itemBuilder: ((T,bool) item) {
              return Row(
                children: [
                  Expanded(
                    child: item.$1.buildTile(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _remove(item.$1),
                  ),
                  IconButton(
                    icon: const Icon(Icons.block),
                    onPressed: (item.$2 == true) ? () => _edit(item.$1, false) : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.light_mode_outlined),
                    onPressed: (item.$2 == false) ? () => _edit(item.$1, true) : null,
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
