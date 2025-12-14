// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/possession.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/stock.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<Item>>> item_list(UserSession session) async {
  final response = await client.get(
    uri('/admin/item_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<Item>.from(it.map((model) => Item.fromJson(model)));
  return Success(list);
}

Future<Result<Item>> item_info(UserSession session, int itemID) async {
  final response = await client.get(
    uri('/admin/item_info', {
      'item_id': itemID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  var body = json.decode(utf8.decode(response.bodyBytes));
  var object = Item.fromJson(body);
  return Success(object);
}

Future<Result> item_create(UserSession session, Item item) async {
  final response = await client.post(
    uri('/admin/item_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(item),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> item_edit(UserSession session, int itemID, Item item) async {
  final response = await client.post(
    uri('/admin/item_edit', {
      'item_id': itemID.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(item),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> item_delete(UserSession session, int itemID) async {
  final response = await client.head(
    uri('/admin/item_delete', {
      'item_id': itemID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> item_loan(UserSession session, Stock stock, User user) async {
  final response = await client.head(
    uri('/admin/item_loan', {
      'stock_id': stock.id.toString(),
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> item_return(UserSession session, Possession possession) async {
  final response = await client.head(
    uri('/admin/item_return', {
      'possession_id': possession.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> item_handout(UserSession session, Possession possession) async {
  final response = await client.head(
    uri('/admin/item_handout', {
      'possession_id': possession.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> item_restock(UserSession session, Possession possession, Stock stock) async {
  final response = await client.head(
    uri('/admin/item_restock', {
      'possession_id': possession.id.toString(),
      'stock_id': stock.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}
