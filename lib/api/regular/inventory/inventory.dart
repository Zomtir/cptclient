// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/itemcat.dart';
import 'package:cptclient/json/possession.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/static/client.dart';

Future<List<Possession>> possession_list(UserSession session, bool? owned, Club? club) async {
  final response = await client.get(
    uri('/regular/possession_list', {
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

Future<List<ItemCategory>> itemcat_list(UserSession session) async {
  final response = await client.get(
    uri('/regular/itemcat_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<ItemCategory>.from(l.map((model) => ItemCategory.fromJson(model)));
}
