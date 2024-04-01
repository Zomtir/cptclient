import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/tiles/AppClubTile.dart';
import 'package:cptclient/static/crypto.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

class Club extends FieldInterface implements Comparable {
  final int id;
  String key;
  String name;
  String description;

  Club(this.id, this.key, this.name, this.description);

  Club.fromVoid()
      : id = 0,
        key = assembleKey([5]),
        name = "",
        description = "";

  Club.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        key = json['key'],
        name = json['name'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'name': name,
        'description': description,
      };

  @override
  bool operator ==(other) => other is Club && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return removeDiacritics(name).compareTo(removeDiacritics(other.name));
  }

  @override
  String toFieldString() {
    return "$name";
  }

  @override
  Widget buildTile() {
    return AppClubTile(club: this);
  }

  @override
  get searchable => [key, name, description];
}
