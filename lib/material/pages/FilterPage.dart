import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/FilterDialog.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppListView.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/extensions.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class FilterPage<T extends FieldInterface> extends StatefulWidget {
  final String title;
  final Future<Result<List<T>>> Function() onCallAvailable;
  final Future<Result<List<(T, bool)>>> Function() onCallSelected;
  final Future<Result> Function(T, bool) onCallEdit;
  final Future<Result> Function(T) onCallRemove;

  FilterPage({
    super.key,
    required this.title,
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
  List<(T, bool)> _selected = [];
  List<T> _delta = [];

  FilterPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    Result<List<T>> result_available = await widget.onCallAvailable();
    Result<List<(T, bool)>> result_selected = await widget.onCallSelected();

    setState(() {
      _available = result_available.unwrap();
      _available.sort();
      _selected = result_selected.unwrap();
      _selected.sort((a, b) => a.$1.compareTo(b.$1));
      _delta = _available.difference<T>(_selected.map((tuple) => tuple.$1).toList());
    });
  }

  void _edit(T item, bool access) async {
    if (await widget.onCallEdit(item, access) is! Success) return;
    _update();
  }

  void _remove(T item) async {
    if (await widget.onCallRemove(item) is! Success) return;
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
          AppButton(
            text: AppLocalizations.of(context)!.actionAdd,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => FilterDialog(
                title: widget.title,
                items: _delta,
                onConfirm: (List<(T, bool)> values) {
                  setState(() {
                    _selected.addAll(values);
                    _delta.removeWhere((T t) => values.any((e) => e.$1 == t));
                  });
                  for (var v in values) {
                    _edit(v.$1, v.$2);
                  }
                },
              ),
            ),
          ),
          AppListView<(T, bool)>(
            items: _selected,
            itemBuilder: ((T, bool) item) {
              return item.$1.buildTile(
                context,
                trailing: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    padding: EdgeInsets.all(2),
                    constraints: const BoxConstraints(),
                    onPressed: () => _remove(item.$1),
                  ),
                  IconButton(
                    icon: const Icon(Icons.block),
                    color: Theme.of(context).disabledColor,
                    padding: EdgeInsets.all(2),
                    constraints: const BoxConstraints(),
                    disabledColor: Colors.black87,
                    onPressed: (item.$2 == true) ? () => _edit(item.$1, false) : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.check_circle_outline),
                    color: Theme.of(context).disabledColor,
                    padding: EdgeInsets.all(2),
                    constraints: const BoxConstraints(),
                    disabledColor: Colors.black87,
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
