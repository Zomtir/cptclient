// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/competence.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<List<Competence>> competence_list(Session session) async {
  final response = await http.get(
    server.uri('/regular/competence_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Competence>.from(l.map((model) => Competence.fromJson(model)));
}

Future<List<(Skill, int)>> competence_summary(Session session) async {
  final response = await http.get(
    server.uri('/regular/competence_summary'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<(Skill, int)>.from(l.map((model) {
    Skill skill = Skill.fromJson(model[0]);
    int rank = model[1];
    return (skill, rank);
  }));
}
