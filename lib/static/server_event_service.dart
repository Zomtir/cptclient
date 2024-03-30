// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<Event?> event_info(Session session) async {
  final response = await http.get(
    server.uri('/service/event_info'),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  return Event.fromJson(json.decode(utf8.decode(response.bodyBytes)));
}

Future<bool?> event_note_edit(Session session, String note) async {
  final response = await http.post(
    server.uri('/service/event_note_edit'),
    headers: {
      'Token': session.token,
      'Content-Type': 'text/plain; charset=utf-8',
    },
    body: utf8.encode(note),
  );

  return (response.statusCode == 200);
}

Future<List<User>> event_participant_pool(Session session) async {
  final response = await http.get(
    server.uri('/service/event_participant_pool'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(l.map((model) => User.fromJson(model)));
}

Future<List<User>> event_participant_list(Session session) async {
  final response = await http.get(
    server.uri('/service/event_participant_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(l.map((model) => User.fromJson(model)));
}

Future<bool> event_participant_add(Session session, User user) async {
  final response = await http.head(
    server.uri('/service/event_participant_add', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_participant_remove(Session session, User user) async {
  final response = await http.head(
    server.uri('/service/event_participant_remove', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<User>> event_owner_pool(Session session) async {
  final response = await http.get(
    server.uri('/service/event_owner_pool'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(l.map((model) => User.fromJson(model)));
}

Future<List<User>> event_owner_list(Session session) async {
  final response = await http.get(
    server.uri('/service/event_owner_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(l.map((model) => User.fromJson(model)));
}

Future<bool> event_owner_add(Session session, User user) async {
  final response = await http.head(
    server.uri('/service/event_owner_add', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_owner_remove(Session session, User user) async {
  final response = await http.head(
    server.uri('/service/event_owner_remove', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}