// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/widgets/AppCard.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
import 'package:cptclient/utils/crypto.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

class Discipline extends FieldInterface implements Comparable {
  final int id;
  String key;
  String title;

  Discipline(this.id, this.key, this.title);

  Discipline.fromVoid() : id = 0, key = assembleKey([4]), title = "";

  Discipline.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      key = json['key'],
      title = json['title'];

  Map<String, dynamic> toJson() => {'id': id, 'key': key, 'title': title};

  @override
  bool operator ==(other) => other is Discipline && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return removeDiacritics(title).compareTo(removeDiacritics(other.title));
  }

  @override
  get searchable {
    return [key, title];
  }

  @override
  Widget buildEntry(BuildContext context) {
    return Tooltip(message: "[$id] $key", child: Text("$title"));
  }

  @override
  Widget buildInfo(BuildContext context) {
    // TODO: implement buildEntry
    throw UnimplementedError();
  }

  @override
  Widget buildTile(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppTile(
      leading: Tooltip(message: "[$id] $key", child: Icon(Icons.sports_handball)),
      trailing: trailing,
      child: Text("$title"),
      onTap: onTap,
    );
  }

  @override
  Widget buildCard(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppCard(
      leading: Tooltip(message: "[$id] $key", child: Icon(Icons.sports_handball)),
      trailing: trailing,
      children: [Text("$title")],
    );
  }
}
