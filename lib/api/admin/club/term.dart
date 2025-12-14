// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/term.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<Term>>> term_list(UserSession session, Club? club) async {
  final response = await client.get(
    uri('/admin/term_list', {
      'club_id': club?.id.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<Term>.from(it.map((model) => Term.fromJson(model)));
  return Success(list);
}

Future<Result<Term>> term_info(UserSession session, int termID) async {
  final response = await client.get(
    uri('/admin/term_info', {
      'term_id': termID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  var body = json.decode(utf8.decode(response.bodyBytes));
  var object = Term.fromJson(body);
  return Success(object);
}

Future<Result> term_create(UserSession session, Term term) async {
  final response = await client.post(
    uri('/admin/term_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(term),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> term_edit(UserSession session, Term term) async {
  final response = await client.post(
    uri('/admin/term_edit', {
      'term_id': term.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(term),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> term_delete(UserSession session, int termID) async {
  final response = await client.head(
    uri('/admin/term_delete', {
      'term_id': termID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}
