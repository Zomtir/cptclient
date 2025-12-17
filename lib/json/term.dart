// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/widgets/AppCard.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:cptclient/utils/format.dart';
import 'package:flutter/material.dart';

class Term extends FieldInterface implements Comparable {
  final int id;
  User? user;
  Club? club;
  DateTime? begin;
  DateTime? end;

  Term({this.id = 0, this.user, this.club, this.begin, this.end});

  Term.fromVoid() : id = 0, user = null, club = null, begin = null, end = null;

  Term.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      user = User.fromJson(json['user']),
      club = Club.fromJson(json['club']),
      begin = parseIsoDate(json['begin']),
      end = parseIsoDate(json['end']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'user': user?.toJson(),
    'club': club?.toJson(),
    'begin': formatIsoDate(begin),
    'end': formatIsoDate(end),
  };

  @override
  bool operator ==(other) => other is Term && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return (begin ?? DateTime(0)).compareTo(other.begin ?? DateTime(0));
  }

  @override
  get searchable {
    return [
      user?.firstname ?? "",
      user?.lastname ?? "",
      user?.nickname ?? "",
      club?.key ?? "",
      club?.name ?? "",
      begin?.year.toString() ?? "",
      end?.year.toString() ?? "",
    ];
  }

  @override
  Widget buildEntry(BuildContext context) {
    return Tooltip(
      message: "[$id]",
      child: Text("${club!.name}: ${user!.firstname} ${user!.lastname}"),
    );
  }

  @override
  Widget buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${user!.firstname} ${user!.lastname}", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("${club!.name}"),
        Text(
          "${begin?.fmtDate(context) ?? AppLocalizations.of(context)!.labelUnknown} - "
          "${end?.fmtDate(context) ?? AppLocalizations.of(context)!.labelOngoing}",
        ),
      ],
    );
  }

  @override
  Widget buildTile(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppTile(
      leading: Tooltip(message: "[$id]", child: Icon(Icons.card_membership)),
      trailing: trailing,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${user!.firstname} ${user!.lastname}", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("${club!.name}"),
          Text(
            "${begin?.fmtDate(context) ?? AppLocalizations.of(context)!.labelUnknown} - "
            "${end?.fmtDate(context) ?? AppLocalizations.of(context)!.labelOngoing}",
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget buildCard(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppCard(
      leading: Tooltip(message: "[$id]", child: Icon(Icons.card_membership)),
      trailing: trailing,
      children: [
        Text("${user!.firstname} ${user!.lastname}", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("${club!.name}"),
        Text(
          "${begin?.fmtDate(context) ?? AppLocalizations.of(context)!.labelUnknown} - "
          "${end?.fmtDate(context) ?? AppLocalizations.of(context)!.labelOngoing}",
        ),
      ],
    );
  }
}
