// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/static/format.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<List<Event>> event_list(Session session, DateTime begin, DateTime end, Status? status, Location? location) async {
  final response = await http.get(
    server.uri('/owner/event_list', {
      'begin': formatWebDateTime(begin),
      'end': formatWebDateTime(end),
      if (status != null) 'status': status.name,
      if (location != null) 'location_id': location.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Event>.from(l.map((model) => Event.fromJson(model)));
}

Future<Event?> event_info(Session session, int eventID) async {
  final response = await http.get(
    server.uri('/owner/event_info', {
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

Future<bool> event_edit(Session session, Event event) async {
  final response = await http.post(
    server.uri('/owner/event_edit', {
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

Future<bool> event_password_edit(Session session, Event event, String password) async {
  if (password.isEmpty) return true;

  final response = await http.post(
    server.uri('/owner/event_password_edit', {
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

Future<bool> event_delete(Session session, Event event) async {
  final response = await http.head(
    server.uri('/owner/event_edit', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_submit(Session session, Event event) async {
  final response = await http.head(
    server.uri('/owner/event_submit', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_withdraw(Session session, Event event) async {
  final response = await http.head(
    server.uri('/owner/event_withdraw', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_cancel(Session session, Event event) async {
  final response = await http.head(
    server.uri('/owner/event_cancel', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_recycle(Session session, Event event) async {
  final response = await http.head(
    server.uri('/owner/event_recycle', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<User>> event_owner_list(Session session, Event event) async {
  final response = await http.get(
    server.uri('/owner/event_owner_list', {
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

Future<bool> event_owner_add(Session session, Event event, User user) async {
  final response = await http.head(
    server.uri('/owner/event_owner_add', {
      'event_id': event.id.toString(),
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_owner_remove(Session session, Event event, User user) async {
  final response = await http.head(
    server.uri('/owner/event_owner_remove', {
      'event_id': event.id.toString(),
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<User>> event_participant_list(Session session, Event event) async {
  final response = await http.get(
    server.uri('/owner/event_participant_list', {
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

Future<bool> event_participant_add(Session session, Event event, User user) async {
  final response = await http.head(
    server.uri('/owner/event_participant_add', {
      'event_id': event.id.toString(),
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_participant_remove(Session session, Event event, User user) async {
  final response = await http.head(
    server.uri('/owner/event_participant_remove', {
      'event_id': event.id.toString(),
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
