import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/material/dialogs/SelectionDialog.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppListView.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/extensions.dart';
import 'package:flutter/material.dart';

class SelectionPage<T extends FieldInterface> extends StatefulWidget {
  final String title;
  final Future<List<T>> Function() onCallAvailable;
  final Future<List<T>> Function() onCallSelected;
  final Future<bool> Function(T) onCallAdd;
  final Future<bool> Function(T) onCallRemove;

  SelectionPage({
    super.key,
    required this.title,
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
  List<T> _delta = [];

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
      _delta = _available.difference<T>(_selected);
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
          AppButton(
            text: AppLocalizations.of(context)!.actionAdd,
            onPressed: () => useAppDialog(
              context: context,
              child: SelectionDialog(
                title: widget.title,
                items: _delta,
                onConfirm: (List<T> values) async {
                  setState(() {
                    _selected.addAll(values);
                    _delta.removeWhere((T t) => values.any((e) => e == t));
                  });
                  for (var v in values) {
                    if (!await widget.onCallAdd(v)) return;
                  }
                  _update();
                },
              ),
            ),
          ),
          AppListView<T>(
            items: _selected,
            itemBuilder: (T item) {
              return item.buildTile(
                context,
                trailing: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
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
