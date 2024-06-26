// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<List<User>> event_supporter_registration_list(UserSession session, Event event) async {
  final response = await http.get(
    server.uri('/admin/event_supporter_registration_list', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  return List<User>.from(json.decode(utf8.decode(response.bodyBytes)).map((data) => User.fromJson(data)));
}

Future<List<(User, bool)>> event_supporter_filter_list(UserSession session, int eventID) async {
  final response = await http.get(
    server.uri('/admin/event_supporter_filter_list', {
      'event_id': eventID.toString(),
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

Future<bool> event_supporter_filter_edit(UserSession session, int eventID, int userID, bool access) async {
  final response = await http.head(
    server.uri('/admin/event_supporter_filter_edit', {
      'event_id': eventID.toString(),
      'user_id': userID.toString(),
      'access': access.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_supporter_filter_remove(UserSession session, int eventID, int userID) async {
  final response = await http.head(
    server.uri('/admin/event_supporter_filter_remove', {
      'event_id': eventID.toString(),
      'user_id': userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<User>> event_supporter_presence_pool(UserSession session, Event event) async {
  final response = await http.get(
    server.uri('/admin/event_supporter_presence_pool', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  return List<User>.from(json.decode(utf8.decode(response.bodyBytes)).map((data) => User.fromJson(data)));
}

Future<List<User>> event_supporter_presence_list(UserSession session, Event event) async {
  final response = await http.get(
    server.uri('/admin/event_supporter_presence_list', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  return List<User>.from(json.decode(utf8.decode(response.bodyBytes)).map((data) => User.fromJson(data)));
}

Future<bool> event_supporter_presence_add(UserSession session, Event event, User user) async {
  final response = await http.head(
    server.uri('/admin/event_supporter_presence_add', {
      'event_id': event.id.toString(),
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_supporter_presence_remove(UserSession session, Event event, User user) async {
  final response = await http.head(
    server.uri('/admin/event_supporter_presence_remove', {
      'event_id': event.id.toString(),
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
