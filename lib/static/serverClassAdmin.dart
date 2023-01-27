// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'navigation.dart' as navi;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/json/user.dart';

Future<List<Slot>> class_list(Session session, int courseID) async {
  final response = await http.get(
    Uri.http(navi.serverURL, '/admin/class_list', {
      'course_id': courseID.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Slot>.from(l.map((model) => Slot.fromJson(model)));
}

Future<bool> class_create(Session session, Slot slot) async {
  final response = await http.post(
    Uri.http(navi.serverURL, '/admin/class_create', {
      'course_id': slot.course_id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(slot),
  );

  return (response.statusCode == 200);
}

Future<bool> class_edit(Session session, Slot slot) async {
  final response = await http.post(
    Uri.http(navi.serverURL, '/admin/class_edit', {
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

Future<bool> class_delete(Session session, Slot slot) async {
  final response = await http.head(
    Uri.http(navi.serverURL, '/admin/class_edit', {
      'slot_id': slot.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<User>> class_owner_list(Session session, Slot slot) async {
  final response = await http.get(
    Uri.http(navi.serverURL, '/admin/class_owner_list', {
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

Future<bool> class_owner_add(Session session, Slot slot, User user) async {
  final response = await http.head(
    Uri.http(navi.serverURL, '/admin/class_owner_add', {
      'slot_id': slot.id.toString(),
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> class_owner_remove(Session session, Slot slot, User user) async {
  final response = await http.head(
    Uri.http(navi.serverURL, '/admin/class_owner_remove', {
      'slot_id': slot.id.toString(),
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}