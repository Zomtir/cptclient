// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/widgets/AppCard.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
import 'package:cptclient/utils/format.dart';
import 'package:flutter/material.dart';

class Affiliation extends FieldInterface {
  User? user;
  Organisation? organisation;
  String? member_identifier;
  DateTime? permission_solo_date;
  DateTime? permission_team_date;
  DateTime? residency_move_date;

  Affiliation(
    this.user,
    this.organisation,
    this.member_identifier,
    this.permission_solo_date,
    this.permission_team_date,
    this.residency_move_date,
  );

  Affiliation.fromNew(this.user, this.organisation)
    : member_identifier = null,
      permission_solo_date = null,
      permission_team_date = null,
      residency_move_date = null;

  Affiliation.fromJson(Map<String, dynamic> json)
    : user = json['user'] == null ? null : User.fromJson(json['user']),
      organisation = json['organisation'] == null ? null : Organisation.fromJson(json['organisation']),
      member_identifier = json['member_identifier'],
      permission_solo_date = parseIsoDate(json['permission_solo_date']),
      permission_team_date = parseIsoDate(json['permission_team_date']),
      residency_move_date = parseIsoDate(json['residency_move_date']);

  Map<String, dynamic> toJson() => {
    'user': user?.toJson(),
    'organisation': organisation?.toJson(),
    'member_identifier': member_identifier,
    'permission_solo_date': formatIsoDate(permission_solo_date),
    'permission_team_date': formatIsoDate(permission_team_date),
    'residency_move_date': formatIsoDate(residency_move_date),
  };

  @override
  int compareTo(other) {
    if (other is! Affiliation) return 1;
    return (member_identifier ?? '').compareTo(other.member_identifier ?? '');
  }

  @override
  get searchable {
    return [organisation!.name, organisation!.abbreviation, user!.firstname, user!.lastname, user?.nickname ?? ''];
  }

  // TODO
  static Widget buildListTile(BuildContext context, Affiliation? a, {List<Widget>? trailing, VoidCallback? onTap}) {
    if (a == null) {
      return ListTile(title: Text(AppLocalizations.of(context)!.labelMissing));
    }
    return Card(
      child: ListTile(
        leading: Icon(Icons.card_membership),
        trailing: trailing == null ? null : Row(children: trailing, mainAxisSize: MainAxisSize.min),
        title: Text("${a.organisation!.name} - ${a.user!.firstname} ${a.user!.lastname}"),
        subtitle: Text(
          "${AppLocalizations.of(context)!.affiliationMemberIdentifier} ${a.member_identifier ?? AppLocalizations.of(context)!.undefined}",
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget buildEntry(BuildContext context) {
    // TODO: implement buildEntry
    throw UnimplementedError();
  }

  @override
  Widget buildInfo(BuildContext context) {
    // TODO: implement buildEntry
    throw UnimplementedError();
  }

  @override
  Widget buildTile(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppTile(
      leading: Icon(Icons.foundation),
      trailing: trailing,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${organisation!.name}"),
          Text("${user!.firstname} ${user!.lastname}"),
        ],
      ),
      child2: Text("$member_identifier"),
      onTap: onTap,
    );
  }

  @override
  Widget buildCard(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppCard(
      leading: Icon(Icons.foundation),
      trailing: trailing,
      children: [
        Text("${organisation!.name}"),
        Text("${user!.firstname} ${user!.lastname}"),
        Text("$member_identifier"),
      ],
    );
  }
}
