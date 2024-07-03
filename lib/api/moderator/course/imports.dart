// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/static/message.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

export 'leader.dart';
export 'moderator.dart';
export 'participant.dart';
export 'supporter.dart';

Future<List<Course>> course_responsibility(UserSession session, bool? active, bool? public) async {
  final response = await http.get(
    server.uri('/mod/course_responsibility', {
      if (active != null) 'active': active.toString(),
      if (public != null) 'public': public.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<Course>.from(list.map((model) => Course.fromJson(model)));
}

Future<bool> course_create(UserSession session, Course course) async {
  final response = await http.post(
    server.uri('/mod/course_create'),
    headers: {
      'Token': session.token,
      'Content-Type': 'application/json; charset=utf-8',
    },
    body: json.encode(course),
  );

  bool success = (response.statusCode == 200);
  messageSuccess(success);
  return success;
}

Future<bool> course_edit(UserSession session, Course course) async {
  final response = await http.post(
    server.uri('/mod/course_edit', {
      'course_id': course.id.toString(),
    }),
    headers: {
      'Token': session.token,
      'Content-Type': 'application/json; charset=utf-8',
    },
    body: json.encode(course),
  );

  return (response.statusCode == 200);
}

Future<bool> course_delete(UserSession session, Course course) async {
  final response = await http.head(
    server.uri('/mod/course_delete', {'course_id': course.id.toString()}),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}