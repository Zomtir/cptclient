// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/json/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';

import 'format.dart';

Future<List<Slot>> event_list(Session session, DateTime begin, DateTime end, Location? location, Status? status) async {
  final response = await http.get(
    server.uri('/member/event_list', {
      'begin': formatNullWebDate(begin),
      'end': formatNullWebDate(end),
      'location_id' : location?.id.toString(),
      'status': status?.name,
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Slot>.from(l.map((model) => Slot.fromJson(model)));
}

Future<bool> event_create(Session session, Slot slot) async {
  final response = await http.post(
    server.uri('/member/event_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(slot),
  );

  return (response.statusCode == 200);
}

Future<bool> event_owner_condition(Session session, Slot slot) async {
  final response = await http.get(
    server.uri('/member/event_owner_condition', {
      'slot_id': slot.id.toString(),
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return false;

  return json.decode(utf8.decode(response.bodyBytes)) as bool;
}