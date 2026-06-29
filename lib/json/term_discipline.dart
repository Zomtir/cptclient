// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/json/discipline.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/widgets/AppCard.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
import 'package:flutter/material.dart';

class TermDiscipline extends FieldInterface implements Comparable {
  final int id;
  Discipline? discipline;
  int? begin;
  int? end;

  TermDiscipline({this.id = 0, this.discipline, this.begin, this.end});

  TermDiscipline.fromVoid() : id = 0, discipline = null, begin = null, end = null;

  TermDiscipline.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      discipline = Discipline.fromJson(json['discipline']),
      begin = json['begin'],
      end = json['end'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'discipline': discipline?.toJson(),
    'begin': begin,
    'end': end,
  };

  @override
  bool operator ==(other) => other is TermDiscipline && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return (begin ?? 0).compareTo(other.begin ?? 0);
  }

  @override
  get searchable {
    return [
      discipline?.name ?? "",
      begin?.toString() ?? "",
      end?.toString() ?? "",
    ];
  }

  @override
  Widget buildEntry(BuildContext context) {
    return Text(
      "${discipline!.name}: ${begin ?? AppLocalizations.of(context)!.labelUnknown} - ${end ?? AppLocalizations.of(context)!.labelOngoing}",
    );
  }

  @override
  Widget buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${discipline!.name}"),
        Text(
          "${begin ?? AppLocalizations.of(context)!.labelUnknown} - "
          "${end ?? AppLocalizations.of(context)!.labelOngoing}",
        ),
      ],
    );
  }

  @override
  Widget buildTile(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppTile(
      leading: Tooltip(message: "[$id]", child: Icon(Icons.card_membership)),
      trailing: trailing,
      child: buildInfo(context),
      onTap: onTap,
    );
  }

  @override
  Widget buildCard(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppCard(
      leading: Tooltip(message: "[$id]", child: Icon(Icons.card_membership)),
      trailing: trailing,
      child: buildInfo(context),
    );
  }
}
