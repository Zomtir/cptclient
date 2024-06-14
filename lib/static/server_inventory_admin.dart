// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/possession.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/stock.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<List<Stock>> stock_list(UserSession session, Club club) async {
  final response = await http.get(
    server.uri('/admin/stock_list', {
      'club_id': club.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Stock>.from(l.map((model) => Stock.fromJson(model)));
}

Future<bool> stock_edit(UserSession session, Stock stock) async {
  final response = await http.post(
    server.uri('/admin/stock_edit', {
      'club_id': stock.club.id.toString(),
      'item_id': stock.item.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(stock),
  );

  return (response.statusCode == 200);
}

Future<List<Possession>> possession_list(UserSession session, User? user, Item? item, bool? owned, Club? club) async {
  final response = await http.get(
    server.uri('/admin/possession_list', {
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
  final response = await http.head(
    server.uri('/admin/possession_create', {
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
  final response = await http.head(
    server.uri('/admin/possession_delete', {
      'possession_id': possession.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
