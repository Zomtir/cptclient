import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/item.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/tiles/AppStockTile.dart';
import 'package:flutter/material.dart';

class Stock extends FieldInterface implements Comparable {
  int id;
  Club club;
  Item item;
  String storage;
  int owned;
  int loaned;

  Stock(
      {required this.id,
      required this.club,
      required this.item,
      required this.storage,
      required this.owned,
      required this.loaned});

  Stock.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        club = Club.fromJson(json['club']),
        item = Item.fromJson(json['item']),
        storage = json['storage'],
        owned = json['owned'],
        loaned = json['loaned'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'club': club.toJson(),
        'item': item.toJson(),
        'storage': storage,
        'owned': owned,
        'loaned': loaned,
      };

  @override
  bool operator ==(other) => other is Stock && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    int criteria1 = club.compareTo(other.event);
    if (criteria1 != 0) return criteria1;
    return item.compareTo(other.item);
  }

  @override
  String toFieldString() {
    return "${club.name} - ${item.name} - $storage";
  }

  @override
  Widget buildTile() {
    return AppStockTile(stock: this);
  }

  @override
  get searchable {
    return [club.name, item.name, storage];
  }
}
