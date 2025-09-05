import 'package:flutter/material.dart';

abstract class FieldInterface implements Comparable {
  const FieldInterface();

  Widget buildEntry(BuildContext context);
  Widget buildInfo(BuildContext context);
  Widget buildTile(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap});
  Widget buildCard(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap});

  List<String?> get searchable;

  bool filter(String filter) {
    Set<String> fragments = filter.toLowerCase().split(' ').toSet();

    for (String fragment in fragments) {
      bool matchedAny = false;
      for (String? space in searchable) {
        matchedAny = matchedAny || (space?.toLowerCase().contains(fragment) ?? false);
      }
      if (!matchedAny) return false;
    }

    return true;
  }
}