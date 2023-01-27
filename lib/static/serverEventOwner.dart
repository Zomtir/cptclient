// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'navigation.dart' as navi;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/json/user.dart';

Future<bool> event_edit(Session session, Slot slot) async {
  final response = await http.post(
    Uri.http(navi.serverURL, '/owner/event_edit', {
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

Future<bool> event_delete(Session session, Slot slot) async {
  final response = await http.head(
    Uri.http(navi.serverURL, '/owner/event_edit', {
      'slot_id': slot.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_submit(Session session, Slot slot) async {
  final response = await http.head(
    Uri.http(navi.serverURL, '/owner/event_submit', {
      'slot_id': slot.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_withdraw(Session session, Slot slot) async {
  final response = await http.head(
    Uri.http(navi.serverURL, '/owner/event_withdraw', {
      'slot_id': slot.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_cancel(Session session, Slot slot) async {
  final response = await http.head(
    Uri.http(navi.serverURL, '/owner/event_cancel', {
      'slot_id': slot.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_recycle(Session session, Slot slot) async {
  final response = await http.head(
    Uri.http(navi.serverURL, '/owner/event_recycle', {
      'slot_id': slot.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<User>> event_owner_list(Session session, Slot slot) async {
  final response = await http.get(
    Uri.http(navi.serverURL, '/owner/event_owner_list', {
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
    Uri.http(navi.serverURL, '/owner/event_owner_add', {
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
    Uri.http(navi.serverURL, '/owner/event_owner_remove', {
      'slot_id': slot.id.toString(),
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}