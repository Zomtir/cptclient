// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/club.dart';

Future<List<Club>> club_list() async {
  final response = await client.get(
    uri('/anon/club_list'),
    headers: {
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Club>.from(l.map((model) => Club.fromJson(model)));
}

Future<List<int>?> club_banner(int clubID) async {
  final response = await client.get(
    uri('/anon/club_image', {
      'club_id': clubID.toString(),
    }),
    headers: {
      'Accept': 'image/png;',
    },
  );

  if (response.statusCode != 200) return null;

  return response.bodyBytes;
}
