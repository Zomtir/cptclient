// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<Course>>> course_availability(UserSession session) async {
  final response = await client.get(
    uri('/regular/course_availability'),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<Course>.from(it.map((model) => Course.fromJson(model)));
  return Success(list);
}

Future<Result> course_mod(UserSession session, int courseID, int userID) async {
  final response = await client.head(
    uri('course_mod', {
      'course_id': courseID.toString(),
      'user_id': userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> course_unmod(UserSession session, int courseID, int userID) async {
  final response = await client.head(
    uri('course_unmod', {
      'course': courseID.toString(),
      'user': userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}
