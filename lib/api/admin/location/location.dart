// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/session.dart';

Future<List<Location>> location_list(UserSession session) async {
  final response = await client.get(
    uri('/admin/location_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Location>.from(l.map((model) => Location.fromJson(model)));
}

Future<bool> location_create(UserSession session, Location location) async {
  final response = await client.post(
    uri('/admin/location_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(location),
  );

  return (response.statusCode == 200);
}

Future<bool> location_edit(UserSession session, Location location) async {
  final response = await client.post(
    uri('/admin/location_edit'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(location),
  );

  return (response.statusCode == 200);
}

Future<bool> location_delete(UserSession session, Location location) async {
  final response = await client.head(
    uri('/admin/location_delete', {'location': location.id.toString()}),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
