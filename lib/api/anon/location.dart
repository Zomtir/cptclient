// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/location.dart';
import 'package:cptclient/static/server.dart';
import 'package:http/http.dart' as http;

Future<List<Location>> location_list() async {
  final response = await http.get(
    uri('/anon/location_list'),
    headers: {
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Location>.from(l.map((model) => Location.fromJson(model)));
}