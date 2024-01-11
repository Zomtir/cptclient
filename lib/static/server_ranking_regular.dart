// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/ranking.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<List<Ranking>> ranking_list(Session session) async {
  final response = await http.get(
    server.uri('/regular/ranking_list'),
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
    server.uri('/regular/ranking_summary'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(response.body);
  return List<Skill>.from(l.map((model) => Skill.fromJson(model)));
}
