// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/static/client.dart';

Future<List<(Team, bool)>> course_supporter_sieve_list(UserSession session, int courseID) async {
  final response = await client.get(
    uri('/mod/course_supporter_sieve_list', {'course_id': courseID.toString()}),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<(Team, bool)>.from(
    list.map((model) {
      return (Team.fromJson(model[0]), model[1]);
    }),
  );
}

Future<bool> course_supporter_sieve_edit(UserSession session, int courseID, int teamID, bool access) async {
  final response = await client.head(
    uri('/mod/course_supporter_sieve_edit', {
      'course_id': courseID.toString(),
      'team_id': teamID.toString(),
      'access': access.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> course_supporter_sieve_remove(UserSession session, int courseID, int teamID) async {
  final response = await client.head(
    uri('/mod/course_supporter_sieve_remove', {
      'course_id': courseID.toString(),
      'team_id': teamID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
