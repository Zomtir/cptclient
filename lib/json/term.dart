// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/user.dart';

import 'package:cptclient/static/format.dart';

class Term implements Comparable {
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
        begin = parseNullWebDate(json['begin']),
        end = parseNullWebDate(json['end']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user?.toJson(),
        'club': club?.toJson(),
        'begin': formatNullWebDate(begin),
        'end': formatNullWebDate(end),
      };

  @override
  bool operator ==(other) => other is Term && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return (begin ?? DateTime(0)).compareTo(other.begin ?? DateTime(0));
  }
}
