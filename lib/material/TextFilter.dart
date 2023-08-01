import 'package:flutter/material.dart';

class TextFilter<T> extends StatelessWidget {
  final List<T> items;
  final TextEditingController controller;
  final Function(List<T>) onChange;
  final List<T> Function(List<T>, String) filter;

  const TextFilter({
    Key? key,
    required this.items,
    required this.controller,
    required this.onChange,
    required this.filter,
  }) : super(key: key);

  void _filter(String text) {
    onChange(filter(items, text));
  }

  void _unfilter() {
    onChange(items);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      maxLines: 1,
      focusNode: FocusNode(),
      controller: controller,
      onChanged: _filter,
      decoration: InputDecoration(
        hintText: "Find entry",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        suffixIcon: IconButton(
          onPressed: _unfilter,
          icon: Icon(Icons.clear),
        ),
      ),
    );
  }

}