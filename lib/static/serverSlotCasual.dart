// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/json/user.dart';

Future<Slot?> slot_info(String token) async {
  final response = await http.get(
    Uri.http(server.serverURL, '/casual/slot_info'),
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
    Uri.http(server.serverURL, 'slot_candidates'),
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
    Uri.http(server.serverURL, 'slot_participants'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(response.body);
  return List<User>.from(l.map((model) => User.fromJson(model)));
}