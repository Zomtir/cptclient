// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/static/format.dart';
import 'package:cptclient/static/message.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<List<Event>> event_list(Session session, {DateTime? begin, DateTime? end, Location? location, Status? status, bool? courseTrue, int? courseID}) async {
  final response = await http.get(
    server.uri('/regular/event_list', {
      'begin': formatWebDateTime(begin),
      'end': formatWebDateTime(end),
      'location_id' : location?.id.toString(),
      'status': status?.name,
      'course_true' : courseTrue?.toString(),
      'course_id': courseID?.toString(),
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Event>.from(l.map((model) => Event.fromJson(model)));
}

Future<bool> event_create(Session session, Event event) async {
  if (event.key.isEmpty) return false;

  final response = await http.post(
    server.uri('/regular/event_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(event),
  );

  bool success = (response.statusCode == 200);
  messageSuccess(success);
  return success;
}

Future<bool> event_owner_true(Session session, Event event) async {
  final response = await http.get(
    server.uri('/regular/event_owner_true', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return false;

  return json.decode(utf8.decode(response.bodyBytes)) as bool;
}

Future<bool?> event_participant_true(Session session, Event event) async {
  final response = await http.get(
    server.uri('/regular/event_participant_true', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return null;

  return json.decode(utf8.decode(response.bodyBytes)) as bool;
}

Future<bool> event_participant_add(Session session, Event event) async {
  final response = await http.head(
    server.uri('/regular/event_participant_add', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_participant_remove(Session session, Event event) async {
  final response = await http.head(
    server.uri('/regular/event_participant_remove', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool?> event_bookmark_true(Session session, Event event) async {
  final response = await http.get(
    server.uri('/regular/event_bookmark_true', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return null;

  return json.decode(utf8.decode(response.bodyBytes)) as bool;
}

Future<bool> event_bookmark_edit(Session session, Event event, bool bookmark) async {
  final response = await http.head(
    server.uri('/regular/event_bookmark_edit', {
      'event_id': event.id.toString(),
      'bookmark': bookmark.toString(),
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  return (response.statusCode != 200);
}
