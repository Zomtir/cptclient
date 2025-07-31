import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
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
  get searchable => [key, name, description ?? ''];

  // TODO
  static Widget buildListTile(BuildContext context, Club? club, {List<Widget>? trailing, VoidCallback? onTap}) {
    if (club == null) {
      return ListTile(title: Text(AppLocalizations.of(context)!.labelMissing));
    }
    return Card(
      child: ListTile(
        leading: Tooltip(child: Icon(Icons.group_work), message: "${club.key}"),
        trailing: trailing == null ? null : Row(children: trailing, mainAxisSize: MainAxisSize.min),
        title: Text("${club.name}"),
        subtitle: Text(club.chairman ?? ''),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget buildTile(BuildContext context) {
    return Club.buildListTile(context, this);
  }

  @override
  Widget buildEntry(BuildContext context) {
    return Tooltip(
      message: "[$id] $key",
      child: Text("$name"),
    );
  }

  @override
  Widget buildCard(BuildContext context) {
    // TODO: implement buildEntry
    throw UnimplementedError();
  }
}
