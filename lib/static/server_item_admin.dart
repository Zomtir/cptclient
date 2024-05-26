// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/possession.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/stock.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<List<Item>> item_list(Session session) async {
  final response = await http.get(
    server.uri('/admin/item_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Item>.from(l.map((model) => Item.fromJson(model)));
}

Future<bool> item_create(Session session, Item item) async {
  final response = await http.post(
    server.uri('/admin/item_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(item),
  );

  return (response.statusCode == 200);
}

Future<bool> item_edit(Session session, Item item) async {
  final response = await http.post(
    server.uri('/admin/item_edit'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(item),
  );

  return (response.statusCode == 200);
}

Future<bool> item_delete(Session session, Item item) async {
  final response = await http.head(
    server.uri('/admin/item_delete', {
      'item_id': item.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> item_loan(Session session, Stock stock, User user) async {
  final response = await http.head(
    server.uri('/admin/item_loan', {
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

Future<bool> item_return(Session session, Possession possession) async {
  final response = await http.head(
    server.uri('/admin/item_return', {
      'possession_id': possession.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> item_handout(Session session, Possession possession) async {
  final response = await http.head(
    server.uri('/admin/item_handout', {
      'possession_id': possession.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> item_handback(Session session, Possession possession) async {
  final response = await http.head(
    server.uri('/admin/item_handback', {
      'possession_id': possession.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
