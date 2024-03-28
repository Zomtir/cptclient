import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/dialogs/TileSelector.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/static/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectionPage<T extends FieldInterface> extends StatefulWidget {
  final Session session;
  final String title;
  final Widget tile;
  final Future<List<T>> Function(Session) onCallAvailable;
  final Future<List<T>> Function(Session) onCallSelected;
  final Future<bool> Function(Session, T) onCallAdd;
  final Future<bool> Function(Session, T) onCallRemove;

  SelectionPage({
    super.key,
    required this.session,
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
    List<T> available = await widget.onCallAvailable(widget.session);
    available.sort();

    List<T> selected = await widget.onCallSelected(widget.session);
    selected.sort();

    setState(() {
      _available = available;
      _selected = selected;
    });
  }

  void _add(T item) async {
    if (!await widget.onCallAdd(widget.session, item)) return;
    _update();
  }

  void _remove(T item) async {
    if (!await widget.onCallRemove(widget.session, item)) return;
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
              items: this._available.difference<T>(this._selected),
              builder: (T item, Function(T)? onSelect) {
                return Row(
                  children: [
                    Expanded(
                      child: item.buildTile(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {onSelect?.call(item); this._add(item);},
                    ),
                  ],
                );
              },
            ),
          ),
          AppListView<T>(
            items: this._selected,
            itemBuilder: (T item) {
              return Row(
                children: [
                  Expanded(
                    child: item.buildTile(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => this._remove(item),
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
