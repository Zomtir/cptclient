// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<(Team, bool)>>> course_attendance_sieve_list(UserSession session, int courseID, String role) async {
  final response = await client.get(
    uri('/admin/course_attendance_sieve_list', {
      'course_id': courseID.toString(),
      'role': role,
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var li = List<(Team, bool)>.from(it.map((model) => (Team.fromJson(model[0]), model[1])));

  return Success(li);
}

Future<Result> course_attendance_sieve_edit(
  UserSession session,
  int courseID,
  int teamID,
  String role,
  bool access,
) async {
  final response = await client.head(
    uri('/admin/course_attendance_sieve_edit', {
      'course_id': courseID.toString(),
      'team_id': teamID.toString(),
      'role': role,
      'access': access.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  
  return Success(());
}

Future<Result> course_attendance_sieve_remove(UserSession session, int courseID, int teamID, String role) async {
  final response = await client.head(
    uri('/admin/course_attendance_sieve_remove', {
      'course_id': courseID.toString(),
      'team_id': teamID.toString(),
      'role': role,
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  return Success(());
}
