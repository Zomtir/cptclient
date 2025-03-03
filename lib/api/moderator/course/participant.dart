// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';

Future<List<(Team, bool)>> course_attendance_sieve_list(UserSession session, int courseID, String role) async {
  final response = await client.get(
    uri('/mod/course_attendance_sieve_list', {
      'course_id': courseID.toString(),
      'role': role,
    }),
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

Future<bool> course_attendance_sieve_edit(UserSession session, int courseID, int teamID, String role, bool access) async {
  final response = await client.head(
    uri('/mod/course_attendance_sieve_edit', {
      'course_id': courseID.toString(),
      'team_id': teamID.toString(),
      'role': role,
      'access': access.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> course_attendance_sieve_remove(UserSession session, int courseID, int teamID, String role) async {
  final response = await client.head(
    uri('/mod/course_attendance_sieve_remove', {
      'course_id': courseID.toString(),
      'team_id': teamID.toString(),
      'role': role,
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
