import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/tiles/AppLicenseTile.dart';
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
        expiration = parseIsoDate(json['expiration'])!.toLocal();

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'number': number,
        'name': name,
        'expiration': formatIsoDate(expiration.toUtc()),
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
  Widget buildEntry(BuildContext context) {
    return Tooltip(
      message: "[$id]",
      child: Text("$name ($number)"),
    );
  }

  @override
  Widget buildTile(BuildContext context) {
    return AppLicenseTile(license: this);
  }

  @override
  get searchable {
    return [number, name];
  }

  // TODO
  static Widget buildEntryStatic(BuildContext context, License? lic) {
    if (lic == null) {
      return Text(AppLocalizations.of(context)!.labelMissing);
    }
    return Column(
      children: [
        Text("${lic.name.isEmpty ? AppLocalizations.of(context)!.undefined : lic.name} (${lic.number.isEmpty ? AppLocalizations.of(context)!.undefined : lic.number})"),
        Text("${lic.expiration.fmtDate(context)}"),
      ],
    );
  }

  // TODO
  static String copyEntryStatic(BuildContext context, License? lic) {
    if (lic == null) {
      return "";
    }
    return "${lic.name.isEmpty ? AppLocalizations.of(context)!.undefined : lic.name},"
        "(${lic.number.isEmpty ? AppLocalizations.of(context)!.undefined : lic.number})"
        "${formatIsoDate(lic.expiration)}"
        ;
  }
}
