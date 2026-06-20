// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/term_discipline.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result> term_discipline_create(UserSession session, int termID, TermDiscipline termDiscipline) async {
  final response = await client.post(
    uri('/admin/term_discipline_create', {
      'term_id': termID.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(termDiscipline),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> term_discipline_edit(UserSession session, TermDiscipline termDiscipline) async {
  final response = await client.post(
    uri('/admin/term_discipline_edit', {
      'term_discipline_id': termDiscipline.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(termDiscipline),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> term_discipline_delete(UserSession session, int termDisciplineID) async {
  final response = await client.head(
    uri('/admin/term_discipline_delete', {
      'term_discipline_id': termDisciplineID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}
