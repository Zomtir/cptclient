// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/format.dart';

class Affiliation {
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
        permission_solo_date = parseIsoDate(json['permission_solo_date'])?.toLocal(),
        permission_team_date = parseIsoDate(json['permission_team_date'])?.toLocal(),
        residency_move_date = parseIsoDate(json['residency_move_date'])?.toLocal();

  Map<String, dynamic> toJson() => {
        'user': user?.toJson(),
        'organisation': organisation?.toJson(),
        'member_identifier': member_identifier,
        'permission_solo_date': formatIsoDate(permission_solo_date?.toUtc()),
        'permission_team_date': formatIsoDate(permission_team_date?.toUtc()),
        'residency_move_date': formatIsoDate(residency_move_date?.toUtc()),
      };
}
