import 'package:flutter/material.dart';

abstract class FieldInterface implements Comparable {
  const FieldInterface();

  // TODO
  Widget buildEntry(BuildContext context);
  Widget buildTile(BuildContext context);

  List<String> get searchable;

  bool filter(String filter) {
    Set<String> fragments = filter.toLowerCase().split(' ').toSet();

    for (String fragment in fragments) {
      bool matchedAny = false;
      for (String space in searchable) {
        matchedAny = matchedAny || space.toLowerCase().contains(fragment);
      }
      if (!matchedAny) return false;
    }

    return true;
  }
}