// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/possession.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/stock.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/static/client.dart';

Future<List<Item>> item_list(UserSession session) async {
  final response = await client.get(
    uri('/admin/item_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Item>.from(l.map((model) => Item.fromJson(model)));
}

Future<bool> item_create(UserSession session, Item item) async {
  final response = await client.post(
    uri('/admin/item_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(item),
  );

  return (response.statusCode == 200);
}

Future<bool> item_edit(UserSession session, Item item) async {
  final response = await client.post(
    uri('/admin/item_edit', {
      'item_id': item.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(item),
  );

  return (response.statusCode == 200);
}

Future<bool> item_delete(UserSession session, Item item) async {
  final response = await client.head(
    uri('/admin/item_delete', {
      'item_id': item.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> item_loan(UserSession session, Stock stock, User user) async {
  final response = await client.head(
    uri('/admin/item_loan', {
      'club_id': stock.club.id.toString(),
      'item_id': stock.item.id.toString(),
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> item_return(UserSession session, Possession possession) async {
  final response = await client.head(
    uri('/admin/item_return', {
      'possession_id': possession.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> item_handout(UserSession session, Possession possession) async {
  final response = await client.head(
    uri('/admin/item_handout', {
      'possession_id': possession.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> item_handback(UserSession session, Possession possession) async {
  final response = await client.head(
    uri('/admin/item_handback', {
      'possession_id': possession.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
