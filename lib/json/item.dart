import 'package:cptclient/json/itemcat.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/widgets/AppCard.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
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
  get searchable {
    return [name];
  }

  @override
  Widget buildEntry(BuildContext context) {
    return Tooltip(
      message: "[$id]",
      child: Text("$name"),
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
      leading: Icon(Icons.checkroom),
      trailing: trailing,
      child: Text("$name"),
      child2: Text("${category?.name ?? AppLocalizations.of(context)!.undefined}"),
      onTap: onTap,
    );
  }

  @override
  Widget buildCard(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppCard(
      leading: Icon(Icons.checkroom),
      trailing: trailing,
      children: [
        Text("$name"),
        Text("${category?.name ?? AppLocalizations.of(context)!.undefined}"),
      ],
    );
  }
}
