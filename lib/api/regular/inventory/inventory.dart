// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/itemcat.dart';
import 'package:cptclient/json/possession.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<Possession>>> possession_list(UserSession session, bool? owned, Club? club) async {
  final response = await client.get(
    uri('/regular/possession_list', {
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

Future<Result<List<ItemCategory>>> itemcat_list(UserSession session) async {
  final response = await client.get(
    uri('/regular/itemcat_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<ItemCategory>.from(it.map((model) => ItemCategory.fromJson(model)));
  return Success(list);
}
