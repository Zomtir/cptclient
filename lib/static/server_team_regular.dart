// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<List<Team>> team_list(UserSession session) async {
  final response = await http.get(
    server.uri('/admin/team_list'),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Team>.from(l.map((model) => Team.fromJson(model)));
}
