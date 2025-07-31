import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/tiles/AppLocationTile.dart';
import 'package:cptclient/utils/crypto.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

class Location extends FieldInterface implements Comparable {
  final int id;
  String key;
  String name;
  String description;

  Location(this.id, this.key, this.name, this.description);

  Location.fromVoid()
      : id = 0,
        key = assembleKey([4]),
        name = "",
        description = "";

  Location.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        key = json['key'],
        name = json['name'],
        description = json['description'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'key': key,
        'name': name,
        'description': description,
      };

  @override
  bool operator ==(other) => other is Location && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return removeDiacritics(name).compareTo(removeDiacritics(other.name));
  }

  @override
  get searchable {
    return [key, name, description];
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
    return AppLocationTile(location: this);
  }

  @override
  Widget buildCard(BuildContext context) {
    // TODO: implement buildEntry
    throw UnimplementedError();
  }
}
