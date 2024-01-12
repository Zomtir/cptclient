// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<List<Slot>> class_list(Session session, int courseID) async {
  final response = await http.get(
    server.uri('/regular/class_list', {
      'course_id': courseID.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Slot>.from(l.map((model) => Slot.fromJson(model)));
}

Future<bool> class_participant_add(Session session, Slot slot) async {
  final response = await http.head(
    server.uri('/regular/class_participant_add', {
      'slot_id': slot.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> class_participant_remove(Session session, Slot slot) async {
  final response = await http.head(
    server.uri('/regular/class_participant_remove', {
      'slot_id': slot.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
