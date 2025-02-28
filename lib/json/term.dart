// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/tiles/AppTermTile.dart';
import 'package:cptclient/utils/format.dart';
import 'package:flutter/material.dart';

class Term extends FieldInterface implements Comparable {
  final int id;
  User? user;
  Club? club;
  DateTime? begin;
  DateTime? end;

  Term(this.id, this.user, this.club, this.begin, this.end);

  Term.fromVoid()
      : id = 0,
        user = null,
        club = null,
        begin = null,
        end = null;

  Term.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        user = User.fromJson(json['user']),
        club = Club.fromJson(json['club']),
        begin = parseIsoDate(json['begin'])?.toLocal(),
        end = parseIsoDate(json['end'])?.toLocal();

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user?.toJson(),
        'club': club?.toJson(),
        'begin': formatIsoDate(begin?.toUtc()),
        'end': formatIsoDate(end?.toUtc()),
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
  Widget buildEntry(BuildContext context) {
    return Tooltip(
      message: "[$id]",
      child: Text("${club!.name}: ${user!.firstname} ${user!.lastname}"),
    );
  }

  @override
  Widget buildTile(BuildContext context) {
    return AppTermTile(term: this);
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
}
