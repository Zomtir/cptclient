import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/tiles/AppClubTile.dart';
import 'package:flutter/material.dart';

class Club extends FieldInterface implements Comparable {
  final int id;
  final String name;
  final String description;

  Club(this.id, this.name, this.description);

  Club.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
      };

  @override
  bool operator ==(other) => other is Club && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return name.compareTo(other.name);
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
  get searchable => [name, description];
}
