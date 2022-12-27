// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'navigation.dart' as navi;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/json/course.dart';

Future<bool> course_create(Session session, Course course) async {
  final response = await http.post(
    Uri.http(navi.serverURL, '/admin/course_create'),
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
    Uri.http(navi.serverURL, '/admin/course_edit', {
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
    Uri.http(navi.serverURL, '/admin/course_delete', {'course_id': courseID.toString()}),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<Slot>?> course_slot_list(Session session, int courseID) async {
  final response = await http.get(
    Uri.http(navi.serverURL, '/admin/course_slot_list', {'course_id': courseID.toString()}),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Slot>.from(l.map((model) => Slot.fromJson(model)));
}

Future<List<User>?> course_moderator_list(Session session, int courseID) async {
  final response = await http.get(
    Uri.http(navi.serverURL, '/admin/course_moderator_list', {'course_id': courseID.toString()}),
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
    Uri.http(navi.serverURL, '/admin/course_moderator_add', {
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
    Uri.http(navi.serverURL, 'course_unmod', {
      'course': courseID.toString(),
      'user' : userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}