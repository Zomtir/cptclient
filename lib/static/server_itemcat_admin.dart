// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/itemcat.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<List<ItemCategory>> itemcat_list(UserSession session) async {
  final response = await http.get(
    server.uri('/admin/itemcat_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<ItemCategory>.from(l.map((model) => ItemCategory.fromJson(model)));
}

Future<bool> itemcat_create(UserSession session, ItemCategory category) async {
  final response = await http.post(
    server.uri('/admin/itemcat_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(category),
  );

  return (response.statusCode == 200);
}

Future<bool> itemcat_edit(UserSession session, ItemCategory category) async {
  final response = await http.post(
    server.uri('/admin/itemcat_edit', {
      'category_id': category.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(category),
  );

  return (response.statusCode == 200);
}

Future<bool> itemcat_delete(UserSession session, ItemCategory category) async {
  final response = await http.head(
    server.uri('/admin/itemcat_delete', {
      'category_id': category.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
