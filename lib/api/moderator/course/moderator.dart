// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<User>>> course_moderator_list(UserSession session, int courseID) async {
  final response = await client.get(
    uri('/mod/course_moderator_list', {'course_id': courseID.toString()}),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var li = List<User>.from(it.map((model) => User.fromJson(model)));

  return Success(li);
}

Future<Result> course_moderator_add(UserSession session, int courseID, int userID) async {
  final response = await client.head(
    uri('/mod/course_moderator_add', {
      'course_id': courseID.toString(),
      'user_id' : userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  return Success(());
}

Future<Result> course_moderator_remove(UserSession session, int courseID, int userID) async {
  final response = await client.head(
    uri('/mod/course_moderator_remove', {
      'course': courseID.toString(),
      'user' : userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  return Success(());
}
