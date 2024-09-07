// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/session.dart';

Future<List<Organisation>> organisation_list(UserSession session) async {
  final response = await client.get(
    uri('/admin/organisation_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Organisation>.from(l.map((model) => Organisation.fromJson(model)));
}

Future<bool> organisation_create(UserSession session, Organisation organisation) async {
  final response = await client.post(
    uri('/admin/organisation_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(organisation),
  );

  return (response.statusCode == 200);
}

Future<bool> organisation_edit(UserSession session, Organisation organisation) async {
  final response = await client.post(
    uri('/admin/organisation_edit'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(organisation),
  );

  return (response.statusCode == 200);
}

Future<bool> organisation_delete(UserSession session, Organisation organisation) async {
  final response = await client.head(
    uri('/admin/organisation_delete', {'organisation': organisation.id.toString()}),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
