// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/tiles/AppSkillTile.dart';
import 'package:flutter/material.dart';

class Skill extends FieldInterface implements Comparable {
  final int id;
  String key;
  String title;
  int min = 0;
  int max = 0;

  Skill(this.id, this.key, this.title);

  Skill.fromVoid()
      : id = 0,
        key = "",
        title = "";

  Skill.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        key = json['key'],
        title = json['title'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'title': title,
      };

  @override
  bool operator ==(other) => other is Skill && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return title.compareTo(other.description);
  }

  @override
  String toFieldString() {
    return "[$key] $title";
  }

  @override
  Widget buildTile() {
    return AppSkillTile(skill: this);
  }

  @override
  get searchable {
    return [key, title];
  }
}
