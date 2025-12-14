// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<Organisation>>> organisation_list(UserSession session) async {
  final response = await client.get(
    uri('/admin/organisation_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<Organisation>.from(it.map((model) => Organisation.fromJson(model)));
  return Success(list);
}

Future<Result> organisation_create(UserSession session, Organisation organisation) async {
  final response = await client.post(
    uri('/admin/organisation_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(organisation),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> organisation_edit(UserSession session, Organisation organisation) async {
  final response = await client.post(
    uri('/admin/organisation_edit'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(organisation),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> organisation_delete(UserSession session, Organisation organisation) async {
  final response = await client.head(
    uri('/admin/organisation_delete', {'organisation': organisation.id.toString()}),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}
