// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<List<Course>> course_responsibility(Session session, bool? active, bool? public) async {
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

Future<List<User>?> course_moderator_list(Session session, int courseID) async {
  final response = await http.get(
    server.uri('/mod/course_moderator_list', {'course_id': courseID.toString()}),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(list.map((model) => User.fromJson(model)));
}

Future<bool> course_moderator_add(Session session, int courseID, int userID) async {
  final response = await http.head(
    server.uri('/mod/course_moderator_add', {
      'course_id': courseID.toString(),
      'user_id' : userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> course_moderator_remove(Session session, int courseID, int userID) async {
  final response = await http.head(
    server.uri('/mod/course_moderator_remove', {
      'course': courseID.toString(),
      'user' : userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}