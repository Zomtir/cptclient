import 'dart:core';
import 'package:cptclient/structs/SelectionData.dart';
import 'package:flutter/material.dart';
import 'package:cptclient/material/AppListView.dart';

class SearchablePanel<T> extends StatefulWidget {
  final SelectionData<T> dataModel;
  final Widget Function(T) builder;

  SearchablePanel({
    super.key,
    required this.dataModel,
    required this.builder,
  });

  @override
  SearchablePanelState createState() => SearchablePanelState<T>();
}

class SearchablePanelState<T> extends State<SearchablePanel<T>> {
  List<T> _items = [];
  final TextEditingController _ctrlFilter = TextEditingController();

  List<T> _getItems() {
    _items = List<T>.from(widget.dataModel.available.toSet().difference(widget.dataModel.selected.toSet()));
    _items = widget.dataModel.filter(_items, _ctrlFilter.text);
    return _items;
  }

  void _handleSelect(T item) {
    widget.dataModel.onSelect(item);
  }

  void _handleClear() {
    _ctrlFilter.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        TextField(
          autofocus: true,
          maxLines: 1,
          focusNode: FocusNode(),
          controller: _ctrlFilter,
          onChanged: (text) => setState(() {/* The filter will be applied during rebuild */}),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            suffixIcon: IconButton(
              onPressed: _handleClear,
              icon: Icon(Icons.clear),
            ),
          ),
        ),
        ListenableBuilder(
          listenable: widget.dataModel,
          builder: (BuildContext context, Widget? child) {
            return AppListView<T>(
              items: _getItems(),
              itemBuilder: (T item) {
                return InkWell(
                  onTap: () => _handleSelect(item),
                  child: widget.builder(item),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
