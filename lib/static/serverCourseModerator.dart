// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';

Future<List<User>?> course_moderator_list(Session session, int courseID) async {
  final response = await http.get(
    server.uri('course_moderator_list', {'course_id': courseID.toString()}),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(list.map((model) => User.fromJson(model)));
}

Future<bool> course_mod(Session session, int courseID, int userID) async {
  final response = await http.head(
    server.uri('course_mod', {
      'course_id': courseID.toString(),
      'user_id' : userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> course_unmod(Session session, int courseID, int userID) async {
  final response = await http.head(
    server.uri('course_unmod', {
      'course': courseID.toString(),
      'user' : userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}