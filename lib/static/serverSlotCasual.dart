// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/json/user.dart';

Future<Slot?> slot_info(String token) async {
  final response = await http.get(
    Uri.http(server.serverURL, '/slot/slot_info'),
    headers: {
      'Token': token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  return Slot.fromJson(json.decode(utf8.decode(response.bodyBytes)));
}

Future<List<User>> slot_candidates(Session session) async {
  final response = await http.get(
    Uri.http(server.serverURL, '/slot/slot_candidate_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(response.body);
  return List<User>.from(l.map((model) => User.fromJson(model)));
}

Future<List<User>> slot_participants(Session session) async {
  final response = await http.get(
    Uri.http(server.serverURL, '/slot/slot_participant_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(response.body);
  return List<User>.from(l.map((model) => User.fromJson(model)));
}

Future<bool> slot_participant_add(Session session, User user) async {
  final response = await http.head(
    Uri.http(server.serverURL, '/slot/slot_participant_add', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> slot_participant_remove(Session session, User user) async {
  final response = await http.head(
    Uri.http(server.serverURL, '/slot/slot_participant_remove', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
