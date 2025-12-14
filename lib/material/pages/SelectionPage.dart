import 'package:cptclient/material/dialogs/SelectionDialog.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppListView.dart';
import 'package:cptclient/utils/extensions.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class SelectionPage<T extends FieldInterface> extends StatefulWidget {
  final String title;
  final Future<Result<List<T>>> Function() onCallAvailable;
  final Future<Result<List<T>>> Function() onCallSelected;
  final Future<Result> Function(T) onCallAdd;
  final Future<Result> Function(T) onCallRemove;

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
    Result<List<T>> result_available = await widget.onCallAvailable();
    Result<List<T>> result_selected = await widget.onCallSelected();

    setState(() {
      _available = result_available.unwrap();
      _available.sort();
      _selected = result_selected.unwrap();
      _selected.sort();
      _delta = _available.difference<T>(_selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => SelectionDialog(
                title: widget.title,
                items: _delta,
                onConfirm: (List<T> values) async {
                  setState(() {
                    _selected.addAll(values);
                    _delta.removeWhere((T t) => values.any((e) => e == t));
                  });
                  for (var v in values) {
                    if (await widget.onCallAdd(v) is! Success) return;
                  }
                  _update();
                },
              ),
            ),
          ),
        ],
      ),
      body: AppBody(
        children: [
          AppListView<T>(
            items: _selected,
            itemBuilder: (T item) {
              return item.buildTile(
                context,
                trailing: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    padding: EdgeInsets.all(2),
                    constraints: const BoxConstraints(),
                    onPressed: () async {
                      if (await widget.onCallRemove(item) is! Success) return;
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
