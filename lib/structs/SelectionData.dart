import 'package:flutter/material.dart';

class SelectionData<T> extends ChangeNotifier {
  List<T> _available;
  List<T> _selected;
  final Function(T) onSelect;
  final Function(T) onDeselect;
  final List<T> Function(List<T>, String) filter;

  SelectionData({
    required List<T> available,
    required List<T> selected,
    required this.onSelect,
    required this.onDeselect,
    required this.filter,
  }) : _available = available, _selected = selected;

  set available(List<T> newAvailable) {
    _available = newAvailable;
    notifyListeners();
  }

  List<T> get available{
    return _available;
  }

  set selected(List<T> newSelected) {
    _selected = newSelected;
    notifyListeners();
  }

  List<T> get selected {
    return _selected;
  }
}