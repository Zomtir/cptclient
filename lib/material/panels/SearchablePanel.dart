import 'dart:core';

import 'package:cptclient/material/fields/AppSearchField.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:flutter/material.dart';

class SearchablePanel<T extends FieldInterface> extends StatefulWidget {
  final List<T> items;
  final void Function(T)? onTap;

  SearchablePanel({super.key, this.items = const [], this.onTap});

  @override
  SearchablePanelState createState() => SearchablePanelState<T>();
}

class SearchablePanelState<T extends FieldInterface> extends State<SearchablePanel<T>> {
  List<T> _all = [];
  List<T> _visible = [];
  final TextEditingController _ctrlFilter = TextEditingController();

  @override
  void initState() {
    super.initState();
    _all = widget.items;
    update();
  }

  void setItems(List<T> items) {
    _all = items;
    _all.sort();
    update();
  }

  void update() {
    if (_ctrlFilter.text.isEmpty) {
      setState(() => _visible = _all);
      return;
    }

    List<T> visible = _all.where((T item) => item.filter(_ctrlFilter.text)).toList();
    visible.sort();

    setState(() => _visible = visible);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSearchField(controller: _ctrlFilter, onChanged: update),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _visible.length,
          itemBuilder: (context, index) =>
              _visible[index].buildTile(context, onTap: () => widget.onTap?.call(_visible[index])),
        ),
      ],
    );
  }
}
