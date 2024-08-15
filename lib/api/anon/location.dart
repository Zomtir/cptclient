// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/location.dart';

Future<List<Location>> location_list() async {
  final response = await client.get(
    uri('/anon/location_list'),
    headers: {
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Location>.from(l.map((model) => Location.fromJson(model)));
}