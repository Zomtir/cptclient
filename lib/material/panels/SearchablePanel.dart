import 'package:flutter/material.dart';
import 'package:cptclient/material/AppListView.dart';

class SearchablePanel<T> extends StatefulWidget {
  final List<T> available;
  final Function(T) onSelect;
  final List<T> Function(List<T>, String) filter;
  final Widget Function(T) builder;

  SearchablePanel({
    Key? key,
    required this.available,
    required this.onSelect,
    required this.filter,
    required this.builder,
  }) : super(key: key);

  @override
  _SearchablePanelState createState() => new _SearchablePanelState<T>();
}

class _SearchablePanelState<T> extends State<SearchablePanel<T>> {
  TextEditingController _ctrlFilter = TextEditingController();
  String _text = "";

  @override
  void initState() {
    super.initState();
  }

  void _handleSelect(T item) {
    widget.onSelect(item);
    setState(() => {});
  }

  void _handleChange(String text) {
    setState(() => _text = text);
  }

  void _handleClear() {
     _ctrlFilter.clear();
    setState(() => _text = "");
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
          onChanged: _handleChange,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            suffixIcon: IconButton(
              onPressed: _handleClear,
              icon: Icon(Icons.clear),
            ),
          ),
        ),
        AppListView<T>(
          items: widget.filter(widget.available, _text),
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
