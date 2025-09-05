// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/json/skill.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/widgets/AppCard.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:cptclient/utils/format.dart';
import 'package:flutter/material.dart';

class Competence extends FieldInterface implements Comparable {
  final int id;
  User? user;
  Skill? skill;
  int rank;
  DateTime date;
  User? judge;

  Competence(this.id, this.user, this.skill, this.rank, this.date, this.judge);

  Competence.fromVoid()
    : id = 0,
      user = null,
      skill = null,
      rank = 0,
      date = DateTime.now(),
      judge = null;

  Competence.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      user = User.fromJson(json['user']),
      skill = Skill.fromJson(json['skill']),
      rank = json['rank'],
      date = parseIsoDate(json['date'])!.toLocal(),
      judge = User.fromJson(json['judge']);

  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'user': user?.toJson(),
      'skill': skill?.toJson(),
      'rank': rank,
      'date' : formatIsoDate(date.toUtc()),
      'judge' : judge?.toJson()
    };

    Competence.fromCompetence(Competence competence)
      : id = 0,
        user = competence.user,
        skill = competence.skill,
        rank = competence.rank,
        date = DateTime.now(),
        judge = competence.judge;


  @override
  bool operator ==(other) => other is Competence && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    int criteria1 = user!.compareTo(other.user);
    if (criteria1 != 0) return criteria1;

    int criteria2 = skill!.compareTo(other.skill);
    if (criteria2 != 0) return criteria2;

    int criteria3 = rank.compareTo(other.rank);
    return criteria3;
  }

  @override
  get searchable {
    return [user?.firstname, user?.lastname, user?.nickname, skill?.title, judge?.firstname, judge?.lastname, judge?.nickname];
  }

  @override
  Widget buildEntry(BuildContext context) {
    return Tooltip(
      message: "[$id]",
      child: Text("${user!.firstname} ${user!.lastname} - ${skill!.title} $rank"),
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
      leading: Tooltip(message: "$id", child: Icon(Icons.military_tech)),
      trailing: trailing,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${user!.firstname} ${user!.lastname}", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("${skill!.title} $rank"),
          Text("${date.fmtDate(context)} ${judge!.firstname} ${judge!.lastname}", style: TextStyle(color: Colors.black54)),
        ]
      ),
      onTap: onTap,
    );
  }

  @override
  Widget buildCard(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppCard(
      leading: Tooltip(message: "$id", child: Icon(Icons.military_tech)),
      trailing: trailing,
      children: [
        Text("${user!.firstname} ${user!.lastname}", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("${skill!.title} $rank"),
        Text(
            "${date.fmtDate(context)} ${judge!.firstname} ${judge!.lastname}", style: TextStyle(color: Colors.black54)),
      ],
    );
  }
}