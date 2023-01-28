// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'server.dart' as server;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/ranking.dart';
import 'package:cptclient/json/skill.dart';

Future<List<Ranking>> ranking_list(Session session) async {
  final response = await http.get(
    Uri.http(server.serverURL, '/member/ranking_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(response.body);
  return List<Ranking>.from(l.map((model) => Ranking.fromJson(model)));
}

Future<List<Skill>> ranking_summary(Session session) async {
  final response = await http.get(
    Uri.http(server.serverURL, '/member/ranking_summary'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(response.body);
  return List<Skill>.from(l.map((model) => Skill.fromJson(model)));
}
