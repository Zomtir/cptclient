import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/item.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/widgets/AppCard.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
import 'package:flutter/material.dart';

class Stock extends FieldInterface implements Comparable {
  int id;
  Club club;
  Item item;
  String storage;
  int owned;
  int loaned;

  Stock({
    required this.id,
    required this.club,
    required this.item,
    required this.storage,
    required this.owned,
    required this.loaned,
  });

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
    int criteria1 = club.compareTo(other.club);
    if (criteria1 != 0) return criteria1;
    return item.compareTo(other.item);
  }

  @override
  get searchable {
    return [club.name, item.name, storage];
  }

  @override
  Widget buildEntry(BuildContext context) {
    return Tooltip(
      message: "[$id]",
      child: Text("${club.name} - ${item.name} - $storage"),
    );
  }

  @override
  Widget buildInfo(BuildContext context) {
    // TODO: implement buildEntry
    throw UnimplementedError();
  }

  @override
  Widget buildTile(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppTile(
      leading: Tooltip(message: "[$id]", child: Icon(Icons.shelves)),
      trailing: trailing,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${club.name}", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("${item.name}", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("$storage", style: TextStyle(fontWeight: FontWeight.normal)),
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget buildCard(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppCard(
      leading: Tooltip(message: "[$id]", child: Icon(Icons.shelves)),
      trailing: trailing,
      children: [
        Text("${club.name}", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("${item.name}", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("$storage", style: TextStyle(fontWeight: FontWeight.normal)),
      ],
    );
  }
}
