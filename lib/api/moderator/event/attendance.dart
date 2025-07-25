// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';

Future<List<User>> event_attendance_registration_list(UserSession session, Event event, String role) async {
  final response = await client.get(
    uri('/mod/event_attendance_registration_list', {
      'event_id': event.id.toString(),
      'role': role,
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  return List<User>.from(json.decode(utf8.decode(response.bodyBytes)).map((data) => User.fromJson(data)));
}

Future<List<(User, bool)>> event_attendance_filter_list(UserSession session, int eventID, String role) async {
  final response = await client.get(
    uri('/mod/event_attendance_filter_list', {
      'event_id': eventID.toString(),
      'role': role,
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<(User, bool)>.from(
    list.map((model) {
      return (
        User.fromJson(model[0]),
        model[1],
      );
    }),
  );
}

Future<bool> event_attendance_filter_edit(UserSession session, int eventID, int userID, String role, bool access) async {
  final response = await client.head(
    uri('/mod/event_attendance_filter_edit', {
      'event_id': eventID.toString(),
      'user_id': userID.toString(),
      'role': role,
      'access': access.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_attendance_filter_remove(UserSession session, int eventID, int userID, String role) async {
  final response = await client.head(
    uri('/mod/event_attendance_filter_remove', {
      'event_id': eventID.toString(),
      'user_id': userID.toString(),
      'role': role,
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<User>> event_attendance_presence_pool(UserSession session, Event event, String role) async {
  final response = await client.get(
    uri('/mod/event_attendance_presence_pool', {
      'event_id': event.id.toString(),
      'role': role,
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  return List<User>.from(json.decode(utf8.decode(response.bodyBytes)).map((data) => User.fromJson(data)));
}

Future<List<User>> event_attendance_presence_list(UserSession session, Event event, String role) async {
  final response = await client.get(
    uri('/mod/event_attendance_presence_list', {
      'event_id': event.id.toString(),
      'role': role,
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  return List<User>.from(json.decode(utf8.decode(response.bodyBytes)).map((data) => User.fromJson(data)));
}

Future<bool> event_attendance_presence_add(UserSession session, Event event, User user, String role) async {
  final response = await client.head(
    uri('/mod/event_attendance_presence_add', {
      'event_id': event.id.toString(),
      'user_id': user.id.toString(),
      'role': role,
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_attendance_presence_remove(UserSession session, Event event, User user, String role) async {
  final response = await client.head(
    uri('/mod/event_attendance_presence_remove', {
      'event_id': event.id.toString(),
      'user_id': user.id.toString(),
      'role': role,
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
