import 'package:flutter/material.dart';

abstract class FieldInterface {
  String toFieldString();

  Widget buildTile();

  get searchable;

  bool filter(String filter) {
    Set<String> fragments = filter.toLowerCase().split(' ').toSet();

    for (var fragment in fragments) {
      bool matchedAny = false;
      for (var space in searchable) {
        matchedAny = matchedAny || space.toLowerCase().contains(fragment);
      }
      if (!matchedAny) return false;
    }

    return true;
  }
}