import 'dart:core';

import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/fields/AppSearchField.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:flutter/material.dart';

class SearchablePanel<T extends FieldInterface> extends StatefulWidget {
  final List<T> items;
  final Function(T)? onSelect;
  final Widget Function(T, Function(T)?) builder;

  SearchablePanel({
    super.key,
    required this.items,
    this.onSelect,
    required this.builder,
  });

  @override
  SearchablePanelState createState() => SearchablePanelState<T>();
}

class SearchablePanelState<T extends FieldInterface>
    extends State<SearchablePanel<T>> {
  List<T> _all = [];
  List<T> _visible = [];
  final TextEditingController _ctrlFilter = TextEditingController();

  @override
  void initState() {
    super.initState();
    _all = widget.items;
    _update();
  }

  void _update() {
    if (_ctrlFilter.text.isEmpty) {
      setState(() => _visible = _all);
      return;
    }

    setState(() => _visible =
        _all.where((T item) => item.filter(_ctrlFilter.text)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSearchField(
          controller: _ctrlFilter,
          onChanged: _update,
        ),
        AppListView<T>(
          items: _visible,
          itemBuilder: (T item) => widget.builder(item, (item) {
            widget.onSelect?.call(item);
            _update();
          }),
        ),
      ],
    );
  }
}
