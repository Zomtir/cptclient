// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/json/right.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/tiles/AppTeamTile.dart';
import 'package:cptclient/utils/crypto.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

class Team extends FieldInterface implements Comparable {
  final int id;
  String key;
  String name;
  String description;
  Right? right;

  Team(this.id, this.key, this.name, this.description);

  Team.fromVoid()
      : id = 0,
        key = assembleKey([2,2,2]),
        name = "",
        description = "",
        right = Right();

  Team.fromTeam(Team team)
      : id = 0,
        key = assembleKey([2,2,2]),
        name = "${team.name} (Copy)",
        description = team.description,
        right = (team.right == null) ? null : Right.fromRight(team.right!);

  Team.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        key = json['key'],
        name = json['name'],
        description = json['description'],
        right = (json['right'] == null) ? null : Right.fromJson(json['right']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'key' : key,
        'name': name,
        'description': description,
        'right': right?.toJson(),
      };

  @override
  bool operator ==(other) => other is Team && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return removeDiacritics(name).compareTo(removeDiacritics(other.name));
  }

  @override
  Widget buildEntry() {
    return Tooltip(
      message: "[$id] $key",
      child: Text("$name"),
    );
  }

  @override
  Widget buildTile() {
    return AppTeamTile(team: this);
  }

  @override
  get searchable => [name, description];
}
