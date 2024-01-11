// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/json/branch.dart';
import 'package:cptclient/json/user.dart';
import 'package:intl/intl.dart';

class Ranking {
  final int id;
  User? user;
  Branch? branch;
  int rank;
  DateTime date;
  User? judge;

  Ranking(this.id, this.user, this.branch, this.rank, this.date, this.judge);

  Ranking.create()
    : id = 0,
      user = null,
      branch = null,
      rank = 0,
      date = DateTime.now(),
      judge = null;

  Ranking.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      user = User.fromJson(json['user']),
      branch = Branch.fromJson(json['branch']),
      rank = json['rank'],
      date = DateFormat("yyyy-MM-dd").parse(json['date'], true).toLocal(),
      judge = User.fromJson(json['judge']);

  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'user': user?.toJson(),
      'branch': branch?.toJson(),
      'rank': rank,
      'date' : DateFormat("yyyy-MM-dd").format(date.toUtc()),
      'judge' : judge?.toJson()
    };

    Ranking.fromRanking(Ranking ranking)
      : id = 0,
        user = ranking.user,
        branch = ranking.branch,
        rank = ranking.rank,
        date = DateTime.now(),
        judge = ranking.judge;
}