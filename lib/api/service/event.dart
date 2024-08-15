// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';

Future<Event?> event_info(EventSession session) async {
  final response = await client.get(
    uri('/service/event_info'),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  return Event.fromJson(json.decode(utf8.decode(response.bodyBytes)));
}

Future<bool?> event_note_edit(EventSession session, String note) async {
  final response = await client.post(
    uri('/service/event_note_edit'),
    headers: {
      'Token': session.token,
      'Content-Type': 'text/plain; charset=utf-8',
    },
    body: utf8.encode(note),
  );

  return (response.statusCode == 200);
}

Future<List<User>> event_participant_presence_pool(EventSession session) async {
  final response = await client.get(
    uri('/service/event_participant_presence_pool'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(l.map((model) => User.fromJson(model)));
}

Future<List<User>> event_participant_presence_list(EventSession session) async {
  final response = await client.get(
    uri('/service/event_participant_presence_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(l.map((model) => User.fromJson(model)));
}

Future<bool> event_participant_presence_add(EventSession session, User user) async {
  final response = await client.head(
    uri('/service/event_participant_presence_add', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_participant_presence_remove(EventSession session, User user) async {
  final response = await client.head(
    uri('/service/event_participant_presence_remove', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<User>> event_supporter_presence_pool(EventSession session) async {
  final response = await client.get(
    uri('/service/event_supporter_presence_pool'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(l.map((model) => User.fromJson(model)));
}

Future<List<User>> event_supporter_presence_list(EventSession session) async {
  final response = await client.get(
    uri('/service/event_supporter_presence_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(l.map((model) => User.fromJson(model)));
}

Future<bool> event_supporter_presence_add(EventSession session, User user) async {
  final response = await client.head(
    uri('/service/event_supporter_presence_add', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_supporter_presence_remove(EventSession session, User user) async {
  final response = await client.head(
    uri('/service/event_supporter_presence_remove', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<User>> event_leader_presence_pool(EventSession session) async {
  final response = await client.get(
    uri('/service/event_leader_presence_pool'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(l.map((model) => User.fromJson(model)));
}

Future<List<User>> event_leader_presence_list(EventSession session) async {
  final response = await client.get(
    uri('/service/event_leader_presence_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(l.map((model) => User.fromJson(model)));
}

Future<bool> event_leader_presence_add(EventSession session, User user) async {
  final response = await client.head(
    uri('/service/event_leader_presence_add', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_leader_presence_remove(EventSession session, User user) async {
  final response = await client.head(
    uri('/service/event_leader_presence_remove', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}