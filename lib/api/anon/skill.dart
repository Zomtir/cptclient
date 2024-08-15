// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/skill.dart';

Future<List<Skill>> skill_list() async {
  final response = await client.get(
    uri('/anon/skill_list'),
    headers: {
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Skill>.from(l.map((model) => Skill.fromJson(model)));
}