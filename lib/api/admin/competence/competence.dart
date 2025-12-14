// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/competence.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<Competence>>> competence_list(UserSession session, User? user, Skill? skill) async {
  final response = await client.get(
    uri('/admin/competence_list', {
      if (user != null) 'user_id': user.id.toString(),
      if (skill != null) 'skill_id': skill.id.toString(),
      if (skill != null) 'min': '0',
      if (skill != null) 'max': '0',
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<Competence>.from(it.map((model) => Competence.fromJson(model)));
  return Success(list);
}

Future<Result<Competence>> competence_info(UserSession session, int competenceID) async {
  final response = await client.get(
    uri('/admin/competence_info', {
      'competence_id': competenceID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  var body = json.decode(utf8.decode(response.bodyBytes));
  var object = Competence.fromJson(body);
  return Success(object);
}

Future<Result> competence_create(UserSession session, Competence ranking) async {
  final response = await client.post(
    uri('/admin/competence_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(ranking),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> competence_edit(UserSession session, int competenceID, Competence competence) async {
  final response = await client.post(
    uri('/admin/competence_edit', {
      'competence_id': competenceID.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(competence),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> competence_delete(UserSession session, int competenceID) async {
  final response = await client.head(
    uri('/admin/competence_delete', {
      'competence_id': competenceID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}
