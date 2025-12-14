// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/affiliation.dart';
import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<Affiliation>>> affiliation_list(UserSession session, User? user, Organisation? organisation) async {
  final response = await client.get(
    uri('/admin/affiliation_list', {
      'user_id': user?.id.toString(),
      'organisation_id': organisation?.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<Affiliation>.from(it.map((model) => Affiliation.fromJson(model)));
  return Success(list);
}

Future<Result<Affiliation>> affiliation_info(UserSession session, int user_id, int organisation_id) async {
  final response = await client.get(
    uri('/admin/affiliation_info', {
      'user_id': user_id.toString(),
      'organisation_id': organisation_id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  var body = json.decode(utf8.decode(response.bodyBytes));
  return Success(Affiliation.fromJson(body));
}

Future<Result> affiliation_create(UserSession session, User user, Organisation organisation) async {
  final response = await client.head(
    uri('/admin/affiliation_create', {
      'user_id': user.id.toString(),
      'organisation_id': organisation.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> affiliation_edit(UserSession session, Affiliation affiliation) async {
  final response = await client.post(
    uri('/admin/affiliation_edit', {
      'user_id': affiliation.user?.id.toString(),
      'organisation_id': affiliation.organisation?.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(affiliation),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> affiliation_delete(UserSession session, Affiliation affiliation) async {
  final response = await client.head(
    uri('/admin/affiliation_delete', {
      'user_id': affiliation.user?.id.toString(),
      'organisation_id': affiliation.organisation?.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}
