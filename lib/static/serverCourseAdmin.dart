// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/json/course.dart';

Future<List<Course>> course_list(Session session, User? user) async {
  final response = await http.get(
    Uri.http(server.serverURL, '/admin/course_list', {
      if (user != null) 'mod_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(response.body);
  return List<Course>.from(l.map((model) => Course.fromJson(model)));
}

Future<bool> course_create(Session session, Course course) async {
  final response = await http.post(
    Uri.http(server.serverURL, '/admin/course_create'),
    headers: {
      'Token': session.token,
      'Content-Type': 'application/json; charset=utf-8',
    },
    body: json.encode(course),
  );

  return (response.statusCode == 200);
}

Future<bool> course_edit(Session session, int courseID, Course course) async {
  final response = await http.post(
    Uri.http(server.serverURL, '/admin/course_edit', {
     'course_id' : courseID.toString(),
    }),
    headers: {
      'Token': session.token,
      'Content-Type': 'application/json; charset=utf-8',
    },
    body: json.encode(course),
  );

  return (response.statusCode == 200);
}

Future<bool> course_delete(Session session, int courseID) async {
  final response = await http.head(
    Uri.http(server.serverURL, '/admin/course_delete', {'course_id': courseID.toString()}),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<User>?> course_moderator_list(Session session, int courseID) async {
  final response = await http.get(
    Uri.http(server.serverURL, '/admin/course_moderator_list', {'course_id': courseID.toString()}),
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
    Uri.http(server.serverURL, '/admin/course_moderator_add', {
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
    Uri.http(server.serverURL, '/admin/course_moderator_remove', {
      'course_id': courseID.toString(),
      'user_id' : userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}