import 'package:flutter/material.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/TextFilter.dart';
import 'package:cptclient/material/AppListView.dart';
import '../AppDialog.dart';

void showTilePicker<T>({
  required BuildContext context,
  required List<T> available,
  List<T> hidden = const [],
  required Function(T) onSelect,
  required List<T> Function(List<T>, String) filter,
  required Widget Function(T) builder,
}) async {
  return showDialog(
    context: context,
    useSafeArea: false,
    builder: (BuildContext context) {
      return AppDialog(
        child: TilePicker(
          available: available,
          hidden: hidden,
          onSelect: onSelect,
          filter: filter,
          builder: builder,
        ),
      );
    },
  );
}

class TilePicker<T> extends StatefulWidget {
  final List<T> available;
  final List<T> hidden;
  final Function(T) onSelect;
  final List<T> Function(List<T>, String) filter;
  final Widget Function(T) builder;

  TilePicker({
    Key? key,
    required this.available,
    this.hidden = const [],
    required this.onSelect,
    required this.filter,
    required this.builder,
  }) : super(key: key);

  @override
  _TilePickerState createState() => new _TilePickerState<T>(onSelect: onSelect, filter: filter, builder: builder);
}

class _TilePickerState<T> extends State<TilePicker> {
  List<T> _visible = [];
  List<T> _limited = [];
  final Function(T) onSelect;
  final List<T> Function(List<T>, String) filter;
  final Widget Function(T) builder;

  TextEditingController _ctrlFilter = TextEditingController();

  _TilePickerState({
    required this.onSelect,
    required this.filter,
    required this.builder,
  });

  @override
  void initState() {
    super.initState();
    _visible = List<T>.from(widget.available.toSet().difference(widget.hidden.toSet()));
    _limitSelection(_visible);
  }

  void _handleSelect(T item) {
    _visible.remove(item);
    setState(() {
      _limited.remove(item);
    });
    onSelect(item);
  }

  void _limitSelection(List<T> items) {
    items.sort();
    setState(() {
      _limited = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        AppButton(text: "Close", onPressed: () => Navigator.pop(context)),
        TextFilter<T>(
          items: _visible,
          controller: _ctrlFilter,
          onChange: _limitSelection,
          filter: filter,
        ),
        AppListView<T>(
          items: _limited,
          itemBuilder: (T item) {
            return InkWell(
              child: Row(
                children: [
                  Expanded(child: builder(item)),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _handleSelect(item),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
