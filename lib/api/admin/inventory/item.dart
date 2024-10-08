// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/possession.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/stock.dart';
import 'package:cptclient/json/user.dart';

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
      'stock_id': stock.id.toString(),
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

Future<bool> item_restock(UserSession session, Possession possession, Stock stock) async {
  final response = await client.head(
    uri('/admin/item_restock', {
      'possession_id': possession.id.toString(),
      'stock_id': stock.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
