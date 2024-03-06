import 'dart:core';

import 'package:cptclient/material/AppListView.dart';
import 'package:flutter/material.dart';

class SearchablePanel<T> extends StatefulWidget {
  final List<T> items;
  final Function(T)? onSelect;
  final List<T> Function(List<T>, String) filter;
  final Widget Function(T, Function(T)?) builder;

  SearchablePanel({
    super.key,
    required this.items,
    this.onSelect,
    required this.filter,
    required this.builder,
  });

  @override
  SearchablePanelState createState() => SearchablePanelState<T>();
}

class SearchablePanelState<T> extends State<SearchablePanel<T>> {
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
    setState(() => _visible = widget.filter(_all, _ctrlFilter.text));
  }

  void _handleClear() {
    setState(() {
      _ctrlFilter.clear();
      _visible = _all;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          maxLines: 1,
          controller: _ctrlFilter,
          onChanged: (text) => _update(),
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0)),
            suffixIcon: IconButton(
              onPressed: _handleClear,
              icon: Icon(Icons.clear),
            ),
          ),
        ),
        AppListView<T>(
          items: _visible,
          itemBuilder: (T item) => widget.builder(item, widget.onSelect),
        ),
      ],
    );
  }
}
