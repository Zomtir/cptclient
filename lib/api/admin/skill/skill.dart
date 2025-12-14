// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<Skill>>> skill_list(UserSession session) async {
  final response = await client.get(
    uri('/admin/skill_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<Skill>.from(it.map((model) => Skill.fromJson(model)));
  return Success(list);
}

Future<Result> skill_create(UserSession session, Skill skill) async {
  final response = await client.post(
    uri('/admin/skill_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(skill),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> skill_edit(UserSession session, Skill skill) async {
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

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> skill_delete(UserSession session, Skill skill) async {
  final response = await client.head(
    uri('/admin/skill_delete', {
      'skill_id': skill.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}
