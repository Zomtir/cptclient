// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<List<Skill>> skill_list(Session session) async {
  final response = await http.get(
    server.uri('/admin/skill_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Skill>.from(l.map((model) => Skill.fromJson(model)));
}

Future<bool> skill_create(Session session, Skill skill) async {
  final response = await http.post(
    server.uri('/admin/skill_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(skill),
  );

  return (response.statusCode == 200);
}

Future<bool> skill_edit(Session session, Skill skill) async {
  final response = await http.post(
    server.uri('/admin/skill_edit'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(skill),
  );

  return (response.statusCode == 200);
}

Future<bool> skill_delete(Session session, Skill skill) async {
  final response = await http.head(
    server.uri('/admin/skill_delete', {'skill': skill.id.toString()}),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
