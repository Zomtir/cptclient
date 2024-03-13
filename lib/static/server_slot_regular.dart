// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<List<Slot>> slot_list(Session session, DateTime begin, DateTime end) async {

  return [
    Slot(
      id: 0,
      key: "test",
      title: "Placeholder 1",
      begin: DateTime(2024, 3, 12, 10, 10),
      end: DateTime(2024, 3, 12, 18, 18),
      public: true,
      scrutable: true,
      note: "hi",
    ),
    Slot(
      id: 0,
      key: "test",
      title: "Placeholder 2",
      begin: DateTime(2024, 3, 5, 10, 10),
      end: DateTime(2024, 3, 13, 18, 18),
      public: true,
      scrutable: true,
      note: "hi",
    ),
  ];
  /*
  final response = await http.get(
    server.uri('/regular/slot_info'),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Slot>.from(l.map((model) => Slot.fromJson(model)));
  */
}

Future<Slot?> slot_info(Session session) async {
  final response = await http.get(
    server.uri('/regular/slot_info'),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  return Slot.fromJson(json.decode(utf8.decode(response.bodyBytes)));
}
