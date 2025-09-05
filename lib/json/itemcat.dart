import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/widgets/AppCard.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

class ItemCategory extends FieldInterface implements Comparable {
  final int id;
  String name;

  ItemCategory(this.id, this.name);

  ItemCategory.fromVoid() : id = 0, name = "";

  ItemCategory.fromJson(Map<String, dynamic> json) : id = json['id'], name = json['name'];

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  bool operator ==(other) => other is ItemCategory && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return removeDiacritics(name).compareTo(removeDiacritics(other.name));
  }

  @override
  get searchable {
    return [name];
  }

  @override
  Widget buildEntry(BuildContext context) {
    return Tooltip(message: "[$id]", child: Text("$name"));
  }

  @override
  Widget buildInfo(BuildContext context) {
    // TODO: implement buildEntry
    throw UnimplementedError();
  }

  @override
  Widget buildTile(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppTile(
      leading: Tooltip(message: "[$id]", child: Icon(Icons.inventory)),
      trailing: trailing,
      child: Text("$name"),
      onTap: onTap,
    );
  }

  @override
  Widget buildCard(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppCard(
      leading: Tooltip(message: "[$id]", child: Icon(Icons.inventory)),
      trailing: trailing,
      children: [Text("$name")],
    );
  }
}
