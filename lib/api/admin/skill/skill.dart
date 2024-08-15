// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';

Future<List<Skill>> skill_list(UserSession session) async {
  final response = await client.get(
    uri('/admin/skill_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Skill>.from(l.map((model) => Skill.fromJson(model)));
}

Future<bool> skill_create(UserSession session, Skill skill) async {
  final response = await client.post(
    uri('/admin/skill_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(skill),
  );

  return (response.statusCode == 200);
}

Future<bool> skill_edit(UserSession session, Skill skill) async {
  final response = await client.post(
    uri('/admin/skill_edit', {
      'skill_id': skill.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(skill),
  );

  return (response.statusCode == 200);
}

Future<bool> skill_delete(UserSession session, Skill skill) async {
  final response = await client.head(
    uri('/admin/skill_delete', {
      'skill_id': skill.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
