import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/tiles/AppClubTile.dart';
import 'package:cptclient/utils/crypto.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

class Club extends FieldInterface implements Comparable {
  final int id;
  String key;
  String name;
  String? description;
  String? disciplines;
  String? image_url;
  String? chairman;

  Club(this.id, this.key, this.name, this.description);

  Club.fromVoid()
      : id = 0,
        key = assembleKey([5]),
        name = "";

  Club.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        key = json['key'],
        name = json['name'],
        description = json['description'],
        disciplines = json['disciplines'],
        image_url = json['image_url'],
        chairman = json['chairman'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'name': name,
        'description': description,
        'disciplines': disciplines,
        'image_url': image_url,
        'chairman': chairman,
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
  Widget buildEntry(BuildContext context) {
    return Tooltip(
      message: "[$id] $key",
      child: Text("$name"),
    );
  }

  @override
  Widget buildTile(BuildContext context) {
    return AppClubTile(club: this);
  }

  @override
  get searchable => [key, name, description];
}
