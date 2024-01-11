// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/static/format.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<List<Slot>> event_list(Session session, DateTime begin, DateTime end, Status? status, Location? location, User? owner) async {
  final response = await http.get(
    server.uri('/admin/event_list', {
      'begin': formatNullWebDate(begin),
      'end': formatNullWebDate(end),
      if (status != null) 'status': status.name,
      if (location != null) 'location_id': location.id.toString(),
      if (owner != null) 'owner_id': owner.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Slot>.from(l.map((model) => Slot.fromJson(model)));
}

Future<bool> event_accept(Session session, Slot slot) async {
  final response = await http.head(
    server.uri('/admin/event_accept', {
      'slot_id': slot.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_deny(Session session, Slot slot) async {
  final response = await http.head(
    server.uri('/admin/event_deny', {
      'slot_id': slot.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}