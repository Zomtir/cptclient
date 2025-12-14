// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

export 'attendance.dart';
export 'moderator.dart';

Future<Result<List<Course>>> course_responsibility(UserSession session, bool? active, bool? public) async {
  final response = await client.get(
    uri('/mod/course_responsibility', {
      if (active != null) 'active': active.toString(),
      if (public != null) 'public': public.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var li = List<Course>.from(it.map((model) => Course.fromJson(model)));
  return Success(li);
}

Future<Result> course_create(UserSession session, Course course) async {
  final response = await client.post(
    uri('/mod/course_create'),
    headers: {
      'Token': session.token,
      'Content-Type': 'application/json; charset=utf-8',
    },
    body: json.encode(course),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> course_edit(UserSession session, Course course) async {
  final response = await client.post(
    uri('/mod/course_edit', {
      'course_id': course.id.toString(),
    }),
    headers: {
      'Token': session.token,
      'Content-Type': 'application/json; charset=utf-8',
    },
    body: json.encode(course),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> course_delete(UserSession session, Course course) async {
  final response = await client.head(
    uri('/mod/course_delete', {'course_id': course.id.toString()}),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}