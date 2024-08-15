// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/acceptance.dart';
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/occurrence.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/utils/format.dart';

export 'leader.dart';
export 'owner.dart';
export 'participant.dart';
export 'supporter.dart';

Future<List<Event>> event_list(UserSession session, DateTime begin, DateTime end, Location? location,
    Occurrence? occurence, Acceptance? acceptance) async {
  final response = await client.get(
    uri('/owner/event_list', {
      'begin': formatWebDateTime(begin.toUtc()),
      'end': formatWebDateTime(end.toUtc()),
      'occurence': occurence?.name,
      'acceptance': acceptance?.name,
      'location_id': location?.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Event>.from(l.map((model) => Event.fromJson(model)));
}

Future<Event?> event_info(UserSession session, int eventID) async {
  final response = await client.get(
    uri('/owner/event_info', {
      'event_id': eventID.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  return Event.fromJson(json.decode(utf8.decode(response.bodyBytes)));
}

Future<bool> event_edit(UserSession session, Event event) async {
  final response = await client.post(
    uri('/owner/event_edit', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(event),
  );

  return (response.statusCode == 200);
}

Future<bool> event_password_edit(UserSession session, Event event, String password) async {
  if (password.isEmpty) return true;

  final response = await client.post(
    uri('/owner/event_password_edit', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Content-Type': 'text/plain; charset=utf-8',
      'Token': session.token,
    },
    body: utf8.encode(password),
  );

  return (response.statusCode == 200);
}

Future<int?> event_course_info(UserSession session, Event event) async {
  final response = await client.get(
    uri('/owner/event_course_info', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<bool> event_course_edit(UserSession session, Event event, Course? course) async {
  final response = await client.head(
    uri('/owner/event_course_edit', {
      'event_id': event.id.toString(),
      'course_id': course?.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_delete(UserSession session, Event event) async {
  final response = await client.head(
    uri('/owner/event_delete', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_submit(UserSession session, Event event) async {
  final response = await client.head(
    uri('/owner/event_submit', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_withdraw(UserSession session, Event event) async {
  final response = await client.head(
    uri('/owner/event_withdraw', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
