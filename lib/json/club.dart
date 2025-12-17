import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/widgets/AppCard.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
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
  String? banner_url;
  String? chairman;

  Club(this.id, this.key, this.name, this.description);

  Club.fromVoid() : id = 0, key = assembleKey([5]), name = "";

  Club.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      key = json['key'],
      name = json['name'],
      description = json['description'],
      disciplines = json['disciplines'],
      image_url = json['image_url'],
      banner_url = json['banner_url'],
      chairman = json['chairman'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'key': key,
    'name': name,
    'description': description,
    'disciplines': disciplines,
    'image_url': image_url,
    'banner_url': banner_url,
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

  @override
  Widget buildEntry(BuildContext context) {
    return Tooltip(message: "[$id] $key", child: Text("$name"));
  }

  @override
  Widget buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name),
        Text("${AppLocalizations.of(context)!.clubChairman}: ${chairman ?? AppLocalizations.of(context)!.undefined}"),
      ],
    );
  }

  @override
  Widget buildTile(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppTile(
      leading: Tooltip(child: Icon(Icons.group_work), message: "[$id] $key"),
      trailing: trailing,
      child: Text(name),
      onTap: onTap,
    );
  }

  @override
  Widget buildCard(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppCard(
      leading: Tooltip(child: Icon(Icons.group_work), message: "[$id] $key"),
      trailing: trailing,
      children: [
        Text(name),
        Text(chairman ?? ''),
      ],
    );
  }
}
