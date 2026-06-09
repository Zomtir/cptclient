// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/discipline.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<Discipline>>> discipline_list(UserSession session) async {
  final response = await client.get(
    uri('/admin/discipline_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<Discipline>.from(it.map((model) => Discipline.fromJson(model)));
  return Success(list);
}

Future<Result> discipline_create(UserSession session, Discipline discipline) async {
  final response = await client.post(
    uri('/admin/discipline_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(discipline),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> discipline_edit(UserSession session, Discipline discipline) async {
  final response = await client.post(
    uri('/admin/discipline_edit', {
      'discipline_id': discipline.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(discipline),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> discipline_delete(UserSession session, Discipline discipline) async {
  final response = await client.head(
    uri('/admin/discipline_delete', {
      'discipline_id': discipline.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}
