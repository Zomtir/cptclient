// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<List<Course>?> course_availability(UserSession session) async {
  final response = await http.get(
    server.uri('/regular/course_availability'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return null;

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<Course>.from(list.map((model) => Course.fromJson(model)));
}

Future<bool> course_mod(UserSession session, int courseID, int userID) async {
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

Future<bool> course_unmod(UserSession session, int courseID, int userID) async {
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