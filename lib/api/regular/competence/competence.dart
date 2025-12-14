// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/competence.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<Competence>>> competence_list(UserSession session) async {
  final response = await client.get(
    uri('/regular/competence_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<Competence>.from(it.map((model) => Competence.fromJson(model)));
  return Success(list);
}

Future<Result<List<(Skill, int)>>> competence_summary(UserSession session) async {
  final response = await client.get(
    uri('/regular/competence_summary'),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<(Skill, int)>.from(it.map((model) => (Skill.fromJson(model[0]), model[1])));
  return Success(list);
}
