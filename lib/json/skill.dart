// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/tiles/AppSkillTile.dart';
import 'package:cptclient/utils/crypto.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

class Skill extends FieldInterface implements Comparable {
  final int id;
  String key;
  String title;
  int min;
  int max;

  Skill(this.id, this.key, this.title, this.min, this.max);

  Skill.fromVoid()
      : id = 0,
        key = assembleKey([4]),
        title = "",
        min = 0,
        max = 1;

  Skill.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        key = json['key'],
        title = json['title'],
        min = json['min'],
        max = json['max'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'title': title,
        'min': min,
        'max': max,
      };

  @override
  bool operator ==(other) => other is Skill && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return removeDiacritics(title).compareTo(removeDiacritics(other.title));
  }

  @override
  Widget buildEntry(BuildContext context) {
    return Tooltip(
      message: "[$id] $key",
      child: Text("$title"),
    );
  }

  @override
  Widget buildTile(BuildContext context) {
    return AppSkillTile(skill: this);
  }

  @override
  get searchable {
    return [key, title];
  }
}
