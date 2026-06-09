// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/widgets/AppCard.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

class Discipline extends FieldInterface implements Comparable {
  final int id;
  String name;

  Discipline(this.id, this.name);

  Discipline.fromVoid() : id = 0, name = "";

  Discipline.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'];

  Map<String, dynamic> toJson() => {'id': id, 'name': name,};

  @override
  bool operator ==(other) => other is Discipline && id == other.id;

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
    return Text("$name");
  }

  @override
  Widget buildTile(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppTile(
      leading: Tooltip(message: "[$id]", child: Icon(Icons.sports_football)),
      trailing: trailing,
      child: Column(
        children: [
          Text("$name"),
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget buildCard(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppCard(
      leading: Tooltip(message: "[$id]", child: Icon(Icons.sports_football)),
      trailing: trailing,
      children: [Text("$name")],
    );
  }
}
