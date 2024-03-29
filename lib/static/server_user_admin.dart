// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/static/crypto.dart' as crypto;
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<List<User>> user_list(Session session) async {
  final response = await http.get(
    server.uri('/admin/user_list'),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(l.map((model) => User.fromJson(model)));
}

Future<User?> user_detailed(Session session, User user) async {
  final response = await http.get(
    server.uri('/admin/user_detailed', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  return User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
}

Future<bool> user_create(Session session, User user) async {
  final response = await http.post(
    server.uri('/admin/user_create'),
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
    server.uri('/admin/user_edit', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(user),
  );

  return (response.statusCode == 200);
}

Future<bool?> user_edit_password(Session session, User user, String password) async {
  if (password.isEmpty) return null;
  if (password.length < 6) return false;

  String salt = crypto.generateSaltHex();
  Credential credential = Credential(user.key.toString(), crypto.hashPassword(password, salt), salt);

  final response = await http.post(
    server.uri('/admin/user_edit_password', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(credential),
  );

  return (response.statusCode == 200);
}

Future<bool> user_delete(Session session, User user) async {
  final response = await http.head(
    server.uri('/admin/user_delete', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
