// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'navigation.dart' as navi;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';

Future<bool> class_create(Session session, Slot slot) async {
  final response = await http.post(
    Uri.http(navi.serverURL, '/admin/class_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(slot),
  );

  return (response.statusCode == 200);
}

Future<bool> class_edit(Session session, Slot slot) async {
  final response = await http.post(
    Uri.http(navi.serverURL, '/admin/class_edit'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(slot),
  );

  return (response.statusCode == 200);
}

Future<bool> class_delete(Session session, Slot slot) async {
  final response = await http.head(
    Uri.http(navi.serverURL, '/admin/class_edit', {'slot_id': slot.id.toString()}),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
