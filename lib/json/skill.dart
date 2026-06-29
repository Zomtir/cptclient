// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/widgets/AppCard.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
import 'package:cptclient/utils/crypto.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

class Skill extends FieldInterface implements Comparable {
  final int id;
  String key;
  String name;
  int min;
  int max;

  Skill(this.id, this.key, this.name, this.min, this.max);

  Skill.fromVoid() : id = 0, key = assembleKey([4]), name = "", min = 0, max = 1;

  Skill.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      key = json['key'],
      name = json['name'],
      min = json['min'] ?? 0,
      max = json['max'] ?? 0;

  Map<String, dynamic> toJson() => {'id': id, 'key': key, 'name': name, 'min': min, 'max': max};

  @override
  bool operator ==(other) => other is Skill && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return removeDiacritics(name).compareTo(removeDiacritics(other.name));
  }

  @override
  get searchable {
    return [key, name];
  }

  @override
  Widget buildEntry(BuildContext context) {
    return Tooltip(message: "[$id] $key", child: Text("$name"));
  }

  @override
  Widget buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$name"),
        Text("$min - $max")
      ],
    );
  }

  @override
  Widget buildTile(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppTile(
      leading: Tooltip(message: "[$id] $key", child: Icon(Icons.fitness_center)),
      trailing: trailing,
      child: buildInfo(context),
      onTap: onTap,
    );
  }

  @override
  Widget buildCard(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppCard(
      leading: Tooltip(message: "[$id] $key", child: Icon(Icons.fitness_center)),
      trailing: trailing,
      child: buildInfo(context),
    );
  }
}
