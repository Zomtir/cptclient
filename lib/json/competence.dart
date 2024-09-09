// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/json/skill.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/format.dart';

class Competence {
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
}