// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/static/format.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<List<Slot>> event_list(Session session, {DateTime? begin, DateTime? end, Status? status, Location? location, bool? courseTrue, int? courseID, int? ownerID}) async {
  final response = await http.get(
    server.uri('/admin/event_list', {
      'begin': formatWebDateTime(begin),
      'end': formatWebDateTime(end),
      'status': status?.name,
      'location_id': location?.id.toString(),
      'course_true': courseTrue?.toString(),
      'course_id': courseID?.toString(),
      'owner_id': ownerID?.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Slot>.from(l.map((model) => Slot.fromJson(model)));
}

Future<Slot?> event_info(Session session, int slotID) async {
  final response = await http.get(
    server.uri('/admin/event_info', {
      'slot_id': slotID.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  return Slot.fromJson(json.decode(utf8.decode(response.bodyBytes)));
}

Future<bool> event_create(Session session, int course_id, Slot slot) async {
  final response = await http.post(
    server.uri('/admin/event_create', {
      'course_id': course_id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(slot),
  );

  return (response.statusCode == 200);
}

Future<bool> event_edit(Session session, Slot slot) async {
  final response = await http.post(
    server.uri('/admin/event_edit', {
      'slot_id': slot.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(slot),
  );

  return (response.statusCode == 200);
}

Future<bool> event_edit_password(Session session, Slot slot, String password) async {
  if (password.isEmpty) return true;

  final response = await http.post(
    server.uri('/admin/event_edit_password', {
      'slot_id': slot.id.toString(),
    }),
    headers: {
      'Content-Type': 'text/plain; charset=utf-8',
      'Token': session.token,
    },
    body: utf8.encode(password),
  );

  return (response.statusCode == 200);
}

Future<bool> event_delete(Session session, Slot slot) async {
  final response = await http.head(
    server.uri('/admin/event_edit', {
      'slot_id': slot.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_accept(Session session, Slot slot) async {
  final response = await http.head(
    server.uri('/admin/event_accept', {
      'slot_id': slot.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_deny(Session session, Slot slot) async {
  final response = await http.head(
    server.uri('/admin/event_deny', {
      'slot_id': slot.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_suspend(Session session, Slot slot) async {
  final response = await http.head(
    server.uri('/admin/event_suspend', {
      'slot_id': slot.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<User>> event_owner_pool(Session session, Slot slot) async {
  final response = await http.get(
    server.uri('/admin/event_owner_pool', {
      'slot_id': slot.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  return List<User>.from(json.decode(utf8.decode(response.bodyBytes)).map((data) => User.fromJson(data)));
}

Future<List<User>> event_owner_list(Session session, Slot slot) async {
  final response = await http.get(
    server.uri('/admin/event_owner_list', {
      'slot_id': slot.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  return List<User>.from(json.decode(utf8.decode(response.bodyBytes)).map((data) => User.fromJson(data)));
}

Future<bool> event_owner_add(Session session, Slot slot, User user) async {
  final response = await http.head(
    server.uri('/admin/event_owner_add', {
      'slot_id': slot.id.toString(),
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_owner_remove(Session session, Slot slot, User user) async {
  final response = await http.head(
    server.uri('/admin/event_owner_remove', {
      'slot_id': slot.id.toString(),
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<User>> event_participant_pool(Session session, Slot slot) async {
  final response = await http.get(
    server.uri('/admin/event_participant_pool', {
      'slot_id': slot.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  return List<User>.from(json.decode(utf8.decode(response.bodyBytes)).map((data) => User.fromJson(data)));
}

Future<List<User>> event_participant_list(Session session, Slot slot) async {
  final response = await http.get(
    server.uri('/admin/event_participant_list', {
      'slot_id': slot.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  return List<User>.from(json.decode(utf8.decode(response.bodyBytes)).map((data) => User.fromJson(data)));
}

Future<bool> event_participant_add(Session session, Slot slot, User user) async {
  final response = await http.head(
    server.uri('/admin/event_participant_add', {
      'slot_id': slot.id.toString(),
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_participant_remove(Session session, Slot slot, User user) async {
  final response = await http.head(
    server.uri('/admin/event_participant_remove', {
      'slot_id': slot.id.toString(),
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
