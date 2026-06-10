// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/equipment.dart';
import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/possession.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/json/stock.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<Stock>>> stock_list(UserSession session, Club? club, Item? item) async {
  final response = await client.get(
    uri('/admin/stock_list', {
      'club_id': club?.id.toString(),
      'item_id': item?.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<Stock>.from(it.map((model) => Stock.fromJson(model)));
  return Success(list);
}

Future<Result> stock_create(UserSession session, Stock stock) async {
  final response = await client.post(
    uri('/admin/stock_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(stock),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> stock_edit(UserSession session, Stock stock) async {
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

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> stock_delete(UserSession session, Stock stock) async {
  final response = await client.head(
    uri('/admin/stock_delete', {
      'stock_id': stock.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result<List<Possession>>> possession_list(UserSession session, User? user, Item? item, bool? owned, Club? club) async {
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

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<Possession>.from(it.map((model) => Possession.fromJson(model)));
  return Success(list);
}

Future<Result> possession_create(UserSession session, User user, Item item) async {
  final response = await client.head(
    uri('/admin/possession_create', {
      'user_id': user.id.toString(),
      'item_id': item.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> possession_delete(UserSession session, Possession possession) async {
  final response = await client.head(
    uri('/admin/possession_delete', {
      'possession_id': possession.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result<List<Equipment>>> equipment_list(UserSession session, User? user, Skill? skill, Item? item) async {
  final response = await client.get(
    uri('/admin/user_equipment_list', {
      'user_id': user?.id.toString(),
      'skill_id': skill?.id.toString(),
      'item_id': item?.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<Equipment>.from(it.map((model) => Equipment.fromJson(model)));
  return Success(list);
}

Future<Result<Equipment>> equipment_info(UserSession session, int equipment_id) async {
  final response = await client.get(
    uri('/admin/user_equipment_info', {
      'equipment_id': equipment_id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  var body = json.decode(utf8.decode(response.bodyBytes));
  var item = Equipment.fromJson(body);
  return Success(item);
}

Future<Result> equipment_create(UserSession session, User user, Skill skill, Item item, int count) async {
  final response = await client.head(
    uri('/admin/user_equipment_create', {
      'user_id': user.id.toString(),
      'skill_id': skill.id.toString(),
      'item_id': item.id.toString(),
      'count': count.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> equipment_edit(UserSession session, int equipment_id, int count) async {
  final response = await client.head(
    uri('/admin/user_equipment_edit', {
      'equipment_id': equipment_id.toString(),
      'count': count.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> equipment_delete(UserSession session, Equipment equipment) async {
  final response = await client.head(
    uri('/admin/user_equipment_delete', {
      'equipment_id': equipment.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}