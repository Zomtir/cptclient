import 'package:flutter/material.dart';
import 'package:cptclient/material/AppListView.dart';

class SearchablePanel<T> extends StatefulWidget {
  final List<T> items;
  final Function(T) onSelect;
  final List<T> Function(List<T>, String) filter;
  final Widget Function(T) builder;

  SearchablePanel({
    Key? key,
    required this.items,
    required this.onSelect,
    required this.filter,
    required this.builder,
  }) : super(key: key);

  @override
  SearchablePanelState createState() => new SearchablePanelState<T>();
}

class SearchablePanelState<T> extends State<SearchablePanel<T>> {
  List<T> _items = [];
  List<T> _filtered = [];
  TextEditingController _ctrlFilter = TextEditingController();

  @override
  void initState() {
    super.initState();
    _items = widget.items;
    _update();
  }

  void setItems(List<T> items) {
    _items = items;
    print("Child call");
    print(_items.length);
    _update();
  }

  void _update() {
    setState(() => _filtered = widget.filter(_items, _ctrlFilter.text));
  }

  void _handleSelect(T item) {
      widget.onSelect(item);
  }

  void _handleClear() {
     _ctrlFilter.clear();
     _update();
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
          onChanged: (text) => _update(),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            suffixIcon: IconButton(
              onPressed: _handleClear,
              icon: Icon(Icons.clear),
            ),
          ),
        ),
        AppListView<T>(
          items: _filtered,
          itemBuilder: (T item) {
            return InkWell(
              onTap: () => _handleSelect(item),
              child: widget.builder(item),
            );
          },
        ),
      ],
    );
  }
}
