import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/widgets/AppCard.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:cptclient/utils/format.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

class License extends FieldInterface implements Comparable {
  final int id;
  String number;
  String name;
  DateTime expiration;

  License(this.id, this.number, this.name, this.expiration);

  License.fromVoid()
      : id = 0,
        number = "",
        name = "",
        expiration = DateTime.now();

  License.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        number = json['number'],
        name = json['name'],
        expiration = parseIsoDate(json['expiration'])!;

  Map<String, dynamic> toJson() => {
        'id': id,
        'number': number,
        'name': name,
        'expiration': formatIsoDate(expiration),
      };

  @override
  bool operator ==(other) => other is License && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return removeDiacritics(name).compareTo(removeDiacritics(other.name));
  }

  @override
  get searchable {
    return [number, name];
  }

  String clip(BuildContext context) {
    return "${name.isEmpty ? AppLocalizations.of(context)!.undefined : name},"
        "(${number.isEmpty ? AppLocalizations.of(context)!.undefined : number})"
        "${formatIsoDate(expiration)}";
  }

  @override
  Widget buildEntry(BuildContext context) {
    return Tooltip(
      message: "[$id]",
      child: Text("$name ($number)"),
    );
  }

  @override
  Widget buildInfo(BuildContext context) {
    return Column(
      children: [
        Text("${name.isEmpty ? AppLocalizations.of(context)!.undefined : name} "
            "(${number.isEmpty ? AppLocalizations.of(context)!.undefined : number})"),
        Text("${expiration.fmtDate(context)}"),
      ],
    );
  }

  @override
  Widget buildTile(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppTile(
      leading: Tooltip(message: "$id", child: Icon(Icons.badge)),
      trailing: trailing,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$name (${number.isEmpty ? AppLocalizations.of(context)!.undefined : number})", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("${expiration.fmtDate(context)}"),
          ]
      ),
      onTap: onTap,
    );
  }

  @override
  Widget buildCard(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppCard(
      leading: Tooltip(message: "$id", child: Icon(Icons.badge)),
      trailing: trailing,
      children: [
        Text("$name (${number.isEmpty ? AppLocalizations.of(context)!.undefined : number})", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("${expiration.fmtDate(context)}"),
      ],
    );
  }
}
