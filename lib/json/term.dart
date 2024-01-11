// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/json/user.dart';

import 'package:cptclient/static/format.dart';

class Term implements Comparable {
  final int id;
  User? user;
  DateTime? begin;
  DateTime? end;

  Term(this.id, this.user, this.begin, this.end);

  Term.fromVoid()
      : id = 0,
        user = null,
        begin = null,
        end = null;

  Term.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        user = User.fromJson(json['user']),
        begin = parseNullWebDate(json['begin']),
        end = parseNullWebDate(json['end']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user?.toJson(),
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
