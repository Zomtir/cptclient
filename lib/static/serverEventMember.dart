// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'navigation.dart' as navi;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/json/user.dart';

Future<List<Slot>> event_list(Session session, String status) async {
  final response = await http.get(
    Uri.http(navi.serverURL, '/member/event_list', {
      'status': status,
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Slot>.from(l.map((model) => Slot.fromJson(model)));
}

Future<bool> event_owner_condition(Session session, Slot slot) async {
  final response = await http.head(
    Uri.http(navi.serverURL, '/member/event_owner_condition', {
      'slot_id': slot.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200 && bool.fromEnvironment(response.body, defaultValue: false));
}