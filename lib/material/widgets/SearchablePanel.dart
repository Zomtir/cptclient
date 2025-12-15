import 'dart:core';

import 'package:cptclient/material/fields/AppSearchField.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:flutter/material.dart';

class SearchablePanel<T extends FieldInterface> extends StatefulWidget {
  final List<T> items;
  final void Function(T)? onTap;
  final List<Widget> Function(BuildContext, T)? actionBuilder;

  SearchablePanel({super.key, required this.items, this.onTap, this.actionBuilder});

  @override
  SearchablePanelState createState() => SearchablePanelState<T>();
}

class SearchablePanelState<T extends FieldInterface> extends State<SearchablePanel<T>> {
  List<T> _visible = [];
  final TextEditingController _ctrlFilter = TextEditingController();

  @override
  void initState() {
    super.initState();
    filter();
  }

  void filter() {
    if (_ctrlFilter.text.isEmpty) {
      _visible = widget.items;
    } else {
      _visible = widget.items.where((T item) => item.filter(_ctrlFilter.text)).toList();
    }

    setState(() => _visible.sort());
  }

  @override
  void didUpdateWidget(covariant SearchablePanel<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.items, widget.items)) {
      filter();
    }
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
