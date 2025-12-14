// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<Location>>> location_list(UserSession session) async {
  final response = await client.get(
    uri('/admin/location_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<Location>.from(it.map((model) => Location.fromJson(model)));
  return Success(list);
}

Future<Result> location_create(UserSession session, Location location) async {
  final response = await client.post(
    uri('/admin/location_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(location),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> location_edit(UserSession session, Location location) async {
  final response = await client.post(
    uri('/admin/location_edit', {
      'location_id': location.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(location),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> location_delete(UserSession session, Location location) async {
  final response = await client.head(
    uri('/admin/location_delete', {
      'location_id': location.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}
