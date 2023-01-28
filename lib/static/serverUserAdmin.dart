// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';

Future<List<User>> user_list(Session session) async {
  final response = await http.get(
    Uri.http(server.serverURL, '/admin/user_list'),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(l.map((model) => User.fromJson(model)));
}

Future<bool> user_create(Session session, User user) async {
  final response = await http.post(
    Uri.http(server.serverURL, '/admin/user_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(user),
  );

  return (response.statusCode == 200);
}

Future<bool> user_edit(Session session, User user) async {
  final response = await http.post(
    Uri.http(server.serverURL,  '/admin/user_edit'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(user),
  );

  return (response.statusCode == 200);
}

Future<bool> user_delete(Session session, User user) async {
  final response = await http.head(
    Uri.http(server.serverURL, 'user_delete', {'user_id': user.id.toString()}),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
