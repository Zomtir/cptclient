// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/itemcat.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<ItemCategory>>> itemcat_list(UserSession session) async {
  final response = await client.get(
    uri('/admin/itemcat_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<ItemCategory>.from(it.map((model) => ItemCategory.fromJson(model)));
  return Success(list);
}


Future<Result> itemcat_create(UserSession session, ItemCategory category) async {
  final response = await client.post(
    uri('/admin/itemcat_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(category),
  );

  if (handleFailedResponse(response)) return Failure();

  return Success(());
}

Future<Result> itemcat_edit(UserSession session, ItemCategory category) async {
  final response = await client.post(
    uri('/admin/itemcat_edit', {
      'category_id': category.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(category),
  );

  if (handleFailedResponse(response)) return Failure();

  return Success(());
}

Future<Result> itemcat_delete(UserSession session, ItemCategory category) async {
  final response = await client.head(
    uri('/admin/itemcat_delete', {
      'category_id': category.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  return Success(());
}
