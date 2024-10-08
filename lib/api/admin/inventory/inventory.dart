// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/possession.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/stock.dart';
import 'package:cptclient/json/user.dart';

Future<List<Stock>> stock_list(UserSession session, Club? club, Item? item) async {
  final response = await client.get(
    uri('/admin/stock_list', {
      'club_id': club?.id.toString(),
      'item_id': item?.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Stock>.from(l.map((model) => Stock.fromJson(model)));
}

Future<bool> stock_create(UserSession session, Stock stock) async {
  final response = await client.post(
    uri('/admin/stock_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(stock),
  );

  return (response.statusCode == 200);
}

Future<bool> stock_edit(UserSession session, Stock stock) async {
  final response = await client.post(
    uri('/admin/stock_edit', {
      'stock_id': stock.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(stock),
  );

  return (response.statusCode == 200);
}

Future<bool> stock_delete(UserSession session, Stock stock) async {
  final response = await client.head(
    uri('/admin/stock_delete', {
      'stock_id': stock.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<Possession>> possession_list(UserSession session, User? user, Item? item, bool? owned, Club? club) async {
  final response = await client.get(
    uri('/admin/possession_list', {
      'user_id': user?.id.toString(),
      'item_id': item?.id.toString(),
      'owned': owned?.toString(),
      'club_id': club?.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Possession>.from(l.map((model) => Possession.fromJson(model)));
}

Future<bool> possession_create(UserSession session, User user, Item item) async {
  final response = await client.head(
    uri('/admin/possession_create', {
      'user_id': user.id.toString(),
      'item_id': item.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> possession_delete(UserSession session, Possession possession) async {
  final response = await client.head(
    uri('/admin/possession_delete', {
      'possession_id': possession.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
