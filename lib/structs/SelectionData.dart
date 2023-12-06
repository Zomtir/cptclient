import 'package:flutter/material.dart';

class SelectionData<T> extends ChangeNotifier {
  List<T> available;
  List<T> selected;
  final Function(T) onSelect;
  final Function(T) onDeselect;
  final List<T> Function(List<T>, String) filter;

  SelectionData({
    required this.available,
    required this.selected,
    required this.onSelect,
    required this.onDeselect,
    required this.filter,
  });
}