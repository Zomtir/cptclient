// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/affiliation.dart';
import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';

Future<List<Affiliation>> affiliation_list(UserSession session, User? user, Organisation? organisation) async {
  final response = await client.get(
    uri('/admin/affiliation_list', {
      'user_id': user?.id.toString(),
      'organisation_id': organisation?.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable body = json.decode(utf8.decode(response.bodyBytes));
  return List<Affiliation>.from(body.map((model) => Affiliation.fromJson(model)));
}

Future<Affiliation?> affiliation_info(UserSession session, int user_id, int organisation_id) async {
  final response = await client.get(
    uri('/admin/affiliation_info', {
      'user_id': user_id.toString(),
      'organisation_id': organisation_id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return null;

  var body = json.decode(utf8.decode(response.bodyBytes));
  return Affiliation.fromJson(body);
}

Future<bool> affiliation_create(UserSession session, User user, Organisation organisation) async {
  final response = await client.head(
    uri('/admin/affiliation_create', {
      'user_id': user.id.toString(),
      'organisation_id': organisation.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> affiliation_edit(UserSession session, Affiliation affiliation) async {
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

  return (response.statusCode == 200);
}

Future<bool> affiliation_delete(UserSession session, Affiliation affiliation) async {
  final response = await client.head(
    uri('/admin/affiliation_delete', {
      'user_id': affiliation.user?.id.toString(),
      'organisation_id': affiliation.organisation?.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
