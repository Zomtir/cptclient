// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/ranking.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<List<Ranking>> ranking_list(Session session, User? user, Skill? skill) async {
  final response = await http.get(
    server.uri('/admin/ranking_list', {
      if (user != null) 'user_id': user.id.toString(),
      if (skill != null) 'branch_id': skill.branch.id,
      if (skill != null) 'min': '0',
      if (skill != null) 'max': '0'}),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(response.body);
  return List<Ranking>.from(l.map((model) => Ranking.fromJson(model)));
}

Future<bool> ranking_create(Session session, Ranking ranking) async {
  final response = await http.post(
    server.uri('ranking_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(ranking),
  );

  return (response.statusCode == 200);
}

Future<bool> ranking_edit(Session session, Ranking ranking) async {
  final response = await http.post(
    server.uri('ranking_edit'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(ranking),
  );

  return (response.statusCode == 200);
}

Future<bool> ranking_delete(Session session, Ranking ranking) async {
  final response = await http.head(
    server.uri('ranking_delete', {'ranking': ranking.id.toString()}),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
