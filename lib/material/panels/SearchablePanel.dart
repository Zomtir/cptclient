import 'dart:core';

import 'package:cptclient/material/fields/AppSearchField.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:flutter/material.dart';

class SearchablePanel<T extends FieldInterface> extends StatefulWidget {
  final List<T> items;
  final void Function(T)? onTap;
  final List<Widget> Function(BuildContext, T)? actionBuilder;

  SearchablePanel({super.key, this.items = const [], this.onTap, this.actionBuilder});

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
    update(widget.items);
  }

  void update(List<T> items) {
    _all = List.of(items)..sort();
    setState(() => _visible = _all);
  }

  void filter() {
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
        AppSearchField(controller: _ctrlFilter, onChanged: filter),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _visible.length,
          itemBuilder: (context, index) => _visible[index].buildTile(
            context,
            onTap: widget.onTap == null ? null : () => widget.onTap!.call(_visible[index]),
            trailing: widget.actionBuilder?.call(context, _visible[index]),
          ),
        ),
      ],
    );
  }
}
