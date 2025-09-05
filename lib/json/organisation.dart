import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/widgets/AppCard.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

class Organisation extends FieldInterface implements Comparable {
  final int id;
  String abbreviation;
  String name;

  Organisation(this.id, this.abbreviation, this.name);

  Organisation.fromVoid()
      : id = 0,
        abbreviation = "",
        name = "";

  Organisation.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        abbreviation = json['abbreviation'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'abbreviation': abbreviation,
        'name': name,
      };

  @override
  bool operator ==(other) => other is Organisation && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return removeDiacritics(abbreviation).compareTo(removeDiacritics(other.abbreviation));
  }

  @override
  get searchable {
    return [abbreviation, name];
  }

  @override
  Widget buildEntry(BuildContext context) {
    return Tooltip(
      message: "[$id] $abbreviation",
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
      leading: Tooltip(child: Icon(Icons.domain), message: "[$id]"),
      trailing: trailing,
      child: Text("$abbreviation"),
      child2: Text("$name"),
      onTap: onTap,
    );
  }

  @override
  Widget buildCard(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppCard(
      leading: Tooltip(child: Icon(Icons.domain), message: "[$id]"),
      trailing: trailing,
      children: [
        Text("$abbreviation"),
        Text("$name"),
      ],
    );
  }
}
