import 'package:cptclient/json/itemcat.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/tiles/AppItemTile.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

class Item extends FieldInterface implements Comparable {
  final int id;
  String name;
  ItemCategory? category;

  Item(this.id, this.name, this.category);

  Item.fromVoid()
      : id = 0,
        name = "";

  Item.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        category = json['category'] == null ? null : ItemCategory.fromJson(json['category']);

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'category': category?.toJson(),
      };

  @override
  bool operator ==(other) => other is Item && id == other.id;

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
    return AppItemTile(item: this);
  }

  @override
  get searchable {
    return [name];
  }
}
