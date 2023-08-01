// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'crypto.dart' as crypto;
import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/json/right.dart';
import 'package:cptclient/json/credential.dart';

Future<List<User>> user_list(Session session) async {
  final response = await http.get(
    server.uri('/member/user_list'),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(list.map((model) => User.fromJson(model)));
}

Future<User?> user_info(Session session) async {
  final response = await http.get(
    server.uri('/member/user_info'),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  return User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
}

Future<Right?> right_info(Session session) async {
  final response = await http.get(
    server.uri('/member/user_right'),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  return Right.fromJson(json.decode(utf8.decode(response.bodyBytes)));
}

Future<bool> put_password(Session session, String password) async {
  if (password.isEmpty) return false;
  if (password.length < 6) return false;

  String salt = crypto.generateSaltHex();
  Credential credential = Credential(session.user!.key.toString(), crypto.hashPassword(password, salt), salt);

  final response = await http.post(
    server.uri('/member/user_password'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(credential),
  );

  return (response.statusCode == 200);
}